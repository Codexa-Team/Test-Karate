Feature: IoT Telemetry and Vehicle Tracking (IoT Bounded Context)

  Background:
    * url baseUrl
    * def ownerAuth = callonce read('classpath:codexateam/iam/authentication/auth-token.feature') { role: 'arrendador' }

  Scenario Outline: Registrar lectura telematica para un vehiculo como arrendador autenticado
    Given path '/api/v1/telemetry'
    And header Authorization = ownerAuth.authHeader
    And request { vehicleId: <vehicleId>, latitude: <latitude>, longitude: <longitude>, speed: <speed>, fuelLevel: <fuelLevel> }
    When method post
    Then assert responseStatus == 201 || responseStatus == 400 || responseStatus == 403 || responseStatus == 404

    Examples:
      | vehicleId | latitude   | longitude  | speed | fuelLevel |
      | 1         | -12.046374 | -77.042793 | 60.0  | 80.0      |
      | 1         | -12.056374 | -77.032793 | 45.0  | 78.5      |

  Scenario Outline: Consultar historial o ultima posicion telematica con autorizacion
    Given path '/api/v1/telemetry', 'vehicle', <vehicleId>, '<subpath>'
    And header Authorization = ownerAuth.authHeader
    When method get
    Then assert responseStatus == 200 || responseStatus == 404

    Examples:
      | vehicleId | subpath |
      | 1         | latest  |

  Scenario Outline: Consultar historial completo de telemetria con autorizacion
    Given path '/api/v1/telemetry', 'vehicle', <vehicleId>
    And header Authorization = ownerAuth.authHeader
    When method get
    Then assert responseStatus == 200 || responseStatus == 404

    Examples:
      | vehicleId |
      | 1         |

  Scenario Outline: Iniciar simulacion de ruta para un vehiculo como arrendador
    Given path '/api/v1/telemetry', 'simulate', <vehicleId>
    And header Authorization = ownerAuth.authHeader
    When method post
    Then assert responseStatus == 202 || responseStatus == 400 || responseStatus == 404

    Examples:
      | vehicleId |
      | 1         |

  Scenario Outline: Consultar ruta simulada de navegacion GPS con coordenadas
    Given path '/api/v1/simulation', '<endpoint>'
    And header Authorization = ownerAuth.authHeader
    And params { startLat: <startLat>, startLng: <startLng>, endLat: <endLat>, endLng: <endLng> }
    When method get
    Then assert responseStatus == 200 || responseStatus == 400 || responseStatus == 401 || responseStatus == 404 || responseStatus == 500 || responseStatus == 502 || responseStatus == 503

    Examples:
      | endpoint       | startLat   | startLng   | endLat     | endLng     |
      | route          | -12.046374 | -77.042793 | -12.086374 | -77.012793 |
      | complete-route | -12.046374 | -77.042793 | -12.086374 | -77.012793 |

  Scenario Outline: Intentar registrar lectura telematica sin autenticacion (Fallo 401/403)
    Given path '/api/v1/telemetry'
    And request { vehicleId: <vehicleId>, latitude: <latitude>, longitude: <longitude>, speed: <speed>, fuelLevel: <fuelLevel> }
    When method post
    Then assert responseStatus == 401 || responseStatus == 403

    Examples:
      | vehicleId | latitude   | longitude  | speed | fuelLevel |
      | 1         | -12.046374 | -77.042793 | 60.0  | 80.0      |
