import { Class, Union } from 'meteor/jagi:astronomy'

AppUsers = new Mongo.Collection 'appUsers'

export FBPage = Class.create
  name: "FBPage"
  fields:
    id:
      type: String
      index: 1
      optional: true
    name:
      type: String
    thumbnailUrl:
      type: String
      optional: true
    reach:
      type: Number
      optional: true
    link:
      type: String
      optional: true
    deleted:
      type: Boolean
      default: -> false
      index: 1
    access_token:
      type: String    
      optional: true  
    page_token:
      type: String    
      optional: true        
    parentId:
      type: String
      optional: true

  behaviors:
    timestamp:
      hasCreatedField: true
      createdFieldName: 'createdAt'
      hasUpdatedField: true
      updatedFieldName: 'updatedAt'  


export InCompany = Class.create
  name: "InCompany"
  fields:
    id:
      type: Number
      index: 1
    name:
      type: String
    thumbnailUrl:
      type: String
      optional: true
    reach:
      type: Number
      optional: true
    deleted:
      type: Boolean
      default: -> false
      index: 1
    activeInProjects:
      type: [ String ]
      default: -> []  
    parentId:
      type: String
      optional: true      

  behaviors:
    timestamp:
      hasCreatedField: true
      createdFieldName: 'createdAt'
      hasUpdatedField: true
      updatedFieldName: 'updatedAt'  


StringOrNumber = Union.create
  name: 'StringOrNumber',
  types: [String, Number]

StringOrObject = Union.create
  name: 'StringOrObject',
  types: [String, Object]


export Provider = Class.create
  name: "Provider"
  fields:
    provider:
      type: String
    name:
      type: String
      optional: true
      default: -> 'No profile info available'
    twitterHandle:
      type: String
      optional: true
    id:
      type: StringOrNumber
      optional: true
    thumbnailUrl:
      type: String
      optional: true
    access_token:
      type: StringOrObject
      optional: true
    token_secret:
      type: String
      optional: true 
    expires:
      type: Date
      optional: true
    activeInProjects:
      type: [ String ]
      default: -> []
    reach:
      type: Number
      optional: true
      default: -> 0
    needsReconnect:
      type: Boolean
      default: -> false


export AppUser = Class.create
  name: "AppUser"
  collection: Meteor.users
  fields:
    userName:
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
    address:
      type: String
      optional: true
    
    avatar:
      type: String
      optional: true

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