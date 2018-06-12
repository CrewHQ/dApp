import { Meteor } from 'meteor/meteor';
import { Random } from 'meteor/random';
import { Accounts } from 'meteor/accounts-base'
import AppUser from './../../../both/userModel'

Accounts.onCreateUser (options, user) ->
  user.services.email = {}
  user.services.email.verificationTokens = []

  user.services.email.verificationTokens[0] = {
    token: Random.hexString(60)
    address: options.email
    when: new Date()
  }

  user.userName = options.userName
  user.roles = options.roles
  user.profileUrl = '/user-disappeared-icon.png'
  user.invitedBy = options.invitedBy
  user.invitedByName = options.invitedByName
  user.invitedByAvatar = options.invitedByAvatar
  user.timezone = options.timezone
  user.isFirstTime = options.isFirstTime

  user.accountIds = options.accountIds

  return user


Meteor.methods
  'user.signup': (user) ->
    console.log 'running', user

    user = 
      userName: ""
      email: user.email
      password: user.password
      roles: ['member']  
      isFirstTime: true
      timezone: user.timezone
      isFirstTime: true

    console.log('user', user)

    userId = Accounts.createUser user

    user = AppUser.findOne _id: userId

    return user.services.email.verificationTokens?[0]?.token          