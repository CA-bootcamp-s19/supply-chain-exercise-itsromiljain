pragma solidity ^0.5.0;

import "../contracts/SupplyChain.sol";

contract SupplyChainUser {

    constructor() public payable {}

    function addItem(SupplyChain _supplyChain, string memory _name, uint _price) public returns(bool){
        return _supplyChain.addItem(_name,_price);
    }

    function buyItem(SupplyChain _supplyChain, uint sku, uint amount) public payable{
        _supplyChain.buyItem.value(amount)(sku);
    }

    function shipItem(SupplyChain _supplyChain, uint sku) public{
        _supplyChain.shipItem(sku);
    }

    function receiveItem(SupplyChain _supplyChain, uint sku) public{
        _supplyChain.receiveItem(sku);
    }

    function() external payable {}
}

