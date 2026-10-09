Feature: Users Management (IAM Bounded Context)

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:codexateam/iam/authentication/auth-token.feature') { role: 'arrendatario' }

  Scenario Outline: Consultar catalogo de usuarios del sistema con autenticacion JWT
    Given path '/api/v1/users'
    And header Authorization = auth.authHeader
    When method get
    Then status <expectedStatus>
    And match response == '#array'
    And match response[0].id == '#number'

    Examples:
      | expectedStatus |
      | 200            |

  Scenario Outline: Actualizar informacion de perfil de un usuario existente
    Given path '/api/v1/users', auth.userId
    And header Authorization = auth.authHeader
    And request { name: '<updatedName>', email: 'renter.master@rc.com' }
    When method patch
    Then status 200
    And match response.id == auth.userId
    And match response.name == '<updatedName>'

    Examples:
      | updatedName       |
      | Master Renter Mod |

  Scenario Outline: Actualizar contrasena de un usuario existente
    * def ts = java.lang.System.currentTimeMillis()
    * def rnd = Math.floor(Math.random() * 9000 + 1000)
    * def auxEmail = '<prefix>' + ts + rnd + '@rc.com'
    # Registrar usuario auxiliar
    Given path '/api/v1/authentication', 'sign-up'
    And request { name: '<name>', email: '#(auxEmail)', password: '<currentPassword>', role: '<role>' }
    When method post
    Then status 201
    * def auxUserId = response.id

    # Iniciar sesion
    Given path '/api/v1/authentication', 'sign-in'
    And request { email: '#(auxEmail)', password: '<currentPassword>' }
    When method post
    Then status 200
    * def auxToken = response.token

    # Actualizar contrasena
    Given path '/api/v1/users', auxUserId, 'password'
    And header Authorization = 'Bearer ' + auxToken
    And request { currentPassword: '<currentPassword>', newPassword: '<newPassword>' }
    When method patch
    Then status 200
    And match response.id == auxUserId

    Examples:
      | name           | prefix | currentPassword | newPassword     | role         |
      | Pass Aux User  | paux_  | Password123!    | TempSecret2026! | arrendatario |

  Scenario Outline: Eliminar usuario auxiliar efimero por ID
    # Registrar usuario temporal para no alterar usuarios maestros
    * def ts = java.lang.System.currentTimeMillis()
    * def rnd = Math.floor(Math.random() * 9000 + 1000)
    * def tempEmail = '<prefix>' + ts + rnd + '@rc.com'
    Given path '/api/v1/authentication', 'sign-up'
    And request { name: '<name>', email: '#(tempEmail)', password: '<password>', role: '<role>' }
    When method post
    Then status 201
    * def tempUserId = response.id

    # Iniciar sesion para obtener token del usuario temporal
    Given path '/api/v1/authentication', 'sign-in'
    And request { email: '#(tempEmail)', password: '<password>' }
    When method post
    Then status 200
    * def tempToken = response.token

    # Eliminar usuario
    Given path '/api/v1/users', tempUserId
    And header Authorization = 'Bearer ' + tempToken
    When method delete
    Then status 204

    Examples:
      | name              | prefix | password     | role         |
      | Usuario Efimero   | efi_   | Password123! | arrendatario |

  Scenario Outline: Intentar operar sobre usuario inexistente sin autenticacion (Fallo 401/403/404)
    Given path '/api/v1/users', <userId>
    And request { name: '<name>', email: '<email>' }
    When method patch
    Then assert responseStatus == 400 || responseStatus == 401 || responseStatus == 403 || responseStatus == 404
    
    Examples:
      | userId | name     | email              |
      | 999999 | Fantasma | ghost@renticar.com |
