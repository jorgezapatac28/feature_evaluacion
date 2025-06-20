Feature: Marvel Characters API CRUD tests with username in URL

  Scenario:Obtener todos los personajes cuando la lista está vacía o con datos
    Given path 'characters'
    When method get
    Then status 200
    And match response == '#[] || #notnull'

  Scenario: Obtener personaje por ID existente exitosamente
    Given path 'characters', 1
    When method get
    Then status 200
    And match response ==
      """
      {
        id: 1,
        name: '#string',
        alterego: '#string',
        description: '#string',
        powers: '#[]'
      }
      """

  Scenario: Obtener personaje por ID que no existe
    Given path 'characters', 999
    When method get
    Then status 404
    And match response.error == 'Character not found'

  Scenario: Crear personaje exitosamente
    Given path 'characters'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "name": "Iron Man",
        "alterego": "Tony Stark",
        "description": "Genius billionaire",
        "powers": ["Armor", "Flight"]
      }
      """
    When method post
    Then status 201
    And match response ==
      """
      {
        id: '#number',
        name: 'Iron Man',
        alterego: 'Tony Stark',
        description: 'Genius billionaire',
        powers: ["Armor", "Flight"]
      }
      """
    # Guardamos id dinámico para usar en siguientes escenarios
    * def newId = response.id

  Scenario: Crear personaje con nombre duplicado, debe fallar
    Given path 'characters'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "name": "Iron Man",
        "alterego": "Otro",
        "description": "Otro",
        "powers": ["Armor"]
      }
      """
    When method post
    Then status 400
    And match response.error == 'Character name already exists'

  Scenario: Crear personaje con campos faltantes, debe fallar
    Given path 'characters'
    And header Content-Type = 'application/json'
    And request
      """
      {
        "name": "",
        "alterego": "",
        "description": "",
        "powers": []
      }
      """
    When method post
    Then status 400
    And match response ==
      """
      {
        name: 'Name is required',
        alterego: 'Alterego is required',
        description: 'Description is required',
        powers: 'Powers are required'
      }
      """

  Scenario: Actualizar personaje existente
    Given path 'characters', newId
    And header Content-Type = 'application/json'
    And request
      """
      {
        "name": "Iron Man",
        "alterego": "Tony Stark",
        "description": "Updated description",
        "powers": ["Armor", "Flight"]
      }
      """
    When method put
    Then status 200
    And match response.description == 'Updated description'

  Scenario: Actualizar personaje que no existe
    Given path 'characters', 999
    And header Content-Type = 'application/json'
    And request
      """
      {
        "name": "Iron Man",
        "alterego": "Tony Stark",
        "description": "Updated description",
        "powers": ["Armor", "Flight"]
      }
      """
    When method put
    Then status 404
    And match response.error == 'Character not found'

  Scenario: Eliminar personaje existente
    Given path 'characters', newId
    When method delete
    Then status 204

  Scenario: Eliminar personaje que no existe
    Given path 'characters', 999
    When method delete
    Then status 404
    And match response.error == 'Character not found'