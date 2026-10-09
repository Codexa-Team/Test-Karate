Feature: Roles Management (IAM Bounded Context)

  Background:
    * url baseUrl
    * def auth = callonce read('classpath:codexateam/iam/authentication/auth-token.feature') { role: 'arrendatario' }

  Scenario Outline: Validar existencia de roles esperados en el catalogo del sistema con autenticacion
    Given path '/api/v1/roles'
    And header Authorization = auth.authHeader
    When method get
    Then status 200
    And match response == '#array'
    And match response[*].name contains '<roleName>'

    Examples:
      | roleName          |
      | ROLE_ARRENDADOR   |
      | ROLE_ARRENDATARIO |

  Scenario Outline: Intentar consultar roles sin autenticacion (Fallo 401/403)
    Given path '<path>'
    When method get
    Then assert responseStatus == 401 || responseStatus == 403

    Examples:
      | path          |
      | /api/v1/roles |
