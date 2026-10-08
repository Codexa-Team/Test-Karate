Feature: User Authentication - Sign In (IAM Bounded Context)

  Background:
    * url baseUrl

  Scenario: Inicio de sesión exitoso con credenciales válidas y obtención de token JWT
    * def testEmail = 'signin_' + java.util.UUID.randomUUID() + '@renticar.com'
    # Primero registrar usuario
    Given path '/api/v1/authentication', 'sign-up'
    And request { name: 'Login Test', email: '#(testEmail)', password: 'Password123!', role: 'arrendatario' }
    When method post
    Then status 201

    # Iniciar sesión
    Given path '/api/v1/authentication', 'sign-in'
    And request { email: '#(testEmail)', password: 'Password123!' }
    When method post
    Then status 200
    And match response contains { id: '#number', token: '#string', email: '#(testEmail)' }
    And match response.token != ''

  Scenario: Intento de inicio de sesión con contraseña incorrecta (Fallo 401/400)
    * def testEmail = 'badpass_' + java.util.UUID.randomUUID() + '@renticar.com'
    Given path '/api/v1/authentication', 'sign-up'
    And request { name: 'BadPass User', email: '#(testEmail)', password: 'CorrectPass123!', role: 'arrendatario' }
    When method post
    Then status 201

    Given path '/api/v1/authentication', 'sign-in'
    And request { email: '#(testEmail)', password: 'WrongPass!' }
    When method post
    Then assert responseStatus == 400 || responseStatus == 401

  Scenario: Intento de inicio de sesión con correo no registrado (Fallo 404/401)
    Given path '/api/v1/authentication', 'sign-in'
    And request { email: 'nonexistent@renticar.com', password: 'AnyPassword123' }
    When method post
    Then assert responseStatus == 400 || responseStatus == 401 || responseStatus == 404
