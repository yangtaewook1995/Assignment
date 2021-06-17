pragma solidity ^0.5.17;

interface IContents {

    /**
    * @notice 컨텐츠 생성 / 컨텐츠 ID : 0 부터 하나씩 증가 / 활성상태 : 0
    * @dev
    * @param _name : 컨텐츠 이름
    */
    function createContent(string calldata _name) external;

    /**
    * @notice 컨텐츠 ID에 해당하는 홀더 정보 (name, address, portion) 기록
    * @dev
    * @param _contentId : 정보 기록할 컨텐츠 ID
    * @param _holderName : 홀더 닉네임 (array)
    * @param _holderAddress : 홀더 address (array)
    * @param _holderPortion : 홀더 portion (array) / 0 ~ 10 / portion의 합 = 10
    */
    function addHolders(uint256 _contentId, bytes32[] calldata _holderName, address[] calldata _holderAddress, uint256[] calldata _holderPortion) external;

    /**
    * @notice 컨텐츠 ID에 해당하는 홀더 정보 삭제
    * @dev
    * @param _contentId : 정보 삭제할 컨텐츠 ID
    */
    function deleteHolders(uint256 _contentId) external;

    /**
    * @notice 컨텐츠 ID에 해당하는 홀더 정보 업테이트
    * @dev
    * @param _contentId : 정보 업데이트 할 컨텐츠 ID
    * @param _holderName : 홀더 닉네임 (array)
    * @param _holderAddress : 홀더 address (array)
    * @param _holderPortion : 홀더 portion (array) / 0 ~ 10 / portion의 합 = 10
    */
    function updateHolders(uint256 _contentId, bytes32[] calldata _holderName, address[] calldata _holderAddress, uint256[] calldata _holderPortion) external;

    /**
    * @notice ID에 해당하는 컨텐츠를 활성화
    * @dev
    * @param contentId : 활성화 할 컨텐츠의 ID
    */
    function activateContent(uint256 _contentId) external;

    /**
    * @notice ID에 해당하는 컨텐츠를 비활성화
    * @dev
    * @param contentId : 비활성화 할 컨텐츠의 ID
    */
    function deactivateContent(uint256 _contentId) external;

    /**
    * @notice 컨텐츠 ID에 해당하는 컨텐츠의 정보를 불러옴
    * @dev
    * @param contentId : 정보를 불러올 컨텐츠의 ID
    * @return name : 컨텐츠의 이름
    * @return contentId : 컨텐츠의 ID
    * @return disabled : 컨텐츠의 활성상태
    */
    function getContentInfo(uint256 _contentId) external view returns(string memory, uint256, bool);

    /**
    * @notice 컨텐츠 ID에 해당하는 홀더 정보를 불러옴
    * @dev
    * @param contentId : 홀더 정보를 불러올 컨텐츠의 ID
    * @param _num : 홀더의 index
    * @return holderName : index에 해당하는 홀더 name
    * @return holderAddress : index에 해당하는 홀더 address
    * @return holderPortion : index에 해당하는 홀더 portion
    */
    function getHolderInfo(uint256 _contentId, uint256 _num) external view returns(bytes32, address, uint256);

    /**
    * @notice 컨텐츠 ID에 해당하는 홀더의 수를 불러옴
    * @dev
    * @param contentId : 홀더의 수를 불러올 컨텐츠의 ID
    * @return holderNum : 홀더의 수
    */
    function getHolderNum(uint256 _contentId) external view returns(uint256);


    /**
    * @notice Denominator 반환.
    * @return DENOMINATOR : 10
    */
    function denominator() external view returns(uint256);

    /**
    * @notice 컨텐츠의 개수를 불러옴
    * @return _contentCounter : 컨텐츠의  수
    */
    function contentCounter() external view returns(uint256);

    /**
    * @notice 컨텐츠 생성 이벤트
    */
    event ContentsCreation (string name, uint256 indexed contentId );

    /**
    * @notice 홀더정보 기록 이벤트
    */
    event AddShareInfo (uint256 indexed contentId, bytes32[] nickName, address[] holderAddress, uint256[] holderPortion );

    /**
    * @notice 홀더정보 삭제 이벤트
    */
    event DeleteShareInfo ( uint256 indexed contentId );

    /**
    * @notice 컨텐츠 활성화 이벤트
    */
    event ContentActivation ( uint256 indexed contentId );

    /**
    * @notice 컨텐츠 비활성화 이벤트
    */
    event ContentDeactivated ( uint256 indexed contentId );
}
