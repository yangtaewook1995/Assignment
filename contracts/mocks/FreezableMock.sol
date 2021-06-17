pragma solidity ^0.5.17;

import "../library/Freezable.sol";

contract FreezableMock is Freezable {

    constructor() Freezable() public {}

    function whenNotFrozenMock(address target) whenNotFrozen(target) public {

    }
}
