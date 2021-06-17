pragma solidity ^0.5.17;

import "./erc20/ERC20Lockable.sol";
import "./erc20/ERC20Burnable.sol";
import "./erc20/ERC20Mintable.sol";
import "./library/Pausable.sol";
import "./library/Freezable.sol";
import "./interface/IRewardGateway.sol";

contract RewardToken is
    ERC20Lockable,
    ERC20Burnable,
    ERC20Mintable,
    Freezable
{
    using SafeMath for uint256;
    string constant private _name = "Reward";
    string constant private _symbol = "REW";
    uint8 constant private _decimals = 18;
    uint256 constant private _initial_supply = 0;
    IRewardGateway internal _gateway;

    constructor() public Ownable() {
    }

    function setGateway(address gateway) external onlyOwner {
        _gateway = IRewardGateway(gateway);
    }

    function transfer(address to, uint256 amount)
        external
        whenNotFrozen(msg.sender)
        whenNotPaused
        checkLock(msg.sender, amount)
        returns (bool success)
    {
        require(
            to != address(0),
            "REW/transfer : Should not send to zero address"
        );
        _transfer(msg.sender, to, amount);
        success = true;
    }

    function transferFrom(address from, address to, uint256 amount)
        public
        whenNotFrozen(from)
        whenNotPaused
        checkLock(from, amount)
        returns (bool success)
    {
        require(
            to != address(0),
            "REW/transferFrom : Should not send to zero address"
        );
        _transfer(from, to, amount);
        _approve(
            from,
            msg.sender,
            _allowances[from][msg.sender].sub(
                amount,
                "REW/transferFrom : Cannot send more than allowance"
            )
        );
        success = true;
    }

    function approve(address spender, uint256 amount)
        external
        returns (bool success)
    {
        require(
            spender != address(0),
            "REW/approve : Should not approve zero address"
        );
        _approve(msg.sender, spender, amount);
        success = true;
    }

    function approveAndExit(uint256 amount) external returns (bool success) {
        _approve(msg.sender, address(_gateway), amount);
        _gateway.exit(msg.sender, amount);
        success = true;
    }

    function name()  external view returns (string memory tokenName) {
        tokenName = _name;
    }

    function symbol()  external view returns (string memory tokenSymbol) {
        tokenSymbol = _symbol;
    }

    function decimals()  external view returns (uint8 tokenDecimals) {
        tokenDecimals = _decimals;
    }
}
