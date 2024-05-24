# SmartContract-PharmaATM

This Solidity smart contract, named `PharmaATM`, is designed to facilitate financial transactions within a virtual ATM system deployed on the Ethereum blockchain. It provides functionalities for depositing funds into the ATM and paying medicine, ensuring secure and transparent financial interactions.

## Description

This contract demonstrates the usage of `require()`, `assert()`, and `revert()` statements for error handling, ensuring robustness and reliability in financial transactions.

### Requirements

- Smart contract has at least two functions
- Value of the functions from the smart contract are visible on the frontend of the application

### Component and Functionality

`addFunds:` A function that allows users to deposit funds into the ATM. It takes an amount parameter and adds it to the ATM's balance.

`pay:` This function enables users to pay medicine from the ATM. It deducts the specified amount from the ATM's balance and transfers it to the user.

`getBalance:` A function that retrieves the current balance of the ATM.

### Getting Started
To interact with this contract, you can deploy it on VS Code Studio or any Ethereum-compatible blockchain.

Open VS Code Studio.
Create a new file and paste the provided Solidity code and JavaScript code.
Compile the code.
Deploy the contract.
Interact with the deployed contract by calling its functions.
After cloning the GitHub repository, follow these steps to run the code on your computer:

Inside the project directory, in the terminal, type: npm i.
Open two additional terminals in your VS Code.
In the second terminal, type: npx hardhat node.
In the third terminal, type: npx hardhat run --network localhost scripts/deploy.js.
Back in the first terminal, type npm run dev to launch the front-end.
After this, the project will be running on your localhost, typically at http://localhost:3000/.

Assessment.sol

```Solidity

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

```

Index.js

```JS

import React, { useState, useEffect } from "react";
import { ethers } from "ethers";
import atm_abi from "../artifacts/contracts/Assessment.sol/Assessment.json";

export default function HomePage() {
  const [ethWallet, setEthWallet] = useState(undefined);
  const [account, setAccount] = useState(undefined);
  const [atm, setATM] = useState(undefined);
  const [balance, setBalance] = useState(undefined);
  const [amount, setAmount] = useState("");

  const contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
  const atmABI = atm_abi.abi;

  const getWallet = async () => {
    if (window.ethereum) {
      setEthWallet(window.ethereum);
    }

    if (ethWallet) {
      const account = await ethWallet.request({ method: "eth_accounts" });
      handleAccount(account);
    }
  };

  const handleAccount = (account) => {
    if (account) {
      console.log("Account connected: ", account);
      setAccount(account);
    } else {
      console.log("No account found");
    }
  };

  const connectAccount = async () => {
    if (!ethWallet) {
      alert("MetaMask wallet is required to connect");
      return;
    }

    const accounts = await ethWallet.request({
      method: "eth_requestAccounts",
    });
    handleAccount(accounts);

    // once wallet is set we can get a reference to our deployed contract
    getATMContract();
  };

  const getATMContract = () => {
    const provider = new ethers.providers.Web3Provider(ethWallet);
    const signer = provider.getSigner();
    const atmContract = new ethers.Contract(
      contractAddress,
      atmABI,
      signer
    );

    setATM(atmContract);
  };

  const getBalance = async () => {
    if (atm) {
      const balanceInWei = await atm.getBalance();
      const balanceInEther = parseFloat(ethers.utils.formatEther(balanceInWei));
      const roundedBalance = Math.abs(balanceInEther) < 0.000001 ? 0 : balanceInEther;
      setBalance(roundedBalance);
    }
  };
  
  

  const deposit = async () => {
    if (atm) {
      let tx = await atm.deposit(ethers.utils.parseEther(amount));
      await tx.wait();
      getBalance();
    }
  };

  const pay = async () => {
    if (atm) {
      let tx = await atm.withdraw(ethers.utils.parseEther(amount));
      await tx.wait();
      getBalance();
    }
  };

  const handleAmountChange = (event) => {
    setAmount(event.target.value);
  };

  const initUser = () => {
    // Check to see if user has Metamask
    if (!ethWallet) {
      return <p>Please install Metamask in order to use this ATM.</p>;
    }

    // Check to see if user is connected. If not, connect to their account
    if (!account) {
      return (
        <button onClick={connectAccount}>
          Please connect your Metamask wallet
        </button>
      );
    }

    if (balance === undefined) {
      getBalance();
    }

    return (
      <div>
        <p>Your Account: {account}</p>
        <p>Your Balance: {balance}</p>
        <input
          type="number"
          value={amount}
          onChange={handleAmountChange}
          placeholder="Enter amount"
        />
        <button onClick={deposit}>Deposit</button>
        <button onClick={pay}>Pay</button>
      </div>
    );
  };

  useEffect(() => {
    getWallet();
  }, []);

  return (
    <main className="container">
      <header>
        <h1>Welcome to the Pharma ATM!</h1>
      </header>
      {initUser()}
      <style jsx>{`
        .container {
          background-color: #ADD8E6;
          text-align: center;
          margin: 50px auto;
          padding: 20px;
          max-width: 600px;
          border: 1px solid #ccc;
          border-radius: 10px;
          box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
          font-family: Arial, sans-serif;
        }
      `}</style>
    </main>
  );
}

```

This is the whole functionality within the code itself and the generalization of how the code will run.


#### Authors
Baquiran, Kristine Mae P. 
8215029@ntc.edu.ph
