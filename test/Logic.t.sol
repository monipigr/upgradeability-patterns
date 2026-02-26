// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Logic} from "../src/Logic.sol";
import {Logic2} from "../src/Logic2.sol";
import {Proxy} from "../src/Proxy.sol";

contract LogicTest is Test {
    Logic public logic;
    Logic2 public logic2;
    Proxy public proxy;

    function setUp() public {
        logic = new Logic();
        proxy = new Proxy(address(logic), "");

        (bool success, ) = address(proxy).call(
            abi.encodeWithSignature("initialize(address)", address(this))
        );
        assertTrue(success);

        (bool success2, ) = address(proxy).call(
            abi.encodeWithSignature("setNumber(uint256)", 5)
        );
        assertTrue(success2);
    }

    function test_proxy_and_logicV1_deployed_properly() public {
        (bool success, bytes memory number) = address(proxy).call(
            abi.encodeWithSignature("number()")
        );

        assertTrue(success);
        assertEq(number, abi.encodePacked(uint256(5)));
    }

    function test_logicV1_initialize() public {
        (bool success, bytes memory initialOwner) = address(proxy).call(
            abi.encodeWithSignature("owner()")
        );

        assertTrue(success);
        assertNotEq(abi.decode(initialOwner, (address)), address(0));
    }
}
