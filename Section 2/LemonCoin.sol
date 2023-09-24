// deployed and tested on Polygon testnet
//transaction hash: 0x0c8cae032d383aa9232696df4262354979572fd5abf4d6eba291f886cbab0a33

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts@4.9.3/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.9.3/access/Ownable.sol";
import "@openzeppelin/contracts@4.9.3/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts@4.9.3/token/ERC721/IERC721.sol";

contract LemonCoin is ERC20, ERC721Holder, Ownable {
    IERC721 public nft;
    mapping (uint => address) public  tokenOwner;
    mapping (uint => uint) public  tokenStakeTime;
    uint public emitPerDay = (10 * 10 ** decimals()) / 1 days;

    constructor(address _nft) ERC20("LemonCoin", "LMN") {
        nft = IERC721(_nft);
    }

    function stake(uint tokenID) external {
        nft.safeTransferFrom(msg.sender,address(this),tokenID);
        tokenOwner[tokenID] = msg.sender;
        tokenStakeTime[tokenID] = block.timestamp;
    }

    function calculateToken(uint tokenId) public view  returns (uint){
        uint timeElapsed = block.timestamp - tokenStakeTime[tokenId];
        return timeElapsed * emitPerDay ;
    }

    function unStake(uint tokenId) external{
        require(tokenOwner[tokenId] == msg.sender, "You can't unstake");
        _mint(msg.sender, calculateToken(tokenId));
        nft.transferFrom(address(this), msg.sender, tokenId);
        delete tokenOwner[tokenId];
        delete tokenStakeTime[tokenId];
    }

    // function mint(address to, uint256 amount) public onlyOwner {
    //     _mint(to, amount);
    // }
}
