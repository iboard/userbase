Feature: Episodes
  In order to view and maintain episodes
  As a guest and user
  I want to see episodes as guest and I want manage episodes as admin|owner
  
  Background:
    Given the following user records
      | id | email            | nickname  | roles_mask | password   | password_confirmation | confirmation_token | confirmed_at |
      | 1  | test@test.te     | tester    | -1         | verysecret | verysecret            | 1234               | 2001-01-01   |
  
  Scenario: Show latest Episodes on the episode page for a logged in user
    Given the following episode records
      | title       | user_id | description                        |
      | TestEpisode | 1       | This is just a test episode 31o864 |
    And I am logged in as user "test@test.te" with password "verysecret"
    And I am on the episodes page
    Then I should see "This is just a test episode 31o864"
    
  Scenario: Logged in user should create new episode
    Given I am logged in as user "test@test.te" with password "verysecret"
    And I visit the new episode page for user "1"
    And I fill in "episode_title" with "My new episode" 
    And I fill in "episode_description" with "Lorem ipsum"
    And I click on "Create Episode"
    Then I should see "Episode was successfully created"
    And I should see "Lorem ipsum"
    
  Scenario: User should be able to delete her episode
    Given the following episode records
      | title       | user_id | description                        |
      | TestEpisode | 1       | This is just a test episode 31o864 |
    And I am logged in as user "test@test.te" with password "verysecret"  
    And I visit the edit episode page for user "1" and episode "1"
    And I click on link "Destroy"
    Then I should not see "This is just a test episode 31o864"

  Scenario: Guest should not be able to edit Episodes
    Given the following episode records
      | title       | user_id | description                        |
      | TestEpisode | 1       | This is just a test episode 31o864 |
    And I visit the edit episode page for user "1" and episode "1"
    Then I should see "You are not authorized to access this page"

  Scenario: A Tag-cloud should be displayed on the welcome-page
    Given the following episode records
    | title       | user_id | description                        | tag_list                | access_read_mask |
    | TestEpisode | 1       | This is just a test episode 31o864 | EXperIment,experimental | 1                |
    And I am on the home page
    Then I should see "EXperIment"
    And I should see "experimental"

  Scenario: YouTube-Video should be rendered in inline
     Given the following episode records
       | title           | user_id | description           | video_web_url                              | access_read_mask |
       | YouTube Episode | 1       | Render YouTube Inline | http://www.youtube.com/watch?v=SfnpyJ3A3jY | 1                |
     And I visit the episode page for user "1" and episode "1"
     Then I should see "Render YouTube Inline"
     And I should see "Watch on YouTube"
     
   Scenario: Authors should see the +Episode button all the time
     Given I am logged in as user "test@test.te" with password "verysecret"
     And I am on the home page
     Then I should see "New Episode"
     