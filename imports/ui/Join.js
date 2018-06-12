import React, { Component } from 'react';
import { Meteor } from 'meteor/meteor';
import { Accounts } from 'meteor/accounts-base'

console.log(Accounts)

// Join component - sign up
export default class Join extends Component {
  constructor() {
    super();

    this.state = {
      email: "",
      password: "",
      verifyPassword: ""
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
      email, 
      password: Accounts._hashPassword(password)
    };

    Meteor.callPromise('user.signup', user)
      .then((verificationToken) => {
        Accounts.verifyEmail(verificationToken, (err) => {
          if(err) {
            console.error('could not verify token')
          } else {
            console.log('signed in!')
          }
        })
      })
      .catch((e) => console.error('could not signup user', e))
  }

  render() {
    const { email, password, verifyPassword } = this.state;
    const isValid = email.length > 0 && password.length > 0 && password == verifyPassword;

    return (
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
          />

          <label>Password</label>          
          <input 
            type="password" 
            placeholder="password"
            onChange={this.handlePasswordChange}            
          />

          <label>Verify password</label>                    
          <input 
            type="password" 
            placeholder="verify password"
            onChange={this.handleVerifyPasswordChange}            
          />

          <button 
            disabled={!isValid}
          >
            Join Crew!
          </button>
        </form>
      </div>
    );
  }
}