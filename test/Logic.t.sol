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

    function test_increment_before_upgrade() public {
        (bool success, ) = address(proxy).call(
            abi.encodeWithSignature("increment()")
        );
        assertTrue(success);

        (bool success2, bytes memory incrementedNumber) = address(proxy).call(
            abi.encodeWithSignature("number()")
        );
        assertTrue(success2);

        assertEq(incrementedNumber, abi.encodePacked(uint256(6)));
    }

    function test_upgrade() public {
        logic2 = new Logic2();
        (bool success, ) = address(proxy).call(
            abi.encodeWithSignature(
                "upgradeToAndCall(address,bytes)",
                address(logic2),
                ""
            )
        );
        assertEq(success, true);

        (bool success2, ) = address(proxy).call(
            abi.encodeWithSignature("initialize(address)", address(this))
        );
        assertTrue(success2);

        (bool success3, ) = address(proxy).call(
            abi.encodeWithSignature("setNumber(uint256)", 5)
        );
        assertTrue(success3);

        (bool success4, ) = address(proxy).call(
            abi.encodeWithSignature("increment()")
        );
        assertTrue(success4);

        (bool success5, bytes memory incrementedNumber) = address(proxy).call(
            abi.encodeWithSignature("number()")
        );
        assertTrue(success5);
        assertEq(incrementedNumber, abi.encodePacked(uint256(10)));
    }
}
