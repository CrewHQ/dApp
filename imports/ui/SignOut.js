import React, { Component } from 'react';
import { Meteor } from 'meteor/meteor';
import { Redirect } from "@reach/router";

export default class SignOut extends Component {
  constructor() {
    super();

    this.state = {
      loggedOut: false
    }
  }

  componentDidMount(){
    Meteor.logout(() => this.setState({ loggedOut: true }))
  }

  render() {
    if (!this.state.loggedOut) {
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