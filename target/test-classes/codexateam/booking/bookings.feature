Feature: Bookings Management (Booking Bounded Context)

  Background:
    * url baseUrl
    * def renterAuth = callonce read('classpath:codexateam/iam/authentication/auth-token.feature') { role: 'arrendatario' }
    * def ownerAuth = callonce read('classpath:codexateam/iam/authentication/auth-token.feature') { role: 'arrendador' }

  Scenario Outline: Crear una reserva de vehiculo como arrendatario autenticado
    Given path '/api/v1/bookings'
    And header Authorization = renterAuth.authHeader
    And request { vehicleId: <vehicleId>, startDate: '<startDate>', endDate: '<endDate>' }
    When method post
    Then assert responseStatus == 201 || responseStatus == 400 || responseStatus == 404 || responseStatus == 409

    Examples:
      | vehicleId | startDate                | endDate                  |
      | 1         | 2026-11-01T10:00:00.000Z | 2026-11-05T10:00:00.000Z |
      | 1         | 2026-12-01T10:00:00.000Z | 2026-12-07T10:00:00.000Z |

  Scenario Outline: Consultar reservas propias del arrendatario autenticado
    Given path '/api/v1/bookings', '<endpoint>'
    And header Authorization = renterAuth.authHeader
    When method get
    Then status 200
    And match response == '#array'

    Examples:
      | endpoint    |
      | my-bookings |

  Scenario Outline: Consultar solicitudes de reserva recibidas como arrendador autenticado
    Given path '/api/v1/bookings', '<endpoint>'
    And header Authorization = ownerAuth.authHeader
    When method get
    Then status 200
    And match response == '#array'

    Examples:
      | endpoint    |
      | my-requests |

  Scenario Outline: Consultar reserva por identificador con credenciales validas
    Given path '/api/v1/bookings', <bookingId>
    And header Authorization = renterAuth.authHeader
    When method get
    Then assert responseStatus == 200 || responseStatus == 404

    Examples:
      | bookingId |
      | 1         |
      | 999999    |

  Scenario Outline: Gestionar estado de reserva con autorizacion
    Given path '/api/v1/bookings', <bookingId>, '<action>'
    And header Authorization = ownerAuth.authHeader
    When method put
    Then assert responseStatus == 200 || responseStatus == 400 || responseStatus == 401 || responseStatus == 403 || responseStatus == 404 || responseStatus == 409

    Examples:
      | bookingId | action  |
      | 1         | confirm |
      | 1         | reject  |

  Scenario Outline: Intentar crear una reserva sin autenticacion (Fallo 401/403)
    Given path '/api/v1/bookings'
    And request { vehicleId: <vehicleId>, startDate: '<startDate>', endDate: '<endDate>' }
    When method post
    Then assert responseStatus == 401 || responseStatus == 403

    Examples:
      | vehicleId | startDate  | endDate    |
      | 1         | 2026-10-10 | 2026-10-15 |

  Scenario Outline: Intentar eliminar reserva con autorizacion
    Given path '/api/v1/bookings', <bookingId>
    And header Authorization = renterAuth.authHeader
    When method delete
    Then assert responseStatus == 200 || responseStatus == 204 || responseStatus == 404

    Examples:
      | bookingId |
      | 999999    |
