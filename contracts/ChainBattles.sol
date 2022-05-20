//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage{
      using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    struct Details{
        string Warrior;
        uint256 Rating;
        uint256 HP;
        uint256 Strength;
        uint256 TrainId;
    }
      
     mapping(uint256 => Details) public tokenIdDetails;


    constructor() ERC721 ("Chain Battles", "BTLS"){
    }


    function generateCharacter(uint256 tokenId) public view returns(string memory){

    bytes memory svg = abi.encodePacked(
    '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior: ",getWarrior(tokenId),'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Ratings: ",getRating(tokenId),'</text>',
        '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Hitpoints: ",getHP(tokenId),'</text>',
        '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",getStrength(tokenId),'</text>',
        '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">', "Training ID (Random): ",getTrainId(tokenId),'</text>',
        '</svg>'
    );
    return string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        )    
    );
    }

    function getWarrior(uint256 tokenId) public view returns (string memory) {
    string memory Warrior = tokenIdDetails[tokenId].Warrior;
    return Warrior;
    }
    function getRating (uint256 tokenId) public view returns (string memory) {
    uint256 Rating = tokenIdDetails[tokenId].Rating;
    return Rating.toString();
    }

    function getHP(uint256 tokenId) public view returns (string memory) {
    uint256 Hp = tokenIdDetails[tokenId].HP;
    return Hp.toString();
    }
    
    function getStrength(uint256 tokenId) public view returns (string memory) {
    return tokenIdDetails[tokenId].Strength.toString();
    }


    function getTrainId(uint256 tokenId) public view returns (string memory) {
     uint256 TrainId = tokenIdDetails[tokenId].TrainId;
    return TrainId.toString();
    }

    function mint() public {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _safeMint(msg.sender, newItemId);
    random(100);
    tokenIdDetails[newItemId].Warrior = "Noob";
    tokenIdDetails[newItemId].HP=100;
    tokenIdDetails[newItemId].Rating=1;                 
    tokenIdDetails[newItemId].Strength=20;
    tokenIdDetails[newItemId].TrainId=1;
    _setTokenURI(newItemId, getTokenURI(newItemId)); 
}

function getTokenURI(uint256 tokenId) public view returns (string memory){
    bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Chain Battles #', tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId), '"',
        '}'
    );
    return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(dataURI)
        )
    );
}

 function train(uint256 tokenId) public {
   require(_exists(tokenId));
   require(ownerOf(tokenId) == msg.sender, "You must own this NFT to train it!");

   tokenIdDetails[tokenId].Rating +=1; 
   tokenIdDetails[tokenId].HP *=2;
    tokenIdDetails[tokenId].Strength +=10; 
   tokenIdDetails[tokenId].Warrior = (tokenIdDetails[tokenId].Strength>50)?"Barbarian King":"Archer King";
   tokenIdDetails[tokenId].TrainId = random(1000);
   _setTokenURI(tokenId, getTokenURI(tokenId));
}

function random(uint number) public view returns (uint256) {
        uint256 Rnumber =( uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
        msg.sender))) % number);
        return Rnumber;
    }


}