# SmartContract-PharmaATM

This Solidity smart contract, named `PharmaATM`, is designed to facilitate financial transactions within a virtual ATM system deployed on the Ethereum blockchain. It provides functionalities for depositing funds into the ATM and paying medicine, ensuring secure and transparent financial interactions.

## Description

This contract demonstrates the usage of `require()`, `assert()`, and `revert()` statements for error handling, ensuring robustness and reliability in financial transactions.

### Requirements

- Contract successfully uses require()
- Contract successfully uses assert()
- Contract successfully uses revert() statements

### Component and Functionality

`addFunds:` A function that allows users to deposit funds into the ATM. It takes an amount parameter and adds it to the ATM's balance.

`pay:` This function enables users to withdraw funds from the ATM. It deducts the specified amount from the ATM's balance and transfers it to the user.

`getBalance:` A function that retrieves the current balance of the ATM.

`owner:` An address variable representing the owner or administrator of the PharmaATM system.

### Modifiers 

onlyOwner: A modifier that restricts certain functions to be callable only by the contract's administrator.

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



```Solidity

```
