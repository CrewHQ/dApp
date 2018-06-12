import { Class, Union } from 'meteor/jagi:astronomy'

@AppUsers = new Mongo.Collection 'appUsers'

@AppUser = Class.create
  name: "AppUser"
  collection: Meteor.users
  fields:
    name:
      type: String
      optional: true
    emails:
      type: [Object]
      default: -> []
      optional: true
    services:
      type: Object
      default: -> {}
      optional: true
    profile:
      type: Object
      default: -> {}
      optional: true
    profileUrl:
      type: String
      optional: true
    phone:
      type: String
      optional: true

    accountIds:
      type: [ String ]
      optional: true
      index: 1      

    roles:
      type: Object
      default: -> {}

    providers:
      type: [ Provider ]
      optional: true
      default: -> []

    fbPages:
      type: [ FBPage ]
      optional: true
      default: -> []

    inCompanies:
      type: [ InCompany ]
      optional: true
      default: -> []

    unsubsubscribedFromLists:
      type: [ String ]
      optional: true
      default: -> []

    deleted:
      type: Boolean
      default: -> false
      index: 1

    isFirstTime:
      type: Boolean
      default: -> true

    invitedBy:
      type: String
      optional: true
    invitedByName:
      type: String
      optional: true
    invitedByAvatar:
      type: String
      optional: true

    timezone:
      type: String
      optional: true         

    migrations: 
      type: [String]
      optional: true
      default: -> []

    lastLogin:
      type: Date
      optional: true

    points:
      type: Number
      optional: true
      default: -> 0

    activities: 
      type: Number
      optional: true
      default: -> 0


  behaviors:
    timestamp:
      hasCreatedField: true
      createdFieldName: 'createdAt'
      hasUpdatedField: true
      updatedFieldName: 'updatedAt'

    softremove:
      removedFieldName: 'deleted'
      hasRemovedAtField: true
      removedAtFieldName: 'removedAt'