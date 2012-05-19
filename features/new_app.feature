Feature: Provisioning a Heroku App
  In order to self serve myself an app
  I want to click on a button
  And have my own heroku app.

  Scenario: Pressing a button gives me a new heroku app
    Given I am on the home page
    And I follow "Make a new app!"
    Then I should see "New App Created!"