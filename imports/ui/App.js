import React, { Component } from 'react';
import Join from './Join.js';
import SignIn from './SignIn.js';
import SignOut from './SignOut.js';
import Tasks from './Tasks.js'
import { Router, Link } from "@reach/router";

// App component - represents the whole app
export default class App extends Component {
  constructor() {
    super();

    this.state = {}
  }

  render() {
    return (
      <Router>
        <Join path="/" />        
        <SignIn path="/signin" />
        <Tasks path="/tasks" />
        <SignOut path="/signout" />        
      </Router>
    );
  }
}