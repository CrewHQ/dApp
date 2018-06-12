import React, { Component } from 'react';
import { Meteor } from 'meteor/meteor';
import { Accounts } from 'meteor/accounts-base';
import { TimezonePicker } from 'meteor/joshowens:timezone-picker';
import { Redirect } from "@reach/router";

console.log(TimezonePicker)

// Join component - sign up
export default class Join extends Component {
  constructor() {
    super();

    this.state = {
      email: "",
      password: "",
      verifyPassword: "",
      signedIn: false
    }
  }

  handleEmailChange = (e) => {
    this.setState({ email: e.target.value.trim() });
  }
  
  handlePasswordChange = (e) => {
    this.setState({ password: e.target.value.trim() });
  }

  
  handleVerifyPasswordChange = (e) => {
    this.setState({ verifyPassword: e.target.value.trim() });
  }  
  
  handleSubmit = (e) => {
    e.preventDefault();
    const { email, password, verifyPassword } = this.state;
    const user = { 
      email: email, 
      password: password,
      timezone: TimezonePicker.detectedZone()      
    };

    Meteor.callPromise('user.signup', user)
      .then((verificationToken) => {
        Accounts.verifyEmail(verificationToken, (err) => {
          if(err) {
            console.error('could not verify token')
          } else {
            console.log('signed in!')
            this.setState({ signedIn: true });
          }
        })
      })
      .catch((e) => console.error('could not signup user', e))
  }

  render() {
    const { email, password, verifyPassword, signedIn } = this.state;
    const isValid = email.length > 0 && password.length > 0 && password == verifyPassword;

    if (signedIn) {
      return <Redirect to="/tasks" noThrow/>
    } else {
      return(
        <div className="container">
          <header>
            <h1>Join Crew</h1>
            <p>Enter your email address to join Crew</p>
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
              autoComplete='new-password'      
            />

            <label>Verify password</label>                    
            <input 
              type="password" 
              placeholder="verify password"
              onChange={this.handleVerifyPasswordChange}  
              autoComplete='verify-new-password'      
            />

            <button 
              disabled={!isValid}
            >
              Join Crew!
            </button>
          </form>
        </div>
      )
    }
  }
}