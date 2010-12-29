Feature: Application
  In order to see the website
  As a guest
  I want to test if there is no error and there is a copyright message
 
  Background:
    Given the following user records
      | id | email            | nickname  | roles_mask | password   | password_confirmation | confirmation_token | confirmed_at |
      | 1  | test@test.te     | tester    | -1         | verysecret | verysecret            | 1234               | 2001-01-01   |
 
  
  Scenario: Display a copyright message on the startpage
    Given I am on the home page
    Then I should see "copyright"
    And I should see "Log in"
    And I should not see "Error"
    And I should be on the home page

  Scenario: Get latest commentables as RSS-Feed
    Given I am on the rss feed
    Then I should see "TEST WITH RSS FEED"
    And I should see "tag:www.example.com"

  Scenario: User should see Archive Links
    Given the following posting records
      | title       | user_id | body                               | access_read_mask | created_at       |
      | TestPosting | 1       | This is just a test posting 31o864 |       1          | 1964-08-31 06:00 |
    And the following episode records
      | title       | user_id | description                        | created_at |
      | TestEpisode | 1       | This is just a test episode 31o864 | 1964-08-31 06:00 |
    And I am on the home page  
    Then I should see "1964/8: 2 entries"

  Scenario: User should see the Archive page
    Given the following posting records
      | title       | user_id | body                               | access_read_mask | created_at       |
      | TestPosting | 1       | This is just a test posting 31o864 |       1          | 1964-08-31 06:00 |
    And the following episode records
      | title       | user_id | description                        | access_read_mask | created_at |
      | TestEpisode | 1       | This is just a test episode 31o864 |       1          | 1964-08-31 06:00 |
    And I am on the archive for "1964_8"
    Then I should see "TestPosting"
    And I should see "TestEpisode"
    
    