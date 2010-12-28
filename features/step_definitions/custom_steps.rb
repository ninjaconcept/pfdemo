Given /^I am logged in with "([^"]*)\/([^"]*)"$/ do |email, password|
  And %{I am on "/users/sign_in"}
  And %{I fill in "user_email" with "#{email}"}
  And %{I fill in "user_password" with "#{password}"}
  And %{I press "Sign in"}
end

Then /^I should see the following table at "([^"]*)":$/ do |selector, expected_table|
  expected_table.diff!(tableish("table#{selector} tr", 'th,td'))
end

Given /^no ([^"]*) exists$/ do |model|
  model.classify.constantize.destroy_all
end