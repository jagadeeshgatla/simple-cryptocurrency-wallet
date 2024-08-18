// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;
contract Day6 {

function reverseDigit(uint n) public pure returns(uint)
{
uint reversenumber =0;
while (n != 0)
{
uint remainder = n % 10;
reversenumber = reversenumber*10 +remainder;
n /= 10; 
}
return reversenumber;    
}
}
