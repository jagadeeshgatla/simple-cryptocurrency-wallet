// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SimpleCryptoWallet {

    // Mapping to store the balance of each token for each address
    mapping(address => mapping(address => uint256)) public tokenBalances;

    // Event to log deposits
    event Deposit(address indexed token, address indexed from, uint256 amount);

    // Event to log withdrawals
    event Withdrawal(address indexed token, address indexed to, uint256 amount);

    // Event to log token transfers
    event Transfer(address indexed token, address indexed from, address indexed to, uint256 amount);

    // Function to deposit tokens into the wallet
    function depositToken(address _token, uint256 _amount) public {
        require(_amount > 0, "Deposit amount must be greater than zero.");

        // Transfer tokens from the sender to this contract
        IERC20(_token).transferFrom(msg.sender, address(this), _amount);

        // Update the balance
        tokenBalances[_token][msg.sender] += _amount;

        emit Deposit(_token, msg.sender, _amount);
    }

    // Function to withdraw tokens from the wallet
    function withdrawToken(address _token, uint256 _amount) public {
        require(_amount > 0, "Withdrawal amount must be greater than zero.");
        require(tokenBalances[_token][msg.sender] >= _amount, "Insufficient balance.");

        // Update the balance
        tokenBalances[_token][msg.sender] -= _amount;

        // Transfer tokens from the contract to the sender
        IERC20(_token).transfer(msg.sender, _amount);

        emit Withdrawal(_token, msg.sender, _amount);
    }

    // Function to transfer tokens to another address
    function transferToken(address _token, address _to, uint256 _amount) public {
        require(_amount > 0, "Transfer amount must be greater than zero.");
        require(tokenBalances[_token][msg.sender] >= _amount, "Insufficient balance.");
        require(_to != address(0), "Invalid address.");

        // Update balances
        tokenBalances[_token][msg.sender] -= _amount;
        tokenBalances[_token][_to] += _amount;

        emit Transfer(_token, msg.sender, _to, _amount);
    }

    // Function to check the balance of a token for a specific user
    function checkTokenBalance(address _token, address _user) public view returns (uint256) {
        return tokenBalances[_token][_user];
    }
}
