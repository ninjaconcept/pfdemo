Feature: Current user data
  In order to self maintain user information
  As a signed in user
  I want to interact with my user data
  
  Background:
    Given a user exists with email: "stefan@lesscode.de", password: "supersecret"
    And I am logged in with "stefan@lesscode.de/supersecret"

  @focus
  Scenario: Edit data form
    When I follow "Edit registration"
    Then I should be on "/users/edit"
    And I should see "Edit User"
    And the "Email" field should contain "stefan@lesscode.de"
    And I should see "Password (leave blank if you don't want to change it)"
    And I should see "Password confirmation"
    And I should see "Current password (we need your current password to confirm your changes)"
    And I should see "Cancel my account"


  Scenario: Just press update (fail)
    And I am on "/users/edit"
    When I press "Update"
    Then I should see "1 error prohibited this user from being saved"
    And I should be on "/users"
  
  
  Scenario: Just press update (success)
    And I am on "/users/edit"
    And I fill in "Current password" with "supersecret"
    When I press "Update"
    Then I should see "You updated your account successfully."
    And I should be on "/users/edit"
    
  
  Scenario: Update data (fail)
    And I am on "/users/edit"
    And I fill in "Password" with "supersecret"
    When I press "Update"
    Then I should see "1 error prohibited this user from being saved"
    And I should be on "/users"


  Scenario: Update data (success)
    And I am on "/users/edit"
    And I fill in "Password" with "supersecret2"
    And I fill in "Password confirmation" with "supersecret2"
    And I fill in "Current password" with "supersecret"
    When I press "Update"
    Then I should see "You updated your account successfully."
    And I should be on "/users/edit"

    
  Scenario: Cancel my account
    And I am on "/users/edit"
    When I follow "Cancel my account"
    Then I should see "Bye! Your account was successfully cancelled. We hope to see you again soon."
    And I should be on "/"
    When I am on "/users/sign_in"
    And I fill in "Email" with "supersecret2"
    And I fill in "Password" with "supersecret"
    When I press "Sign in"
    Then I should see "Invalid email or password."
    