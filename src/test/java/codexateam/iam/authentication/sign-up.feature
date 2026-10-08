Feature: User Authentication - Sign Up (IAM Bounded Context)

  Background:
    * url baseUrl

  Scenario: Registro exitoso de un nuevo Arrendatario (ROLE_ARRENDATARIO)
    * def uniqueEmail = 'renter_' + java.util.UUID.randomUUID() + '@renticar.com'
    * def signUpPayload =
      """
      {
        "name": "Bruce Via",
        "email": '#(uniqueEmail)',
        "password": "Password123!",
        "role": "arrendatario"
      }
      """
    Given path '/api/v1/authentication', 'sign-up'
    And request signUpPayload
    When method post
    Then status 201
    And match response contains { id: '#number', name: 'Bruce Via', email: '#(uniqueEmail)' }
    And match response.roles contains 'ROLE_ARRENDATARIO'

  Scenario: Registro exitoso de un nuevo Arrendador (ROLE_ARRENDADOR)
    * def uniqueEmail = 'owner_' + java.util.UUID.randomUUID() + '@renticar.com'
    * def signUpPayload =
      """
      {
        "name": "Estefano Solis",
        "email": '#(uniqueEmail)',
        "password": "Password123!",
        "role": "arrendador"
      }
      """
    Given path '/api/v1/authentication', 'sign-up'
    And request signUpPayload
    When method post
    Then status 201
    And match response contains { id: '#number', name: 'Estefano Solis', email: '#(uniqueEmail)' }
    And match response.roles contains 'ROLE_ARRENDADOR'

  Scenario: Intento de registro con correo ya existente (Fallo de Negocio 409/400)
    * def duplicateEmail = 'duplicate_' + java.util.UUID.randomUUID() + '@renticar.com'
    * def initialPayload =
      """
      {
        "name": "Usuario Inicial",
        "email": '#(duplicateEmail)',
        "password": "Password123!",
        "role": "arrendatario"
      }
      """
    Given path '/api/v1/authentication', 'sign-up'
    And request initialPayload
    When method post
    Then status 201

    Given path '/api/v1/authentication', 'sign-up'
    And request initialPayload
    When method post
    Then assert responseStatus == 400 || responseStatus == 409

  Scenario: Intento de registro con formato de correo inválido (Validación de Esquema)
    * def invalidPayload =
      """
      {
        "name": "Invalido",
        "email": "not-an-email",
        "password": "Password123!",
        "role": "arrendatario"
      }
      """
    Given path '/api/v1/authentication', 'sign-up'
    And request invalidPayload
    When method post
    Then assert responseStatus == 400 || responseStatus == 422
