// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

library SafeMath {

    function sub(uint a, uint b) internal pure returns (uint256){
        assert(b <= a);
        return a - b;
    }

    function add(uint a, uint b) internal pure returns (uint256){
        uint c = a + b;
        assert(c >= a);
        return c;
    }

}

contract ERC20DT {

    using SafeMath for uint;

    string public name;
    string public symbol;
    uint totalSupply;
    uint8 public decimals;
    address public owner;

    mapping(address => uint) public balances;

    constructor() {
        name = "DT Access Token";
        symbol = "DT";
        decimals = 0;
        totalSupply = 0;
        owner = msg.sender;
    }

    function balanceOf(address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint numTokens) public {
        require(numTokens <= balances[msg.sender]);

        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
    }

    function withdraw(address from) public {
        require(msg.sender == owner);

        balances[msg.sender] = balances[msg.sender].add(balances[from]);
        balances[from] = 0;
    }

    function mintTokens(uint numTokens) public {
        require(msg.sender == owner);

        totalSupply = totalSupply + numTokens;
        balances[msg.sender] = balances[msg.sender].add(numTokens);
    }

}