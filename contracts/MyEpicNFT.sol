// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

//inherits contract we imported
contract MyEpicNFT is ERC721URIStorage {
    //openzeppelin helps keep track of tokenIDS
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";


    string[] firstWords = ["Monkey", "Dog", "Mew", "Flying", "Pikachu", "Naruto", "Goku", "Madara", "Freiza", "Vegeta"];
    string[] secondWords = ["Possum", "Wrench", "Screwdriver", "Pokemon", "Lemon", "Cupcake", "Milkshake", "wild", "Crazy", "Chicken"];
    string[] thirdWords = ["Tiger", "Taco", "Burger", "Pizza", "Screwdriver", "Wild", "Salad", "Curry", "Terrible", "Spook", "Chibi"];

//pass the name of our token and its symbol
    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract, WooHoo!");
    }

    //function to randomly pick a word from our arrays
    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];
    }
    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }
    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

//function to get the nft
    function makeAnEpicNFT() public {
        //gets the current token ID
        uint256 newItemId = _tokenIds.current();

        //randomly pick one word from each array
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));

        string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));
        
         string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "Random Ass Squares Squared..", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n---------------");
        console.log(finalTokenUri);
        console.log("---------------\n");

//actually mints the nft to thhe sender
        _safeMint(msg.sender, newItemId);
//sets the nft's data
        _setTokenURI(newItemId, finalTokenUri);
       
//increment the counter for the next NFT minted
        _tokenIds.increment();
         console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    }
}