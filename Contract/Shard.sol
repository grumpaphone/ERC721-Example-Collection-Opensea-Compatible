// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Shard is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint16 public maxSupply = 5;
    uint256 public mintRate = 0.001 ether;

    constructor() ERC721("Shard", "SHRD") {}

    function _baseURI() internal pure override returns (string memory){
        return "ipfs://QmP6o3FdohRZFE3UV5uCzSvgfdfkw9yJiS95t6kiHVYFKv/";
    }

    function tokenURI(uint256 _tokenId) override public view returns (string memory) {
    return string(abi.encodePacked(
        _baseURI(),
        Strings.toString(_tokenId),
        ".json"
        ));
    }

    function safeMint(address to) public payable {
        require(maxSupply >= totalSupply());
        require(msg.value >= mintRate, "Not enough ether sent");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
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

    function withdraw() public onlyOwner{
        require(address(this).balance >= 0, "Balance is 0");
        payable(owner()).transfer(address(this).balance);
    }
}
