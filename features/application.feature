Feature: Application
  In order to see the website
  As a guest
  I want to test if there is no error and there is a copyright message
  
  Scenario: Display a copyright message on the startpage
    Given I am on the home page
    Then I should see "copyright"
    And I should see "Log in"
    And I should not see "Error"
    And I should be on the home page

  @focus
  Scenario: Get latest commentables as RSS-Feed
    Given I am on the rss feed
    Then I should see "TEST WITH RSS FEED"
    And I should see "tag:www.example.com"

    