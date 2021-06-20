pragma solidity ^0.5.17;

interface IContents {
    function createContent(string calldata _name) external;
    function addHolders(uint256 _contentId, string calldata _holderName) external;
    function deleteHolders(uint256 _contentId) external;
    function updateHolders(uint256 _contentId, string calldata _holderName) external;
    function activateContent(uint256 _contentId) external;
    function deactivateContent(uint256 _contentId) external;
    function getContentInfo(uint256 _contentId) external view returns(string memory, uint256, bool);
    function getHolderInfo(uint256 _contentId) external view returns(string memory);
    function contentCounter() external view returns(uint256);

    event ContentsCreation (string name, uint256 indexed contentId);
    event AddShareInfo (uint256 indexed contentId, string holderName);
    event DeleteShareInfo (uint256 indexed contentId);
    event ContentActivation (uint256 indexed contentId);
    event ContentDeactivated (uint256 indexed contentId);
}
