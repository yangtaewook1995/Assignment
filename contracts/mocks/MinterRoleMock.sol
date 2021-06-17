pragma solidity ^0.5.17;

import "../role/MinterRole.sol";

contract MinterRoleMock is MinterRole {

    constructor() MinterRole() public {}

    function onlyMinterMock() onlyMinter public {

    }
}
