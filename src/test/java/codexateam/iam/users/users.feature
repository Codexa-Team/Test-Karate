Feature: Users Management (IAM Bounded Context)

  Background:
    * url baseUrl

  Scenario: Consultar catálogo de usuarios del sistema
    Given path '/api/v1/users'
    When method get
    Then status 200
    And match response == '#array'

  Scenario: Consultar usuario por ID existente
    * def uniqueEmail = 'fetch_' + java.util.UUID.randomUUID() + '@renticar.com'
    Given path '/api/v1/authentication', 'sign-up'
    And request { name: 'Fetch User', email: '#(uniqueEmail)', password: 'Password123!', role: 'arrendatario' }
    When method post
    Then status 201
    * def createdId = response.id

    Given path '/api/v1/users', createdId
    When method get
    Then status 200
    And match response.id == createdId
    And match response.email == uniqueEmail
