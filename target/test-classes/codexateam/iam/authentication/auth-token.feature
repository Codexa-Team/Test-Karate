@ignore
Feature: Reusable Token Authentication Service

  Background:
    * url baseUrl

  Scenario: Obtener token y credenciales segun rol solicitado
    * def isOwner = role == 'arrendador' || role == 'ROLE_ARRENDADOR'
    * def email = isOwner ? 'owner.master@rc.com' : 'renter.master@rc.com'
    * def name = isOwner ? 'Master Owner' : 'Master Renter'
    * def roleName = isOwner ? 'arrendador' : 'arrendatario'
    * def password = 'Password123!'

    # Asegurar registro de usuario si no existe previamente
    Given path '/api/v1/authentication', 'sign-up'
    And request { name: '#(name)', email: '#(email)', password: '#(password)', role: '#(roleName)' }
    When method post

    # Autenticar para obtener el token JWT vigente
    Given path '/api/v1/authentication', 'sign-in'
    And request { email: '#(email)', password: '#(password)' }
    When method post
    Then status 200
    * def token = response.token
    * def userId = response.id
    * def userEmail = response.email
    * def authHeader = 'Bearer ' + response.token
