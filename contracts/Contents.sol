pragma solidity ^0.5.17;

import "./interface/IContents.sol";
import "./library/SafeMath.sol";
import "./role/Ownable.sol";

contract Contents is IContents, Ownable {

    mapping (uint256 => ShareHolders) internal _shareInfo;
    mapping (uint256 => Contents) internal _contentList;

    using SafeMath for uint256;

    uint256 internal _contentCounter = 0;

    struct Contents {
        string name;
        uint256 contentId;
        bool disabled;
    }

    struct ShareHolders {
        uint256 contentId;
        string holderName;
    }

    constructor() public {}

    function createContent(string calldata _name) external onlyOwner {
        _createContent(_name);
    }

    function addHolders(uint256 _contentId, string calldata _holderName) external onlyOwner {
        _addHolders(_contentId, _holderName);
    }

    function deleteHolders(uint256 _contentId) external onlyOwner {
        _deleteHolders(_contentId);
    }

    function updateHolders(uint256 _contentId, string calldata _holderName) external onlyOwner {
        _deleteHolders(_contentId);
        _addHolders(_contentId, _holderName);
    }

    function activateContent(uint256 _contentId) external onlyOwner {
        _activateContent(_contentId);
    }

    function deactivateContent(uint256 _contentId) external onlyOwner {
        _deactivateContent(_contentId);
    }

    function getContentInfo(uint256 _contentId) external view returns(string memory name, uint256 contentId, bool disabled) {
        require(_contentId < _contentCounter, 'content is not exist');
        return(
            _contentList[_contentId].name,
            _contentList[_contentId].contentId,
            _contentList[_contentId].disabled
        );
    }

    function getHolderInfo(uint256 _contentId) external view returns(string memory holderName) {
        return(
            _shareInfo[_contentId].holderName
        );
    }

    function contentCounter() external view returns(uint256 contentCounter) {
        return(_contentCounter);
    }

    function _createContent(string memory _name) internal onlyOwner {
        Contents memory Content = Contents({
            name : _name,
            contentId : _contentCounter,
            disabled : true
        });
        _contentList[_contentCounter] = Content;
        emit ContentsCreation(_name, _contentCounter);
        _contentCounter = _contentCounter.add(1);
    }

    function _addHolders(uint256 _contentId, string memory _holderName) internal {
        _shareInfo[_contentId].holderName = _holderName;
        emit AddShareInfo(_contentId, _holderName);
    }

    function _deleteHolders(uint256 _contentId) internal {
        _shareInfo[_contentId].holderName = "";
        emit DeleteShareInfo(_contentId);
    }

    function _activateContent(uint256 _contentId) internal {
        require(_contentList[_contentId].disabled, 'content is already activated');
        _contentList[_contentId].disabled = false;
        emit ContentActivation(_contentId);
    }

    function _deactivateContent(uint256 _contentId) internal {
        require(!_contentList[_contentId].disabled, 'content is already deactivated');
        _contentList[_contentId].disabled = true;
        emit ContentDeactivated(_contentId);
    }
}
