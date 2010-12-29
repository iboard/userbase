Feature: Postings
  In order to read and manage postings
  As an user
  I want to see, create, edit, and delete postings
  
  
  Background:
    Given the following user records
      | id | email            | nickname  | roles_mask | password   | password_confirmation | confirmation_token | confirmed_at |
      | 1  | test@test.te     | tester    | -1         | verysecret | verysecret            | 1234               | 2001-01-01   |
  
  Scenario: Display no postings on the startpage if there are no postings
    Given I am on the home page
    Then I should not see class "postings"
    
  Scenario: Show latest Postings on the start page
    Given the following posting records
      | title       | user_id | body                               | access_read_mask |
      | TestPosting | 1       | This is just a test posting 31o864 |       1          |
    And I am on the home page
    Then I should see "This is just a test posting 31o864"
    
  Scenario: Logged in user should create new posting
    Given I am logged in as user "test@test.te" with password "verysecret"
    And I visit the new posting page for user "1"
    And I fill in "posting_title" with "My new posting" 
    And I fill in "posting_body" with "Lorem ipsum"
    And I click on "Create Posting"
    Then I should see "Posting was successfully created"
    And I should see "Lorem ipsum"

  Scenario: User should be able to edit her posting
    Given the following posting records
      | id | user_id | title       | body               |
      |  1 |    1    | My Posting  | My beautyfull body |
    And I am logged in as user "test@test.te" with password "verysecret"  
    And I visit the edit posting page for user "1" and posting "1"
    And I fill in "posting_title" with "My modified posting"
    And I fill in "posting_body" with "Got six packs!"
    And I click on "Update Posting"
    Then I should see "Posting was successfully updated"
    And I should see "Got six packs!"
    And I should see "less than a minute ago"
    
  Scenario: User should be able to delete his posting
    Given the following posting records
      | id | user_id | title       | body               |
      |  1 |    1    | My Posting  | My beautyfull body |
    And I am logged in as user "test@test.te" with password "verysecret"  
    And I visit the edit posting page for user "1" and posting "1"
    And I click on link "Destroy"
    Then I should see "This user has no postings"

  Scenario: Guest should not be able to edit Postings
    Given the following posting records
      | id | user_id | title       | body               |
      |  1 |    1    | My Posting  | My beautyfull body |
    And I visit the edit posting page for user "1" and posting "1"
    Then I should see "You are not authorized to access this page"

  Scenario: A Tag-cloud should be displayed on the welcome-page
    Given the following posting records
      | title       | user_id | body                               | access_read_mask | tag_list   |
      | TestPosting | 1       | This is just a test posting 31o864 |       1          | EXperIment,experimental |
    And I am on the home page
    Then I should see "EXperIment"
    And I should see "experimental"
   
  Scenario: Authors should see the +Posting button all the time
    Given I am logged in as user "test@test.te" with password "verysecret"
    And I am on the home page
    Then I should see "New Posting"
      

