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

  # Escenarios adicionales según la historia de usuario

  Scenario: Token reutilizable para acceder a /contacts
    * callonce read('classpath:login.feature@appcontact_login')
    * def token = response.token
    * header Authorization = 'Bearer ' + token
    Given path '/contacts'
    When method GET
    Then status 200
    And match response == '#[]'  # puede ser una lista vacía u objetos

  Scenario: Login con credenciales inválidas (email incorrecto)
    Given path '/users/login'
    And request { email: 'wrong@email.com', password: #(validPassword) }
    When method POST
    Then status 401
    And match response.message == 'Incorrect email or password'

  Scenario: Login con credenciales inválidas (password incorrecta)
    Given path '/users/login'
    And request { email: #(validEmail), password: 'wrongPass123' }
    When method POST
    Then status 401
    And match response.message == 'Incorrect email or password'

  Scenario: Email inválido (sin @ y dominio)
    Given path '/users/login'
    And request { email: 'invalidemail', password: #(validPassword) }
    When method POST
    Then status 400
    And match response.message contains 'email'

  Scenario: Campos vacíos (email y password requeridos)
    Given path '/users/login'
    And request { email: '', password: '' }
    When method POST
    Then status 400
    And match response.message contains 'required' 

