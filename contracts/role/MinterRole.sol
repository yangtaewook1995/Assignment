pragma solidity 0.5.17;

import "./Ownable.sol";

contract MinterRole is Ownable {
    mapping(address => bool) private _minter;

    event MinterAdded(address indexed target);
    event MinterDeleted(address indexed target);

    modifier onlyMinter() {
        require(_minter[msg.sender], "MinterRole : msg.sender is not _minter");
        _;
    }

    function addMinter(address target) external onlyOwner returns (bool success) {
        _minter[target] = true;
        emit MinterAdded(target);
        success = true;
    }

    function deleteMinter(address target) external onlyOwner returns (bool success) {
        _minter[target] = false;
        emit MinterDeleted(target);
        success = true;
    }

    function isMinter(address target) external view returns (bool) {
        return _minter[target];
    }
}