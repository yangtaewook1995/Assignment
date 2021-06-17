pragma solidity ^0.5.17;

import "./interface/IContents.sol";
import "./interface/IERC20.sol";
import "./interface/IRewardGateway.sol";
import "./library/SafeMath.sol";
import "./role/Ownable.sol";

contract RewardGateway is IRewardGateway , Ownable {

    using SafeMath for uint256;

    IContents internal _contents;
    IERC20 internal _rewardToken;

    // payment 히스토리 확인용
    // contentId => history(array)
    mapping(uint256=>uint256[]) internal _paymentsHistory;

    // withdraw 히스토리 확인용
    // withdrawer => history(array)
    mapping(address=>uint256[]) internal _exitHistory;

    address internal _contractCreator;

    constructor(address _contentsAddress, address _rewardAddress) public {
        _contents = IContents(_contentsAddress);
        _rewardToken = IERC20(_rewardAddress);
        _contractCreator = msg.sender;
    }

    // 두번 호출 되면 이상할텐데 ?
    // 두번 호출됐는지 확인 할 수 있는 무언가가 필요하겠다!
    function pay(uint256 _contentId, uint256 _amount) onlyOwner external {
        (/*contentName*/, /*contentId*/, bool disabled) = _contents.getContentInfo(_contentId);
        require(disabled != true, "Content should activated first");
        _rewardToken.mint(address(this), _amount);
        //_rewardToken.transferFrom(msg.sender, address(this), _amount);
        uint256 length = _contents.getHolderNum(_contentId);
        uint256 den = _contents.denominator();
        for(uint256 i = 0; i < length; i++){
            (/*holderName*/,address holder, uint256 portion) = _contents.getHolderInfo(_contentId, i);
            _rewardToken.transfer(holder, _amount.mul(portion).div(den));
        }
        _paymentsHistory[_contentId].push(_amount);
        emit Payment(_contentId, _amount);
    }

    // owner가 다 해도 돼?
    // 그게 진짜 디자인인가?
    // withdraw 호출한거 트래킹 실패했을 경우 어떻게 처리하나?
    function exit(address _withdrawer, uint256 amount) external {
        uint256 tokenAmount = _rewardToken.balanceOf(_withdrawer);
        require(amount <= tokenAmount, "Cannot exit more than balance");
        _rewardToken.transferFrom(_withdrawer, address(this), amount); 
        _rewardToken.transfer(_contractCreator, amount);
        _exitHistory[_withdrawer].push(amount);
        emit Exit(_withdrawer, amount);
    }

    function paymentsHistory(uint256 _contentId) external view returns(uint256[] memory){
        return _paymentsHistory[_contentId];
    }

    function paymentsHistoryLength(uint256 _contentId) external view returns(uint256){
        return _paymentsHistory[_contentId].length;
    }

    function paymentsHistory(uint256 _contentId, uint256 _idx) external view returns(uint256){
        return _paymentsHistory[_contentId][_idx];
    }

    function exitHistory(address _withdrawer) external view returns(uint256[] memory){
        return _exitHistory[_withdrawer];
    }

    function exitHistoryLength(address _withdrawer) external view returns(uint256){
        return _exitHistory[_withdrawer].length;
    }

    function exitHistory(address _withdrawer, uint256 _idx) external view returns(uint256){
        return _exitHistory[_withdrawer][_idx];
    }
}
