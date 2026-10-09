Feature: User Authentication - Sign In (IAM Bounded Context)

  Background:
    * url baseUrl

  Scenario Outline: Inicio de sesion exitoso con credenciales de los usuarios principales
    Given path '/api/v1/authentication', 'sign-in'
    And request { email: '<email>', password: '<password>' }
    When method post
    Then status 200
    And match response contains { id: '#number', token: '#string', email: '<email>' }
    And match response.roles contains '<expectedRole>'
    And match response.token != ''

    Examples:
      | email               | password     | expectedRole      |
      | owner.master@rc.com | Password123! | ROLE_ARRENDADOR   |
      | renter.master@rc.com| Password123! | ROLE_ARRENDATARIO |

  Scenario Outline: Intento de inicio de sesion con contrasena incorrecta (Fallo 401/400/500)
    Given path '/api/v1/authentication', 'sign-in'
    And request { email: '<email>', password: '<wrongPassword>' }
    When method post
    Then assert responseStatus == 400 || responseStatus == 401 || responseStatus == 500

    Examples:
      | email               | wrongPassword  |
      | owner.master@rc.com | ContrasenaMal! |
      | renter.master@rc.com| BadPassword99! |

  Scenario Outline: Intento de inicio de sesion con correo no registrado (Fallo 404/401/500)
    * def ts = java.lang.System.currentTimeMillis()
    * def rnd = Math.floor(Math.random() * 9000 + 1000)
    * def nxEmail = 'nx_' + ts + rnd + '@rc.com'
    Given path '/api/v1/authentication', 'sign-in'
    And request { email: '#(nxEmail)', password: '<password>' }
    When method post
    Then assert responseStatus == 400 || responseStatus == 401 || responseStatus == 404 || responseStatus == 500

    Examples:
      | password       |
      | AnyPassword123 |

  Scenario Outline: Consultar informacion general del servicio de autenticacion
    Given path '<path>'
    When method get
    Then status <expectedStatus>
    And match response.message contains '<expectedMessage>'

    Examples:
      | path                   | expectedStatus | expectedMessage    |
      | /api/v1/authentication | 200            | Authentication API |
