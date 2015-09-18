Feature: A goal list for zone objectives
  As a user
  I want to make a goal list for a zone
  So that I can plan which objectives to do

  Scenario: It should be possible to create a goal list by adding an objective
    Given a zone with 2 uncompleted quests
    And I visit the zone details page
    When I add an objective to the goal list
    Then the goal list should contain 1 objective

  Scenario: I should be able to add an objective to an existing goal list
    Given a goal list with 1 objective
    When I add an objective to the goal list
    Then the goal list should contain 2 objectives

  Scenario: I should be able to remove an objective from an existing goal list
    Given a goal list with 2 objectives
    When I remove an objective from the goal list
    Then the goal list should contain 1 objective

  Scenario: An objective removed from a goal list should still be on the page
    Given a goal list with 2 objectives
    When I remove an objective from the goal list
    Then I should see the removed objective
