package com.marvel.api.karate;

import com.intuit.karate.junit5.Karate;



public class CharacterApiTestRunner {
    @Karate.Test
    Karate testCharacterApi() {
        return Karate.run("character").relativeTo(getClass());

    }

    Karate testAll() {
        return Karate.run("com/marvel/api/karate/character.feature").relativeTo(getClass());
    }
}
