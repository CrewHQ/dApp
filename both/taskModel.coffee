import { Class, Enum} from 'meteor/jagi:astronomy'

Tasks = new Mongo.Collection 'tasks'

TaskTypes = 


DateRange = Class.create
  name: "DateRange"
  fields:
    start:
      type: Date
      optional: true
      default: -> new Date()
    end:
      type: Date
      optional: true

export TaskTypes = Enum.create
  name: 'TaskTypes'
  identifiers: [
    'connect_social', 
    'submit_url', 
    'follow_us',
    'join_community',
    'free_input',
    'make_introduction'
  ]      

export Task = Class.create
  name: "Task"
  fields:
    type: 
      type: TaskTypes
      index: 1

    # inputs for creating task
    communityUrl:
      type: String
      optional: true
    title:
      type: String
      optional: true
    description: 
      type: String
      optional: true
    twitterHandle: 
      type: String
      optional: true    
    inPageUrl: 
      type: String
      optional: true   
    fbPageUrl: 
      type: String
      optional: true    
    instagramHandle: 
      type: String
      optional: true        

    # rewards
    rewardUnit:
      type: String
    reward:
      type: Number

    # availability
    availability:
      type: DateRange
      optional: true

    # targeting
    targetSkills:
      type: [ String ]
      optional: true

    # rules
    includeLinkRequired:
      type: Boolean
      default: -> false
    positiveSentimentRequired:
      type: Boolean
      default: -> false      
    uniqueIpRequired:
      type: Boolean
      default: -> false      
    minTextLengthRequired:
      type: Boolean
      default: -> false      
    minReachRequired:
      type: Number
      default: -> -1
    singleUsage:
      type: Boolean
      default: -> true                  