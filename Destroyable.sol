// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.7.5;

import "./Ownable.sol";

contract Destroyable is Ownable {
    function destroy() public onlyOwner {
        selfdestruct(msg.sender);
    }
}

//https://articles.caster.io/blockchain/self-destructing-smart-contracts-in-ethereum/
