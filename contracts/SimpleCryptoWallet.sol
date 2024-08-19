// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;
contract SimpleCryptoWallet 
{
    address public owner;

    event Deposit(address indexed sender, uint amount, uint balance);

    event Withdraw(address indexed receiver, uint amount, uint balance);

    event Transfer(address indexed sender, address indexed receiver, uint amount, uint balance);

    constructor(){
        owner = msg.sender;

        }

        modifier onlyOwner()
        {
            require(msg.sender==owner, "You are not an Owner");
            _;
        }
        
        function depositFun() external payable
        {
            emit Deposit(msg.sender, msg.value, address(this).balance);
        }

        function withdrawFun(uint _amount) external onlyOwner
        {
            require(_amount<=address(this).balance, "Insufficient Balance");
            payable(msg.sender).transfer(_amount);
            emit Withdraw(msg.sender, _amount, address(this).balance);

        }

        function transferFun(address payable _to, uint _amount) external onlyOwner
        {
            require(_amount<=address(this).balance, "Insufficient Balance");
            _to.transfer(_amount);
            emit Transfer(msg.sender, _to, _amount, address(this).balance);
        }

        function getBalance() external view returns(uint)
        {
            return address(this).balance;
        }

    
}