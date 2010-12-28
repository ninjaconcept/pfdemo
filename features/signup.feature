Feature: Signup
  In order to access restricted pages
  As a registered user
  I want to signup
  
  
  Scenario: Signup form
    Given I am on the home page
    When I am on "/users/sign_up"
    Then I should see "Sign up"
    And I should see "Email"
    And I should see "Password"
    And I should see "Password confirmation"
    And I should see "Sign up"
    And I should see "Sign in"
    And I should see "Forgot your password?"
    And I should see "Didn't receive unlock instructions?"
  
  
  Scenario: Sign up with valid data
    Given I am on "/users/sign_up"
    And I fill in the following:
      | Email                 | stefan@lesscode.de |
      | Password              | superpass          |
      | Password confirmation | superpass          |
    When I press "Sign up"
    Then I should see "You have signed up successfully. If enabled, a confirmation was sent to your e-mail."
    And I should be on "/"
    And I should see "Welcome home"
  

  Scenario Outline: Signup with invalid data
    Given I am on "/users/sign_up"
    And I fill in the following:
      | Email                 | <email>                 |
      | Password              | <password>              |
      | Password confirmation | <password_confirmation> |
    When I press "Sign up"
    And I should see "<error_message>"
    And I should be on "/users"
    
    Examples:
      | email              | password   | password_confirmation | error_message                                  |
      |                    |            |                       | 2 errors prohibited this user from being saved |
      | stefan@lesscode.de |            |                       | 1 error prohibited this user from being saved  |
      | stefan@lesscode.de | superpass  |                       | 1 error prohibited this user from being saved  |
      | stefan@lesscode.de | superpass  | superpass1            | 1 error prohibited this user from being saved  |
      | stefan@lesscode.de | superpass1 | superpass             | 1 error prohibited this user from being saved  |
  
  