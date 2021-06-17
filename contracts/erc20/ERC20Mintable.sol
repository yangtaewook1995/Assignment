pragma solidity 0.5.17;

import "../library/SafeMath.sol";
import "./ERC20.sol";
import "../library/Pausable.sol";
import "../role/MinterRole.sol";

contract ERC20Mintable is ERC20, Pausable, MinterRole {
    event Mint(address indexed receiver, uint256 amount);
    event MintFinished();

    using SafeMath for uint256;
    bool internal _mintingFinished;
    
    ///@notice mint token
    ///@dev only minter can call this function
    function mint(address receiver, uint256 amount)
        public
        onlyMinter
        whenNotPaused
        returns (bool success)
    {
        require(
            receiver != address(0),
            "ERC20Mintable/mint : Should not mint to zero address"
        );
        require(
            !_mintingFinished,
            "ERC20Mintable/mint : Cannot mint after finished"
        );
        _mint(receiver, amount);
        emit Mint(receiver, amount);
        success = true;
    }

    ///@notice finish minting, cannot mint after calling this function
    ///@dev only owner can call this function
    function finishMint()
        external
        onlyOwner
        returns (bool success)
    {
        require(
            !_mintingFinished,
            "ERC20Mintable/finishMinting : Already finished"
        );
        _mintingFinished = true;
        emit MintFinished();
        return true;
    }

    function isFinished() external view returns(bool finished) {
        finished = _mintingFinished;
    }
}
