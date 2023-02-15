// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.17;


import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

contract TgNft is ERC721URIStorage, ERC2981{
  using Counters for Counters.Counter; //Variabili globali
  Counters.Counter private _tokenIds; 
  string private NomeDellaRicetta;
  uint256 private TotalSupply=1000;
  uint256 private maxId=TotalSupply-1;
  uint256 private commonSupply = (TotalSupply/100)*70;
  uint256 private rareSupply = (TotalSupply/100)*25;
  uint256 private legendarySupply = (TotalSupply/100)*5;
  string private rarity;
  string private ImgLinkCommon= "https://i.imgur.com/sddmilN.png";
  string private ImgLinkRare= "https://imgur.com/iqTbpiu.png";
  string private ImgLinkLegendary= "https://imgur.com/KbNtMw2.png";
  string private receiver= "0x885d40D8034dB71427E9a46B9948D8Bd10697Ae3";

  
  constructor() ERC721 ("Tony Giannuzzi's Grilled Tarragon Salmon", "TGS") { //Costruttore che lancia setta nome ecc
    console.log("Sto costruendo il mio contratto!");
    // _setDefaultRoyalty(msg.sender, 100);
     _setDefaultRoyalty(receiver, feeNumerator);
    
    
  }

    function ConfrontoId(uint256 _newItemId) public view returns(bool){ //confronta che l'id creato non sia un doppione
      console.log("Sto confrontando gli Id");
      if(_newItemId <  _tokenIds.current()){
        return false;

      }else{
        return true;
      }
    }


  function makeAnRicettaNft() public { //crea un nuovo veicolo con id <= a maxId
    uint256 newItemId = _tokenIds.current();
    string memory json;
    require(newItemId <= maxId && ConfrontoId(newItemId));

    NomeDellaRicetta = " #";
    NomeDellaRicetta = string.concat(NomeDellaRicetta,Strings.toString(newItemId));

    // Get all the JSON metadata in place and base64 encode it.

    //Rarita leggendary
    if(newItemId < legendarySupply){
      rarity="legendary";
     json = Base64.encode(
        bytes(
            string(
                abi.encodePacked('{"name": "',NomeDellaRicetta,'", "description": "This is the recipe ',rarity,'  from the collection ',NomeDellaRicetta, ' .","image": "',ImgLinkLegendary,'","rarity": "',rarity,'"}')
            )
        )
    );
    }

    //Rarita rara
    if(newItemId >= legendarySupply && newItemId <rareSupply){
      rarity="rare";
       json = Base64.encode(
        bytes(
            string(
                abi.encodePacked('{"name": "',NomeDellaRicetta,'", "description": "This is the recipe ',rarity,'  from the collection ',NomeDellaRicetta, ' .","image": "',ImgLinkRare,'","rarity": "',rarity,'"}')
            )
        )
    );
    }

    //Rarita comune
    if(newItemId >= rareSupply && newItemId <commonSupply){
      rarity="common";
       json = Base64.encode(
        bytes(
            string(
                abi.encodePacked('{"name": "',NomeDellaRicetta,'", "description": "This is the recipe ',rarity,'  from the collection ',NomeDellaRicetta, ' .","image": "',ImgLinkCommon,'","rarity": "',rarity,'","head": "digital","dish": "glowing","left hand": "none","right hand": "robotic fork","body": "wires","background": "gradient"}')
            )
        )
    );
    }



    
    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);
    
    // Update your URI!!!
    _setTokenURI(newItemId, finalTokenUri);
  
    _tokenIds.increment();
    console.log("Un NFT con ID %s e' stato coniato da %s, la sua rarita e': %s", newItemId, msg.sender, rarity);
  }



  function getRarity() public returns(string memory){
    return rarity;
  }
}