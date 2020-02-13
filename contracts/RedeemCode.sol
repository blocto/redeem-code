pragma solidity >0.5.0;

import "@openzeppelin/contracts/Ownership/Ownable.sol";

contract RedeemCode is Ownable {
    /**
     * ----- Contract Variables -----
     */
    mapping(address => bool) public claimable;
    uint256 public redeemAmount = 0.01 ether;

    /**
     * ----- Owner Methods -----
     */

    /**
     * @dev Add a redeem code address
     */
    function addRedeemCode(address _redeemCodeAddress)
        public
        onlyOwner
    {
        claimable[_redeemCodeAddress] = true;
    }

    /**
     * @dev Add multiple redeem code addresses
     */
    function addRedeemCodes(address[] memory _redeemCodeAddresses)
        public
        onlyOwner
    {
        for (uint i = 0; i < _redeemCodeAddresses.length; i++) {
            addRedeemCode(_redeemCodeAddresses[i]);
        }
    }

    /**
     * @dev Update redeem amount for each redeem code
     */
    function setRedeemAmount(uint256 _redeemAmount)
        public
        onlyOwner
    {
        redeemAmount = _redeemAmount;
    }

    /**
     * @dev Withdraw all ETH in contract
     */
    function withdrawAll()
        public
        onlyOwner
    {
        _msgSender().transfer(address(this).balance);
    }
    
    /**
     * ----- Public Methods -----
     */
    
    /**
     * @dev Default payable function
     */
    function()
        external
        payable
    {
    }

    /**
     * @dev Get the personal signature challenge for caller
     */
    function getPersonalChallenge()
        public
        view
        returns (bytes32 challenge)
    {
        return keccak256(abi.encodePacked(
            "How much ETH would a woodchuck redeem if a woodchuck could redeem ETH?",
            _msgSender()
        ));
    }

    /**
     * @dev Consume a redeem code
     */
    function redeem(
        address _redeemCodeAddress,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    )
        public
    {
        // Check redeem code address
        require(
            claimable[_redeemCodeAddress],
            "RedeemCode: not a claimable redeemCodeAddress"
        );

        // Check signature
        require(
            _redeemCodeAddress == ecrecover(getPersonalChallenge(), _v, _r, _s),
            "RedeemCode: invalid signature"
        );

        // Transfer ETH
        msgSender.transfer(redeemAmount);
        claimable[_redeemCodeAddress] = false;
    }
}
