// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "./TexToken.sol";

contract MarketPlaceCPR {
    using Address for address payable;

    TexToken private _toktok;

    mapping(address => uint256) private _etherBalance;
    
    constructor(address toktokAddress_) {
        _toktok = TexToken(toktokAddress_);
    }

    function buyNFT(uint256 id) public payable {
        require(_toktok.getApproved(id) == address(this)," TexToken: Sorry this NFT is not for sell");
        require(msg.value >= _toktok.getPrice(id), " TexToken: Sorry not enought ethers" );
        uint256 amount = msg.value;
        _etherBalance[_toktok.ownerOf(id)] += amount;
        _toktok.transferFrom(_toktok.ownerOf(id), msg.sender, id);
    }
 
    function withdraw() public {
        uint256 amount = _etherBalance[msg.sender];
        _etherBalance[msg.sender] = 0;
        payable(msg.sender).sendValue(amount);
    }

    function getEtherBalance() public view returns (uint256) {
        return (_etherBalance[msg.sender]);
    }
}
