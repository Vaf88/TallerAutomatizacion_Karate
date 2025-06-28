@regression @performance @appcontact_login
Feature: Login to App Contact

  Background:
    * url baseUrl
    * header Accept = 'application/json'

  # ✅ Escenario exitoso de login
  Scenario: Successful customer login
    Given path '/users/login'
    And request { email: 'valeria@gmail.com', password: 'Negro88Teamo' }
    When method POST
    Then status 200
    And match response ==
    """
    {
      user: {
        _id: '#regex[^[a-f0-9]{24}$]', 
        firstName: '#string',
        lastName: '#string',
        email: '#regex[^\\S+@\\S+\\.\\S+$]',
        __v: '#number'
      },
      token: '#notnull'
    }
    """

  # ❌ Escenario negativo con credenciales incorrectas
  Scenario: Login with incorrect credentials
    Given path '/users/login'
    And request { email: 'valeria@gmail.com', password: 'incorrectPassword' }
    When method POST
    Then status 401
    And match response ==
    """
    { message: '#string' }
    """

  # 🔁 Escenario con múltiples usuarios válidos
  Scenario Outline: Login with multiple valid users
    Given path '/users/login'
    And request { email: '<email>', password: '<password>' }
    When method POST
    Then status 200
    And match response.token == '#notnull'
    And match response.user.email == '<email>'

    Examples:
      | email               | password        |
      | valeria@gmail.com   | Negro88Teamo    |
      | prueba1@mail.com    | Pass123!        |
      | test2@correo.com    | SecretPass456   |
