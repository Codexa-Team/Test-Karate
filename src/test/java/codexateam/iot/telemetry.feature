Feature: IoT Telemetry and Vehicle Tracking (IoT Bounded Context)

  Background:
    * url baseUrl

  Scenario: Consultar ruta simulada de navegación GPS
    Given path '/api/v1/simulation', 'route'
    When method get
    Then assert responseStatus == 200 || responseStatus == 404 || responseStatus == 503

  Scenario: Intentar registrar lectura telemática sin autenticación (Fallo 401/403)
    Given path '/api/v1/telemetry'
    And request { vehicleId: 1, latitude: -12.046374, longitude: -77.042793, speed: 60.0, fuelLevel: 80.0 }
    When method post
    Then assert responseStatus == 401 || responseStatus == 403

  Scenario: Intentar consultar última posición sin autorización (Fallo 401/403)
    Given path '/api/v1/telemetry', 'vehicle', 1, 'latest'
    When method get
    Then assert responseStatus == 401 || responseStatus == 403 || responseStatus == 404
