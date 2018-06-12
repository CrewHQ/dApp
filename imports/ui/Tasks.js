import React, { Component } from 'react';
import { Meteor } from 'meteor/meteor';
import { Redirect } from "@reach/router";
import { withTracker } from 'meteor/react-meteor-data';

class Tasks extends Component {
  constructor() {
    super();

    this.state = {
      viewState: 'loading'
    }
  }

  render() {
    const { currentUser } = this.props;

    if (currentUser) {
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

export default withTracker(props => {
  return {
    currentUser: Meteor.user()
  }
})(Tasks)