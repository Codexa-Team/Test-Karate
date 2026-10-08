Feature: Reviews and Ratings Management (Reviews Bounded Context)

  Background:
    * url baseUrl

  Scenario: Consultar reseñas asociadas a un vehículo
    Given path '/api/v1/reviews', 'vehicle', 1
    When method get
    Then assert responseStatus == 200 || responseStatus == 404

  Scenario: Intentar publicar una reseña sin autenticación (Fallo 401/403)
    Given path '/api/v1/reviews'
    And request { vehicleId: 1, rating: 5, comment: 'Excelente experiencia de alquiler!' }
    When method post
    Then assert responseStatus == 401 || responseStatus == 403
