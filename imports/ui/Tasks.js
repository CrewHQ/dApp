import React, { Component } from 'react';
import { Meteor } from 'meteor/meteor';
import { Redirect } from "@reach/router";

export default class Tasks extends Component {
  constructor() {
    super();

    this.state = {
      viewState: 'loading'
    }
  }

  render() {
    if (Meteor.userId()) {
      return (
        <div>
          <h1>Pick a task</h1>
        </div>
      )
    } else {
      return <Redirect to="/signin" noThrow />
    }
  }
}