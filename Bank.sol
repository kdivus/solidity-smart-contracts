// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.7.5;

import "./Ownable.sol";
import "./Destroyable.sol";

interface GovernmentInterface {
    function addTransaction(
        address _from,
        address _to,
        uint256 _amount
    ) external payable;
}

contract Bank is Ownable, Destroyable {
    GovernmentInterface governmentInstance =
        GovernmentInterface(0xa131AD247055FD2e2aA8b156A11bdEc81b9eAD95);

    mapping(address => uint256) balance;

    event depositDone(uint256 amount, address indexed depositedTo);

    function deposit() public payable returns (uint256) {
        balance[msg.sender] += msg.value;
        emit depositDone(msg.value, msg.sender);
        return balance[msg.sender];
    }

    function withdraw(uint256 amount) public onlyOwner returns (uint256) {
        // msg.sender is an payable address
        // transfer has built in error handling
        msg.sender.transfer(amount);
    }

    function getBalance() public view returns (uint256) {
        return balance[msg.sender];
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function transfer(address recipient, uint256 amount) public {
        require(balance[msg.sender] >= amount, "Balance not sufficient!");
        require(
            msg.sender != recipient,
            "Transfering money to yourself is forbidden!"
        );

        uint256 previousSenderBalance = balance[msg.sender];

        _transfer(msg.sender, recipient, amount);

        governmentInstance.addTransaction{value: 1 ether}(
            msg.sender,
            recipient,
            amount
        );

        assert(balance[msg.sender] == previousSenderBalance - amount);
    }

    // it is common to internal function name with underscore
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        balance[from] -= amount;
        balance[to] += amount;
    }
}
