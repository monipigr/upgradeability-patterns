// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

import {
    Initializable
} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {
    UUPSUpgradeable
} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {
    OwnableUpgradeable
} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Logic {
    uint256 public value;

    function setValue(uint256 _value) public {
        value = _value;
    }

    // upgradeTo() public onlyOwner {
    // }
}
