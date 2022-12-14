// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract MyEpicGame {
  // We'll hold our character's attributes in a struct
  struct CharacterTRAITS {
    uint characterIndex;
    string name;
    string imageURI;        
    uint hp;
    uint maxHp;
    uint attackDamage;
  }
  // A lil array to help us hold the default data for our characters.
  // This will be helpful when we mint new characters and need to know
  // things like their HP, AD, etc.
  CharacterTRAITS[] defaultCharacters;

  // Data passed in to the contract when it's first created initializing the characters.
  // We're going to actually pass these values in from run.js.
  constructor(
    string[] memory characterNames,
    string[] memory characterImageURIs,
    uint[] memory characterHp,
    uint[] memory characterAttackDmg
  )
  {
    // Loop through all the characters, and save their values in our contract so
    // we can use them later when we mint our NFTs.
    for(uint i = 0; i < characterNames.length; i += 1) {
      defaultCharacters.push(
        CharacterTRAITS({
        characterIndex: i,
        name: characterNames[i],
        imageURI: characterImageURIs[i],
        hp: characterHp[i],
        maxHp: characterHp[i],
        attackDamage: characterAttackDmg[i]
        })
      );

      CharacterTRAITS memory c = defaultCharacters[i];
      console.log("Done initializing %s w/ HP %s, img %s", c.name, c.hp, c.imageURI);
    }
  }
}