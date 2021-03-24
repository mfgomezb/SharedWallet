//SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/access/Ownable.sol";


contract Allowance is Ownable {

    // view who the owner of the contract is
    function isOwner() internal view returns(bool) {
        return owner() == msg.sender;
    }
    
    mapping(address => uint) public allowance;
    
    //add allowance to recipient
    function addAllowance(address _who, uint _amount) public onlyOwner {
        allowance[_who] = _amount;
    }
    
    // reduce allowance from recipient on withdrawal, function is private
    function reduceAllowance(address _who, uint _amount) internal ownerOrAllowed(_amount) {
        allowance[_who] -= _amount;
    }
    
    // check if owner or if allowance recipient has funds
    modifier ownerOrAllowed(uint _amount) {
        require(isOwner() || allowance[msg.sender] >= _amount, "You are not allowed");
        _;
    }
    
}

contract SharedWallet is Allowance {
    
    // withdrawal function with instructions 
    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "Contract doesn't own enough funds");
        
        if (!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        
        _to.transfer(_amount);
    }

    receive() external payable {
        
    }
    
}