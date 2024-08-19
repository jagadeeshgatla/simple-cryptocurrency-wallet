// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleWallet {
    // Mapping to store the balance of each address
    mapping(address => uint256) public balances;

    // Event to log deposits
    event Deposit(address indexed from, uint256 amount);

    // Event to log withdrawals
    event Withdrawal(address indexed to, uint256 amount);

    // Function to deposit Ether into the wallet
    function deposit() public payable {
        require(msg.value > 0, "Deposit value must be greater than zero.");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // Function to withdraw Ether from the wallet
    function withdraw(uint256 _amount) public {
        require(_amount > 0, "Withdrawal amount must be greater than zero.");
        require(balances[msg.sender] >= _amount, "Insufficient balance.");
        
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
        emit Withdrawal(msg.sender, _amount);
    }

    // Function to check the balance of the sender's wallet
    function checkBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    // Function to send Ether to another address
    function sendEther(address payable _to, uint256 _amount) public {
        require(_amount > 0, "Send amount must be greater than zero.");
        require(balances[msg.sender] >= _amount, "Insufficient balance.");
        require(_to != address(0), "Invalid address.");

        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
        _to.transfer(_amount);
    }

    // Fallback function to handle Ether sent directly to the contract
    fallback() external payable {
        deposit();
    }

    // Receive function to handle Ether sent directly to the contract
    receive() external payable {
        deposit();
    }
}