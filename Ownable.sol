// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.7.5;

contract Ownable {
    // if we put public at the state variable, when we compile contract, it will automatically
    // create the function to get the value for that variable
    address public owner;

    modifier onlyOwner {
        require(msg.sender == owner);
        _; // this underscore means - run the function
    }

    constructor() {
        owner = msg.sender;
    }
}
