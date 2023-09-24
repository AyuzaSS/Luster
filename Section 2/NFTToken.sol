// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts@4.9.3/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.9.3/access/Ownable.sol";


contract LemonNFT is ERC721, Ownable {

    uint256 public totalSupply;
    constructor() ERC721("LemonNFT", "LNFT") {}

    function safeMint(address to) public  {
        totalSupply++;
        _safeMint(to, totalSupply);
    }
}
