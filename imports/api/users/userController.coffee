import { Meteor } from 'meteor/meteor';
import { Accounts } from 'meteor/accounts-base';

Meteor.methods
  'user.signup': (email, password) ->
    console.log 'running', email, password