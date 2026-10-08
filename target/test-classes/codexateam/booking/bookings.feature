Feature: Bookings Management (Booking Bounded Context)

  Background:
    * url baseUrl

  Scenario: Intentar consultar reservas de arrendatario sin autenticación (Fallo 401/403)
    Given path '/api/v1/bookings', 'my-bookings'
    When method get
    Then assert responseStatus == 401 || responseStatus == 403

  Scenario: Intentar consultar solicitudes de arrendador sin autenticación (Fallo 401/403)
    Given path '/api/v1/bookings', 'my-requests'
    When method get
    Then assert responseStatus == 401 || responseStatus == 403

  Scenario: Intentar crear una reserva sin autenticación (Fallo 401/403)
    Given path '/api/v1/bookings'
    And request { vehicleId: 1, startDate: '2026-10-10', endDate: '2026-10-15' }
    When method post
    Then assert responseStatus == 401 || responseStatus == 403

  Scenario: Consultar reserva por ID inexistente sin credenciales válidas (Fallo 401/404)
    Given path '/api/v1/bookings', 999999
    When method get
    Then assert responseStatus == 401 || responseStatus == 403 || responseStatus == 404
