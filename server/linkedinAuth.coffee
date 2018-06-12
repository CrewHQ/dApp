passport = require('passport')
moment = require 'moment'
LinkedInStrategy = require('passport-linkedin-oauth2').Strategy
session = require('express-session')
import express from 'express';

app = express()

app.use(session({ 
  resave: false,
  saveUninitialized: true,
  secret: 'bla bla bla' 
  cookie : { secure: false }  
}));

app.use(passport.initialize())
app.use(passport.session())


passport.use(new LinkedInStrategy(
    clientID: Meteor.settings.linkedin.key,
    clientSecret: Meteor.settings.linkedin.secret
    passReqToCallback: true
    profileFields: [
      "id",
      "formatted-name",
      "first-name",
      "last-name",
      "email-address",
      "picture-url",
      "public-profile-url",
      "num-connections",
      "num-connections-capped"
    ],
    scope: ['r_basicprofile', 'r_emailaddress', 'rw_company_admin', 'w_share'],
    callbackURL: "#{getBaseUrl()}auth/linkedin/callback"  
  ,
    Meteor.bindEnvironment((req, accessToken, refreshToken, profile, done) =>
      # here we disect userId and projectId from the state again
      [ userId, projectId, type ] = req.query.state.split('-')

      # console.log accessToken, refreshToken, profile

      u = AppUser.findOne _id: userId
      project = Project.findOne _id: projectId

      # we only add this provider if it isn't already there
      existingLinkedIn = _.find(u?.providers, (p) -> p.id is profile.id)

      unless existingLinkedIn
        # construct provider object
        provider = new Provider
        provider.set
          id: profile.id
          provider: 'linkedin'
          name: profile.displayName
          thumbnailUrl: profile._json.pictureUrl
          reach: profile._json.numConnections
          access_token: accessToken  
          token_secret: undefined
          expires: moment().add(60, 'days').toDate()
          activeInProjects: [ projectId ]
          deleted: false

        # now we connect / activate the network for the user
        u.providers.push provider

        _Activities.create
          title: "Social reach increased by #{provider.reach}!"
          type: ActivityTypes['activated social media account']
          accountId: project.accountId
          projectId: projectId
          userId: u._id
          meta:
            provider: 'LinkedIn'
            reach: provider.reach   
          
      else
        # if provider already exists, we make it active in the project
        for p in u?.providers
          if p.id is profile.id
            p.id = profile.id
            p.name = profile.displayName
            p.access_token = accessToken
            p.token_secret = undefined
            p.expires = moment().add(60, 'days').toDate()
            p.reach = profile._json.numConnections
            p.thumbnailUrl = profile._json.pictureUrl
            p.needsReconnect = false
            p.deleted = false

            if p.activeInProjects.indexOf(projectId) < 0            
              p.activeInProjects.push projectId   

              _Activities.create
                title: "Social reach increased by #{p.reach}!"
                type: ActivityTypes['activated social media account']
                accountId: project.accountId
                projectId: projectId
                userId: u._id 
                meta:
                  provider: 'LinkedIn'
                  reach: p.reach

      # now we sync the company pages and the full user profile
      u = Meteor.call 'syncLinkedIn', u
      u.save()

      done(null, u)
    )
))


app.get '/auth/linkedin/:userId/:projectId/:type', (req,res,next) ->
  # For linkedin we pass userId and projectId as state
  # It cannot be on the callback route as the callback must be fixed
  # And either way, passing state is required
  passport.authenticate('linkedin', { 
    state: req.params.userId + "-" + req.params.projectId + "-" + req.params.type
  })(req,res,next)


app.get '/auth/linkedin/callback/', (req, res, next) ->
  passport.authenticate('linkedin', (err, user) =>
    [ userId, projectId, type ] = req.query.state.split('-')
    authRedirect(user, type, 'LinkedIn', err, res)
  )(req,res,next)

WebApp.connectHandlers.use(app)


###
# Get the user profile
#   @accessToken: user facebook access token
#   @profile: facebook user profile
###

_getProfileChanges = (accessToken, profile) ->
  try
    resp = HTTP.get "https://api.linkedin.com/v1/people/~:(id,formatted-name,num-connections,picture-url)?format=json",
      headers:
        Authorization: "Bearer " + accessToken

    if resp.error
      return {
        error: true
        id: profile.id
      }
    else
      resp.data    

  catch e
    Log.error 'error linkedin sync', e
    return {
      error: true
      id: profile.id
    }    
###
# Sync pages info for a specific user
#
# @accessToken: user facebook accessToken
# @inCompanies: inCompanies from the user model
#
###

_getCompanyChanges = (linkedInId, accessToken, inCompanies) ->
  # first we get a list of all the companies the user is admin of
  updatedCompanies = []
  
  try
    resp = HTTP.get "https://api.linkedin.com/v1/companies?format=json&is-company-admin=true",
      headers:
        Authorization: "Bearer " + accessToken

    # then for each company we fetch the details and store those
    if resp.data._total > 0
      for company in resp.data.values
        existingCompany = _.find inCompanies, (p) -> p.id is company.id

        try
          details = HTTP.get "https://api.linkedin.com/v1/companies/#{company.id}:(id,name,num-followers,logo-url,employee-count-range)?format=json",
            headers:
              Authorization: "Bearer " + accessToken  

          newCompany = new InCompany

          newCompany.id = company.id
          newCompany.name = details.data.name
          newCompany.thumbnailUrl = details.data.logoUrl
          newCompany.reach = details.data.numFollowers
          newCompany.parentId = linkedInId

          if existingCompany
            # the company exists in PS, but it might be deleted
            newCompany.deleted = existingCompany.deleted
            newCompany.activeInProjects = existingCompany.activeInProjects
          else
            # the company exists on LinkedIn, but not on PostSpeaker
            # it must be a new company
            newCompany.deleted = false
            newCompany.activeInProjects = []      

          updatedCompanies.push newCompany

        catch e
          Log.error "error fetching company information for #{company.id} - linkedInId #{linkedInId}", e
    
    # console.log 'updatedCompanies', updatedCompanies
    updatedCompanies        

  catch e
    Log.error 'error syncing LinkedIn companies', e
    return updatedCompanies



###
# Meteor.methods for Facebook
# @u : AppUser Class
#
# Note: This cannot be called from the client! 
###


Meteor.methods
  'syncLinkedIn': (u) ->
    u = u || AppUser.findOne(_id: @userId)

    linkedIns = u.userLinkedIns()

    updatedCompanies = []

    for linkedIn in linkedIns
      # we don't / can't check for legacy access_tokens
      unless _.isObject(linkedIn.access_token)
        change = _getProfileChanges(linkedIn.access_token, linkedIn)

        if change.error
          for p in u.providers
            if p.id is change.id
              p.access_token = undefined
              p.token_secret = undefined
              p.needsReconnect = true
              p.activeInProjects = []            
        else      
          # we are only interested in updating friend count, thumbnail and name
          # OPTIONAL: could update account and sync pages...
          for p in u.providers
            if p.id is change.id
              p.reach = change.numConnections
              p.thumbnailUrl = change.pictureUrl
              p.name = change.formattedName

          # sync pages
          updatedCompanies = updatedCompanies.concat _getCompanyChanges(linkedIn.id, linkedIn.access_token, u.inCompanies)

    u.inCompanies = updatedCompanies

    try
      Mixpanel.identify
        'LinkedIn': _.filter(u.providers, (p) -> p.activeInProjects?.length > 0 and p.provider is 'linkedin').length
        'Company pages': _.filter(u.inCompanies, (p) -> p.activeInProjects?.length > 0).length
      , 
        u._id
    catch e
      Log.error "Mixpanel error: could not push updated social network counts to Mixpanel ", e


    return u

