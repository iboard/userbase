Feature: Blog
  In order to view entries as a blog
  As a guest or user
  I want to see episodes and postings as a blog
  
  Background:
    Given the following user records
      | id | email            | nickname  | roles_mask | password   | password_confirmation | confirmation_token | confirmed_at |
      | 1  | test@test.te     | tester    | -1         | verysecret | verysecret            | 1234               | 2001-01-01   |
    And the following episode records
      | title       | user_id | description                        | access_read_mask | tag_list |
      | TestEpisode | 1       | This is just a test episode 31o864 |      1           |  ataga     |
    And the following posting records
      | title       | user_id | body                               | access_read_mask | tag_list |
      | TestPosting | 1       | This is just a test posting 31o864 |       1          |  btagb     |
  
  Scenario: Show index as blog
    Given I am on the blog page
    Then I should see "This is just a test episode 31o864"
    And I should see "This is just a test posting 31o864"

  Scenario: Show index by tag
    Given I am on blog page for tag "ataga"
    Then I should see "This is just a test episode 31o864"
    And I should not see "This is just a test posting 31o864"
