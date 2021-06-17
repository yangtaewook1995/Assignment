pragma solidity ^0.5.17;

import "../role/Ownable.sol";

contract OwnableMock is Ownable {

    constructor() Ownable() public {}
}
