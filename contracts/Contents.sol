pragma solidity ^0.5.17;

import "./interface/IContents.sol";
import "./library/SafeMath.sol";
import "./role/Ownable.sol";


contract Contents is IContents, Ownable {

    mapping (uint256 => ShareHolders) internal _shareInfo;
    mapping (uint256 => Contents) internal _contentList;

    using SafeMath for uint256;

    uint256 internal _contentCounter = 0;
    uint256 constant private DENOMINATOR = 100000;

    // 컨텐츠에 대한 정보
    struct Contents {
        string name;  // 컨텐츠 이름
        uint256 contentId;  // 컨텐츠 ID
        bool disabled;  // 컨텐츠 활성상태 (on : false)
    }

    // 지분에 대한 정보
    struct ShareHolders {
        uint256 contentId;  // 컨텐츠 ID
        bytes32[] holderName; // 지분 소유자 닉네임
        address[] holderAddress;  // 지분 소유자 주소
        uint256[] holderPortion;  // 지분 얼만큼 (0~10)
    }

    constructor() public {}

    function createContent(string calldata _name) external onlyOwner {
        _createContent(_name);
    }

    function addHolders(uint256 _contentId, bytes32[] calldata _holderName, address[] calldata _holderAddress, uint256[] calldata _holderPortion) external onlyOwner {
        _addHolders(_contentId, _holderName, _holderAddress, _holderPortion);
    }

    function deleteHolders(uint256 _contentId) external onlyOwner {
        _deleteHolders(_contentId);
    }

    function updateHolders(uint256 _contentId, bytes32[] calldata _holderName, address[] calldata _holderAddress, uint256[] calldata _holderPortion) external onlyOwner {
        require(_shareInfo[_contentId].holderAddress.length != 0, 'add holders first');
        _deleteHolders(_contentId);
        _addHolders(_contentId, _holderName, _holderAddress, _holderPortion);
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

    function getHolderInfo(uint256 _contentId, uint256 _num) external view returns(bytes32 holderName, address holderAddress, uint256 holderPortion) {
        require(_shareInfo[_contentId].holderAddress.length != 0, 'no holder');
        return(
            _shareInfo[_contentId].holderName[_num],
            _shareInfo[_contentId].holderAddress[_num],
            _shareInfo[_contentId].holderPortion[_num]
        );
    }

    function getHolderNum(uint256 _contentId) external view returns( uint256 holderNum ) {
        if (_shareInfo[_contentId].holderAddress.length == 0) return 0;
        else return(_shareInfo[_contentId].holderAddress.length);
    }

    function denominator() external view returns(uint256) {
        return DENOMINATOR;
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

    function _addHolders(uint256 _contentId, bytes32[] memory _holderName, address[] memory _holderAddress, uint256[] memory _holderPortion) internal {
        require(_holderAddress.length == _holderPortion.length, '#Address != #Portion');
        require(_holderAddress.length == _holderName.length, '#Address != #Name');
        require(_holderAddress.length <= 100, "#Holder should under 100");
        uint256 counter = 0;
        for(uint i = 0 ; i < _holderPortion.length ; i++) counter = _holderPortion[i].add(counter);
        require(counter == DENOMINATOR , 'portion sum is not equal to denominator');
        for(uint i = 0 ; i < _holderAddress.length; i++){
            bytes32 holderName = _holderName[i];
            address holderAddress = _holderAddress[i];
            uint256 holderPortion = _holderPortion[i];
            _shareInfo[_contentId].holderName.push(holderName);
            _shareInfo[_contentId].holderAddress.push(holderAddress);
            _shareInfo[_contentId].holderPortion.push(holderPortion);
        }
        emit AddShareInfo(_contentId, _holderName, _holderAddress, _holderPortion);
    }

    function _deleteHolders(uint256 _contentId) internal {
        _shareInfo[_contentId].holderName.length = 0;
        _shareInfo[_contentId].holderAddress.length = 0;
        _shareInfo[_contentId].holderPortion.length = 0;
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
