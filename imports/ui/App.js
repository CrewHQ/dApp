import React, { Component } from 'react';
import Join from './Join.js';
import SignIn from './SignIn.js';

// App component - represents the whole app
export default class App extends Component {
  constructor() {
    super();

    this.state = {}
  }

  render() {
    return (
      <div className="container">
        <Join/>

        <hr/>
        
        <SignIn/>
      </div>
    );
  }
}