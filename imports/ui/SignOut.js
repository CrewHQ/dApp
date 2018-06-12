import React, { Component } from 'react';
import { Meteor } from 'meteor/meteor';
import { Redirect } from "@reach/router";
import { withTracker } from 'meteor/react-meteor-data';

class SignOut extends Component {
  constructor() {
    super();
  }

  componentDidMount() {
    Meteor.logout();
  }

  render() {
    const { currentUser } = this.props;

    if (currentUser) {
      return (
        <div>
          <h1>Signing out...</h1>
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
})(SignOut)