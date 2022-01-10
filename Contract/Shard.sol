// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Shard is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;

    // The current count will be used to give a new mint it's ID.
    Counters.Counter private _tokenIdCounter;
    // The maximum amount of NFTs which can be minted. Remember that this is actually 6, as all integers start at 0.
    uint16 public maxSupply = 5;
    // The cost to mint this contract's NFTs
    uint256 public mintRate = 0.001 ether;

    constructor() ERC721("Shard", "SHRD") {}

    // The IPFS uri, containing all the json files for this contract's NFTs.
    function _baseURI() internal pure override returns (string memory){
        return "ipfs://QmP6o3FdohRZFE3UV5uCzSvgfdfkw9yJiS95t6kiHVYFKv/";
    }

    // Returns the json file of the corresponding token ID.
    // Used for getting things like the NFT's name, properties, description etc.
    function tokenURI(uint256 _tokenId) override public view returns (string memory) {
    return string(abi.encodePacked(
        _baseURI(),
        Strings.toString(_tokenId),
        ".json"
        ));
    }

    // The minting function, needed to create an NFT
    function safeMint(address to) public payable {
        // Checks if the maximum supply is greater than the current amount of NFTs that have been minted so far.
        // If it is greater, then anyone can mint. But if it isn't greater then that means the maximum amount of NFTs which can be minted has been reached.
        require(maxSupply >= totalSupply(), "No supply");
        // Checks if the ether sent by the caller is greater or equal to the amount needed to mint a new NFT according to mintRate. (Default is 0.001 ether)
        require(msg.value >= mintRate, "Not enough ether sent");
        // Gives the to be minted NFT it's ID.
        uint256 tokenId = _tokenIdCounter.current();
        // Increases the tokenID counter so that the next NFT to be minted doesn't have the same ID as the one that is about to be minted.
        _tokenIdCounter.increment();
        // Mints the NFT
        _safeMint(to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    // Allows the deployer/owner of this contract to withdraw any ether they make from people minting their NFTs.
    function withdraw() public onlyOwner{
        require(address(this).balance >= 0, "Balance is 0");
        payable(owner()).transfer(address(this).balance);
    }
}
