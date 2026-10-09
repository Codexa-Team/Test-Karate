Feature: Vehicle Listings Management (Listings Bounded Context)

  Background:
    * url baseUrl
    * def ownerAuth = callonce read('classpath:codexateam/iam/authentication/auth-token.feature') { role: 'arrendador' }

  Scenario Outline: Registrar nuevo vehiculo en el catalogo como arrendador autenticado (POST multipart)
    * def vehicleData = { brand: '<brand>', model: '<model>', year: <year>, pricePerDay: <pricePerDay> }
    * def vehicleJson = karate.toJson(vehicleData)
    Given path '/api/v1/vehicles'
    And header Authorization = ownerAuth.authHeader
    And multipart file image = { value: 'dummy image bytes', filename: 'car.jpg', contentType: 'image/jpeg' }
    And multipart file resource = { value: '#(vehicleJson)', filename: 'resource.json', contentType: 'application/json' }
    When method post
    Then status 201
    And match response.brand == '<brand>'
    And match response.model == '<model>'
    And match response.id == '#number'

    Examples:
      | brand   | model   | year | pricePerDay |
      | Toyota  | Corolla | 2023 | 55.0        |
      | Hyundai | Elantra | 2022 | 48.0        |

  Scenario Outline: Consultar publicaciones del arrendador autenticado
    Given path '/api/v1/vehicles', '<subpath>'
    And header Authorization = ownerAuth.authHeader
    When method get
    Then status 200
    And match response == '#array'

    Examples:
      | subpath     |
      | my-listings |

  Scenario Outline: Consultar catalogo general de vehiculos disponibles (publico)
    Given path '<path>'
    When method get
    Then status 200
    And match response == '#array'

    Examples:
      | path             |
      | /api/v1/vehicles |

  Scenario Outline: Consultar vehiculo por ID existente o inexistente
    Given path '/api/v1/vehicles', <vehicleId>
    When method get
    Then assert responseStatus == 200 || responseStatus == 404 || responseStatus == 400

    Examples:
      | vehicleId |
      | 1         |
      | 999999    |

  Scenario Outline: Consultar imagen asociada a un vehiculo
    Given path '/api/v1/vehicles', <vehicleId>, 'image'
    When method get
    Then assert responseStatus == 200 || responseStatus == 404

    Examples:
      | vehicleId |
      | 1         |
      | 999999    |

  Scenario Outline: Actualizar vehiculo existente como arrendador autenticado
    * def updateData = { brand: '<brand>', model: '<model>', year: <year>, pricePerDay: <pricePerDay> }
    * def updateJson = karate.toJson(updateData)
    Given path '/api/v1/vehicles', <vehicleId>
    And header Authorization = ownerAuth.authHeader
    And multipart file resource = { value: '#(updateJson)', filename: 'resource.json', contentType: 'application/json' }
    When method put
    Then assert responseStatus == 200 || responseStatus == 404

    Examples:
      | vehicleId | brand  | model        | year | pricePerDay |
      | 1         | Toyota | Corolla Plus | 2024 | 60.0        |

  Scenario Outline: Intentar crear vehiculo sin cabecera de autorizacion (Fallo 401/403)
    * def vehicleData = { brand: '<brand>', model: '<model>', year: <year>, pricePerDay: <pricePerDay> }
    * def vehicleJson = karate.toJson(vehicleData)
    Given path '/api/v1/vehicles'
    And multipart file image = { value: 'dummy image bytes', filename: 'car.jpg', contentType: 'image/jpeg' }
    And multipart file resource = { value: '#(vehicleJson)', filename: 'resource.json', contentType: 'application/json' }
    When method post
    Then assert responseStatus == 401 || responseStatus == 403

    Examples:
      | brand  | model   | year | pricePerDay |
      | Nissan | Sentra  | 2021 | 42.0        |

  Scenario Outline: Intentar eliminar vehiculo con o sin autorizacion
    Given path '/api/v1/vehicles', <vehicleId>
    And header Authorization = ownerAuth.authHeader
    When method delete
    Then assert responseStatus == 204 || responseStatus == 404

    Examples:
      | vehicleId |
      | 999999    |
