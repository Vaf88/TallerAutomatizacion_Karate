@appcontact_createcontact
Feature: Crear contacto en app contact

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * def emailContacto = 'jdoe@fake.com'
    * def loginPayload = { email: 'valeria@gmail.com', password: 'Negro88Teamo' }
    # Login y obtención del token
    Given path '/users/login'
    And request loginPayload
    When method POST
    Then status 200
    * def authToken = response.token

  Scenario: Crear contacto exitosamente
    * def contactData =
    """
    {
      "firstName": "Jonathan",
      "lastName": "Tercero",
      "birthdate": "1970-01-01",
      "email": "#(emailContacto)",
      "phone": "8005555555",
      "street1": "1 Main St.",
      "street2": "Apartment A",
      "city": "Anytown",
      "stateProvince": "KS",
      "postalCode": "12345",
      "country": "USA"
    }
    """
    Given path '/contacts'
    And header Authorization = 'Bearer ' + authToken
    And request contactData
    When method POST
    Then status 201

  Scenario: Validar que contacto creado aparece en lista
    Given path '/contacts'
    And header Authorization = 'Bearer ' + authToken
    When method GET
    Then status 200
    And match response[*].email contains emailContacto

  Scenario: Error al crear contacto con email duplicado
    * def duplicatedContact =
    """
    {
      "firstName": "OtroNombre",
      "email": "#(emailContacto)"
    }
    """
    Given path '/contacts'
    And header Authorization = 'Bearer ' + authToken
    And request duplicatedContact
    When method POST
    Then status 400
    And match response.message contains 'email'

  Scenario: Error al crear contacto sin campos obligatorios (firstName)
    * def invalidContact =
    """
    {
      "email": "otro@correo.com",
      "phone": "123456789"
    }
    """
    Given path '/contacts'
    And header Authorization = 'Bearer ' + authToken
    And request invalidContact
    When method POST
    Then status 400
    And match response.message contains 'firstName'

