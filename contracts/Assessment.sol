// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

//import "hardhat/console.sol";

contract PharmaAtm {
    address payable public owner;
    uint256 public balance;

    event Deposit(uint256 amount);
    event Pay(uint256 amount);

    constructor(uint initBalance) payable {
        owner = payable(msg.sender);
        balance = initBalance;
    }

    function getBalance() public view returns(uint256){
        return balance;
    }

    function addFunds(uint256 _amount) public payable {
        uint _previousBalance = balance;

        // make sure this is the owner
        require(msg.sender == owner, "You are not the owner of this account");

        // perform transaction
        balance += _amount;

        // assert transaction completed successfully
        assert(balance == _previousBalance + _amount);

        // emit the event
        emit Deposit(_amount);
    }

    // custom error
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function pay(uint256 _payAmount) public {
        require(msg.sender == owner, "You are not the owner of this account");
        uint _previousBalance = balance;
        if (balance < _payAmount) {
            revert InsufficientBalance({
                balance: balance,
                withdrawAmount: _payAmount
            });
        }

        // pay in the given amount
        balance -= _payAmount;

        // assert the balance is correct
        assert(balance == (_previousBalance - _payAmount));

        // emit the event
        emit Pay(_payAmount);
    }
}
