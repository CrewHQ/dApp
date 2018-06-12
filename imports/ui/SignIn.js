import React, { Component } from 'react';
import { Meteor } from 'meteor/meteor';
import { Accounts } from 'meteor/accounts-base';
import { Redirect } from "@reach/router";

// SignIn component - sign in
export default class SignIn extends Component {
  constructor() {
    super();

    this.state = {
      email: "",
      password: "",
      signedIn: false      
    }
  }

  handleEmailChange = (e) => {
    this.setState({ email: e.target.value.trim() });
  }
  
  handlePasswordChange = (e) => {
    this.setState({ password: e.target.value.trim() });
  }

  handleSubmit = (e) => {
    e.preventDefault();
    const { email, password } = this.state;

    Meteor.loginWithPassword(email, password, (err, res) => {
      if(err) {
        console.error('could not sign in')
      } else {
        console.log('signed in!')
        this.setState({ signedIn: true });
      }
    })
  }

  render() {
    const { email, password, signedIn } = this.state;
    const isValid = email.length > 0 && password.length > 0;

    if (signedIn) {
      return <Redirect to="/tasks" noThrow/>
    } else {
      return (
        <div className="container">
          <header>
            <h1>Welcome back!</h1>
            <p>Enter your email address to sign in to Crew</p>
          </header>

          <form onSubmit={this.handleSubmit}>
            <label>Your email</label>
            <input 
              type="text" 
              placeholder="john@example.com"
              onChange={this.handleEmailChange}
              autoComplete='email'
            />

            <label>Password</label>          
            <input 
              type="password" 
              placeholder="password"
              onChange={this.handlePasswordChange}   
              autoComplete='current-password'         
            />

            <button 
              disabled={!isValid}
            >
              Sign in!
            </button>
          </form>
        </div>
      );
    }
  }
}