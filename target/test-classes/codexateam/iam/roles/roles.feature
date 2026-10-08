Feature: Roles Management (IAM Bounded Context)

  Background:
    * url baseUrl

  Scenario: Obtener listado de roles del sistema
    Given path '/api/v1/roles'
    When method get
    Then status 200
    And match response == '#array'
    And match response[*].name contains 'ROLE_ARRENDADOR'
    And match response[*].name contains 'ROLE_ARRENDATARIO'
