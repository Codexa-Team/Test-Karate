Feature: Vehicle Listings Management (Listings Bounded Context)

  Background:
    * url baseUrl

  Scenario: Consultar catálogo general de vehículos disponibles
    Given path '/api/v1/vehicles'
    When method get
    Then status 200
    And match response == '#array'

  Scenario: Consultar vehículo por ID inexistente (Fallo 404)
    Given path '/api/v1/vehicles', 999999
    When method get
    Then assert responseStatus == 404 || responseStatus == 400

  Scenario: Intentar crear vehículo sin cabecera de autorización (Fallo 401/403)
    Given path '/api/v1/vehicles'
    And request { brand: 'Toyota', model: 'Corolla', year: 2022, pricePerDay: 50.0 }
    When method post
    Then assert responseStatus == 401 || responseStatus == 403
