@appcontact_login
Feature: Login to app contact

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * def validEmail = 'valeria@gmail.com'
    * def validPassword = 'Negro88Teamo'

  Scenario: Customer Login
    Given path '/users/login'
    And request {"email": "valeria@gmail.com","password": "Negro88Teamo"}
    When method POST
    Then status 200
    And match response ==
    """
    {
    "user": {
        "_id": '#string',
        "firstName": '#string',
        "lastName": '#string',
        "email": '#string',
        "__v": '#number',
    },
    "token": '#string',
    }
    """

