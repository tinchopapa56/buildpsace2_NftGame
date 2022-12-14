// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";

// NFT contract to inherit from.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// Helper we wrote to encode in Base64
import "./libraries/Base64.sol";
// Helper functions OpenZeppelin provides.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Game is ERC721{

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  // We'll hold our character's attributes in a struct
  struct CharacterSTRUCT {
    uint characterIndex;
    string name;
    string imageURI;        
    uint hp;
    uint maxHp;
    uint attackDamage;
  }
  mapping(uint256 => CharacterSTRUCT) nftHolderStruct;
  mapping(address => uint256) nftHolderAddress;
  CharacterSTRUCT[] allCharacters;

  struct BigBoss {
    string name;
    string imageURI;
    uint hp;
    uint maxHp;
    uint attackDamage;
  }

  BigBoss public bigBoss;


  // Data passed in to the contract when it's first created initializing the characters.
  // We're going to actually pass these values in from run.js.
  constructor(
    string[] memory characterNames,
    string[] memory characterImageURIs,
    uint[] memory characterHp,
    uint[] memory characterAttackDmg,
    string memory _bossName, // These new variables would be passed in via run.js or deploy.js.
    string memory _bossImageURI,
    uint _bossHp,
    uint _bossAttackDamage,
    address _randomnes,
    ) ERC721("Heroes", "HERO") { 
      for(uint i = 0; i < characterNames.length; i += 1) {
        allCharacters.push(
          CharacterSTRUCT({
          characterIndex: i,
          name: characterNames[i],
          imageURI: characterImageURIs[i],
          hp: characterHp[i],
          maxHp: characterHp[i],
          attackDamage: characterAttackDmg[i]
          })
        );

        CharacterSTRUCT memory c = allCharacters[i];
        // console.log("Done initializing %s w/ HP %s, img %s", c.name, c.hp, c.imageURI);
      }
        bigBoss = BigBoss({
            name: _bossName,
            imageURI: _bossImageURI,
            hp: _bossHp,
            maxHp: _bossHp,
            attackDamage: _bossAttackDamage
          });

        console.log("Done initializing boss %s w/ HP %s, img %s", bigBoss.name, bigBoss.hp, bigBoss.imageURI);
      _tokenIds.increment();
      randomness = Randomness(_randomness);;
   }

  function mintCharacterNFT(uint _characterIndex) external {
    uint256 newItemId = _tokenIds.current();
    _safeMint(msg.sender, newItemId);
    // We map the tokenId => their character attributes
    nftHolderStruct[newItemId] = CharacterSTRUCT({
      characterIndex: _characterIndex,
      name: allCharacters[_characterIndex].name,
      imageURI: allCharacters[_characterIndex].imageURI,
      hp: allCharacters[_characterIndex].hp,
      maxHp: allCharacters[_characterIndex].maxHp,
      attackDamage: allCharacters[_characterIndex].attackDamage
    });
    console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _characterIndex);

    nftHolderAddress[msg.sender] = newItemId;
    _tokenIds.increment();
  }
  
  function tokenURI(uint256 _tokenId) public view override returns (string memory) {
    CharacterSTRUCT memory charAttributes = nftHolderStruct[_tokenId];

    string memory strHp = Strings.toString(charAttributes.hp);
    string memory strMaxHp = Strings.toString(charAttributes.maxHp);
    string memory strAttackDamage = Strings.toString(charAttributes.attackDamage);

    string memory json = Base64.encode(
      abi.encodePacked(
        '{"name": "',charAttributes.name,
        ' -- NFT #: ',Strings.toString(_tokenId),
        '", "description": "This is an NFT that lets people play in the game Metaverse Slayer!", "image": "',charAttributes.imageURI,
        '", "attributes": [ { "trait_type": "Health Points", "value": ',strHp,', "max_value":',strMaxHp,'}, { "trait_type": "Attack Damage", "value": ',
        strAttackDamage,'} ]}'
      )
    );

    string memory output = string(abi.encodePacked("data:application/json;base64,", json));
    
    return output;
  }

  function attackBoss() public {
    // Get the state of the player's NFT.
    uint walletNFT = nftHolderAddress[msg.sender];
    CharacterSTRUCT storage NFTData = nftHolderStruct[walletNFT];
    require(NFTData.hp > 0, "your NFT has 0 hp");
    require(bigBoss.hp > 0, "the boss is already dead");
    //Boss damage
    if (bigBoss.hp < NFTData.attackDamage) {
      bigBoss.hp = 0;
    } else {
      bigBoss.hp = bigBoss.hp - NFTData.attackDamage;
    }
    //player damage
    if (NFTData.hp < bigBoss.attackDamage) {
      NFTData.hp = 0;
    } else {
      NFTData.hp = NFTData.hp - bigBoss.attackDamage;
    }
    console.log("Player attacked boss. New boss hp: %s", bigBoss.hp);
    console.log("Boss attacked player. New player hp: %s\n", NFTData.hp);
  }

}