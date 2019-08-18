pragma solidity ^0.5.0;

import "../contracts/SupplyChain.sol";

contract Proxy {

    SupplyChain public _supplyChain;

    constructor(SupplyChain supplyChain) public { _supplyChain = supplyChain; }

    function() external payable {}

    /*function getTarget() public view returns (SupplyChain){
        return _supplyChain;
    }*/

    function addItem(string memory _name, uint256 _price) public {
        _supplyChain.addItem(_name, _price);
    }

    function buyItem(uint256 sku, uint256 amount) public returns (bool){
       (bool success,) = address(_supplyChain).call.value(amount)(abi.encodeWithSignature("buyItem(uint256)",sku));
       return success;
    }

    function shipItem(uint256 sku) public returns(bool){
       (bool success,) = address(_supplyChain).call(abi.encodeWithSignature("shipItem(uint256)",sku));
       return success;
    }

    function receiveItem(uint256 sku) public returns(bool){
        (bool success,) = address(_supplyChain).call(abi.encodeWithSignature("receiveItem(uint256)",sku));
       return success;
    }   
}
