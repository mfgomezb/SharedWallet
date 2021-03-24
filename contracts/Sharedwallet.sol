//SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Allowance is Ownable {
    
    address allowanceAddress = address(this);
    
    event AllowanceChanged(address indexed _forWho, address indexed _byWhom, uint _oldAmount, uint _newAmount);
    
    
    function allowanceBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    // view who the owner of the contract is
    function isOwner() internal view returns(bool) {
        return owner() == msg.sender;
    }
    
    mapping(address => uint) public allowance;
    
    //add allowance to recipient
    function addAllowance(address _who) public payable onlyOwner {
        AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who] + msg.value);
        allowance[_who] += msg.value;
    }
    
    // reduce allowance from recipient on withdrawal, function is private
    function reduceAllowance(address _who, uint _amount) internal ownerOrAllowed(_amount) {
        AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who] - _amount);
        //no need to use same math to prevent overflow as sol is >= 0.8
        allowance[_who] -= _amount;
    }
    
    // check if owner or if allowance recipient has funds
    modifier ownerOrAllowed(uint _amount) {
        require(isOwner() || allowance[msg.sender] >= _amount, "You are not allowed");
        _;
    }

}

contract SharedWallet is Allowance {

    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);
    
    function walletBalance() public view returns(uint) {
        return address(this).balance;
    }

    // withdrawal function with instructions 
    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "Contract doesn't own enough funds");
        reduceAllowance(_to, _amount);
        MoneySent(msg.sender, _amount);
        _to.transfer(_amount);
    }

    function renounceOwnership() public virtual override onlyOwner {
        revert("can't renounceOwnership here"); //not possible with this smart contract
    }

    receive() external payable {
        MoneyReceived(msg.sender, msg.value);
        
    }
    
}