//SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SharedWallet is Ownable {
    
    // view who the owner of the contract is
    function isOwner() internal view returns(bool) {
        return owner() == msg.sender;
    }

    
    // withdrawal function with instructions 
    function withdrawMoney(address payable _to, uint _amount) public onlyOwner {
        _to.transfer(_amount);
    }

    receive() external payable {
        
    }
    
}