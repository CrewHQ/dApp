import React, { Component } from 'react';
import Join from './Join.js';

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
      </div>
    );
  }
}