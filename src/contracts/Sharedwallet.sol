//SPDX-License-Identifier: MIT

pragma solidity ^0.7.4;

contract SharedWallet {
    
    // withdrawal function with instructions 
    function withdrawalMoney(address payable _to, uint _amount) public {
        _to.transfer(_amount);
    }

    receive() external payable {
        
    }
}