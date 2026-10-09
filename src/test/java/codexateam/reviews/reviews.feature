Feature: Reviews and Ratings Management (Reviews Bounded Context)

  Background:
    * url baseUrl
    * def renterAuth = callonce read('classpath:codexateam/iam/authentication/auth-token.feature') { role: 'arrendatario' }

  Scenario Outline: Consultar resenas asociadas a un vehiculo (endpoint publico)
    Given path '/api/v1/reviews', 'vehicle', <vehicleId>
    When method get
    Then assert responseStatus == 200 || responseStatus == 404

    Examples:
      | vehicleId |
      | 1         |
      | 999999    |

  Scenario Outline: Consultar resenas propias del arrendatario autenticado
    Given path '/api/v1/reviews', '<subpath>'
    And header Authorization = renterAuth.authHeader
    When method get
    Then status 200
    And match response == '#array'

    Examples:
      | subpath    |
      | my-reviews |

  Scenario Outline: Consultar resena individual por identificador con autenticacion
    Given path '/api/v1/reviews', <reviewId>
    And header Authorization = renterAuth.authHeader
    When method get
    Then assert responseStatus == 200 || responseStatus == 404

    Examples:
      | reviewId |
      | 1        |
      | 999999   |

  Scenario Outline: Registrar o validar publicacion de resena con autenticacion
    Given path '/api/v1/reviews'
    And header Authorization = renterAuth.authHeader
    And request { vehicleId: <vehicleId>, rating: <rating>, comment: '<comment>' }
    When method post
    Then assert responseStatus == 201 || responseStatus == 400 || responseStatus == 403 || responseStatus == 404 || responseStatus == 409

    Examples:
      | vehicleId | rating | comment                            |
      | 1         | 5      | Excelente experiencia de alquiler! |

  Scenario Outline: Intentar publicar una resena sin autenticacion (Fallo 401/403)
    Given path '/api/v1/reviews'
    And request { vehicleId: <vehicleId>, rating: <rating>, comment: '<comment>' }
    When method post
    Then assert responseStatus == 401 || responseStatus == 403

    Examples:
      | vehicleId | rating | comment                      |
      | 1         | 4      | Sin autorizacion no es valido |
