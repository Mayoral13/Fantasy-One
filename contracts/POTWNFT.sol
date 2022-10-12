// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract POTWNFT is ERC721URIStorage,Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address contractAddress;

    constructor(address marketplaceAddress) ERC721("POTW", "POTW") {
        contractAddress = marketplaceAddress;
    }

    function createToken(string memory tokenURI) public onlyOwner returns (uint) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        setApprovalForAll(contractAddress, true);
        return newItemId;
    }
}