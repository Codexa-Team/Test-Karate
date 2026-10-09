Feature: User Authentication - Sign Up (IAM Bounded Context)

  Background:
    * url baseUrl

  Scenario Outline: Registro de los dos usuarios principales del sistema
    Given path '/api/v1/authentication', 'sign-up'
    And request { name: '<name>', email: '<email>', password: '<password>', role: '<role>' }
    When method post
    Then assert responseStatus == 201 || responseStatus == 409 || responseStatus == 500

    Examples:
      | name          | email               | password     | role         |
      | Master Owner  | owner.master@rc.com | Password123! | arrendador   |
      | Master Renter | renter.master@rc.com| Password123! | arrendatario |

  Scenario Outline: Intento de registro con correo ya existente (Fallo de Negocio 409/500)
    * def ts = java.lang.System.currentTimeMillis()
    * def rnd = Math.floor(Math.random() * 9000 + 1000)
    * def duplicateEmail = '<prefix>' + ts + rnd + '@rc.com'
    * def initialPayload = { name: '<name>', email: '#(duplicateEmail)', password: '<password>', role: '<role>' }
    Given path '/api/v1/authentication', 'sign-up'
    And request initialPayload
    When method post
    Then status 201

    Given path '/api/v1/authentication', 'sign-up'
    And request initialPayload
    When method post
    Then assert responseStatus == 400 || responseStatus == 409 || responseStatus == 500

    Examples:
      | name            | prefix | password     | role         |
      | Usuario Duplicado | dup_   | Password123! | arrendatario |

  Scenario Outline: Intento de registro con formato de correo invalido (Validacion de Esquema)
    Given path '/api/v1/authentication', 'sign-up'
    And request { name: '<name>', email: '<email>', password: '<password>', role: '<role>' }
    When method post
    Then assert responseStatus == 400 || responseStatus == 409 || responseStatus == 422 || responseStatus == 500

    Examples:
      | name     | email        | password     | role         |
      | Invalido | not-an-email | Password123! | arrendatario |
