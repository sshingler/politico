Feature
  In order to check the sanity of our model definitions
  I want to create a stack of models
  And perform some operations on them

  Scenario: Find today's items
    When I request items for today
    Then I should add them to the database
    And I should be able to read the tags back

  Scenario: Find how many times the tag "health" has been recorded 

  Scenario: Find the 10 most popular tags

  Scenario: Find the 10 most popular tags for the Labour party

  Scenario: Find the 10 most popular tags for the Labour party in a given category