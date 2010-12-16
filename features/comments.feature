Feature: Comments
  In order to comment postings
  As a user
  I want create comments for postings when I'm logged in

  Background:
    Given the following user records
      | id | email            | nickname  | roles_mask | password   | password_confirmation | confirmation_token | confirmed_at |
      | 1  | test@test.te     | tester    | 31         | verysecret | verysecret            | 1234               | 2001-01-01   |
    And the following posting records
        | id | user_id | title       | body               | access_read_mask |
        |  1 |    1    | My Posting  | My beautyfull body |        31        |
    And the following episode records
        | id | user_id | title       | description         |
        |  1 |    1    | My Episode  | Episode description |
    And no comment records  

  Scenario: unauthorized users should not see the add comment link on the posting page
    Given I am on the postings page
    Then I should not see "Add a comment"
    And I should see "No comments"

  Scenario: unauthorized users should not see the add comment link on the episode page
    Given I am on the episodes page
    Then I should not see "Add a comment"
    
  Scenario: unauthorized users should read comments
    Given the following comment records
      | id | commentable_id | commentable_type | user_id | comment          | email        | 
      |  1 | 1              | Posting          |    1    | My first comment | test@test.te |
    And I am on the postings page
    And I click on link "One comment"
    Then I should see "Posting: My Posting"
    And I should see "My Posting"
    And I should see "One comment"
    And I should see "My first comment"

  Scenario: unauthorized users should not read comments of episodes
    Given the following comment records
      | id | commentable_id | commentable_type | user_id | comment          | email        |
      |  1 | 1              | Episode          |    1    | My first comment | test@test.te |
    And I am on the episodes page
    And I should not see "My first comment"
    
  Scenario: authorized users should see the add comment link for postings
    Given I am logged in as user "test@test.te" with password "verysecret"
    And I am on the first posting page
    Then I should see "No comments"
    And I should see "Add a comment"
    

  Scenario: unauthorized users should not post comments on postings
    Given I visit "/users/1/postings/new"
    Then I should be redirected to the / page
    And I should see "You are not authorized to access this page"
    
  Scenario: unauthorized users should not post comments on episodes
    Given I visit "/users/1/episodes/new"
    Then I should be redirected to the / page
    And I should see "You are not authorized to access this page"

  Scenario: authorized user should post comments on postings
    Given I am logged in as user "test@test.te" with password "verysecret"
    And I visit "/users/1/postings/1/comments/new"
    And I fill in "comment_comment" with "This is a cucumber comment"
    And I click on "Create Comment"
    Then I should see "Comment was successfully created"
    And I should see "My Posting"
    And I should see "My beautyfull body"
    And I should see "One comment"
    And I should see "This is a cucumber comment"
    And I should see "tester, less than a minute ago"
    And I should see "Back"
    And I should see "All Postings"
    And I should see "Postings by tester"

  Scenario: authorized user should post comments on episodes
    Given I am logged in as user "test@test.te" with password "verysecret"
    And I visit "/users/1/episodes/1/comments/new"
    And I fill in "comment_comment" with "This is a cucumber comment"
    And I click on "Create Comment"
    Then I should see "Comment was successfully created"
    And I should see "My Episode"
    And I should see "Episode description"
    And I should see "One comment"
    And I should see "This is a cucumber comment"
    And I should see "tester, less than a minute ago"
    And I should see "Episode index"
