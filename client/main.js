import React from 'react';
import { Meteor } from 'meteor/meteor';
import { render } from 'react-dom';

// methods need to be imported here to enable client simulation
// import './../imports/api/users/userController';

import App from '../imports/ui/App.js';
 
Meteor.startup(() => {
  render(<App />, document.getElementById('root'));
});