pragma solidity ^0.4.0;


contract Solidity_One {
    TokenCreator creator;
    address owner;
    bytes32 name;
    function Solidity_One(bytes32 _name){
        owner = msg.sender;

        creator = TokenCreator(msg.sender);
        name = _name;
    }
}

contract
