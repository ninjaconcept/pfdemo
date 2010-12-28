Feature: Session
  In order to access restricted pages
  As a signed in user
  I want to sign in
  
  Background:
    Given a user exists with email: "stefan@lesscode.de", password: "supersecret"
  
  
  Scenario Outline: Login fails
    Given I am on "/users/sign_in"
    And I fill in the following:
      | Email | <email> |
      | Password | <password> | 
    And I press "Sign in"
    Then I should see "Invalid email or password."
    And I should be on "/users/sign_in"
  
    Examples:
      | email              | password    |
      |                    |             |
      | oli                |             |
      | stefan@lesscode.de |             |
      | stefan@lesscode.de | bad pass    |
      |                    | supersecret |
      | oli                | supersecret |
  
  
  Scenario: Login with valid data
    Given I am on "/users/sign_in"
    And I fill in the following:
      | Email    | stefan@lesscode.de |
      | Password | supersecret        |
    And I press "Sign in"
    Then I should see "Signed in successfully."
    And I should be on "/users/edit"
    And I should see "Edit User"
    And I should see "Edit registration"
    And I should see "Logout"
    
    
  # Scenario: Logout
  #   Given I am logged in with "stefan@lesscode.de/supersecret"
  #   And I am on "/admin/pages"
  #   When I follow "Logout"
  #   Then I should see "Signed out successfully."
  #   And I should be on "/"
  #   And I should see "Welcome to SchulLV Demo"
    
    