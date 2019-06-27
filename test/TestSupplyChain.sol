pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SupplyChain.sol";
import "../contracts//SupplyChainUser.sol";
import "../contracts//ThrowProxy.sol";

contract TestSupplyChain {

    uint public initialBalance = 1 ether;
    SupplyChain sc;
    ThrowProxy proxy;
    SupplyChainUser seller;
    SupplyChainUser buyer;

    constructor() public payable {}

    function beforeAll() public{
        sc = SupplyChain(DeployedAddresses.SupplyChain());
        proxy = new ThrowProxy(address(sc));

        address(seller).transfer(500 wei);
        seller = new SupplyChainUser();

        address(buyer).transfer(20000 wei);
        buyer = (new SupplyChainUser).value(100)();
    }

    function testAddItem() public {
        string memory name = "item1";
        uint price = 10 wei;

        uint expectedSku = 0;
        uint expectedState = 0;
        address expectedSeller = address(seller);
        address expectedBuyer = address(0);

        seller.addItem(sc, name, price);
        (string memory _name, uint _sku, uint _price, uint _state, address _seller, address _buyer) = sc.fetchItem(expectedSku);

        Assert.equal(_name, name, "Name should match");
        Assert.equal(_sku, expectedSku, "Sku Number should be same");
        Assert.equal(_price, price, "Price should match");
        Assert.equal(_state, expectedState, "State should be same");
        Assert.equal(_seller, expectedSeller, "Seller should match");
        Assert.equal(_buyer, expectedBuyer, "Buyer should match");
    }

    // test for failure if user does not send enough funds
    function testBuyItemWithLessFund() public {
        uint amount = 1 wei;
        uint expectedSku = 0;
        //uint sellerInitBalance = address(seller).balance;
        //uint buyerInitBalance = address(buyer).balance;

        //Assert.equal(sellerInitBalance, 0, "Seller initial balance should be 0.");
        //Assert.equal(buyerInitBalance, 100, "Buyer initial balance should be 100.");

        buyer.buyItem(SupplyChain(address(proxy)), expectedSku, amount);
        bool r = proxy.execute.gas(20000)();
        Assert.isFalse(r, "Should be false because not enough funds were sent!");
    }
    
    function() external{
    }
    // test for purchasing an item that is not for Sale

    // shipItem

    // test for calls that are made by not the seller
    // test for trying to ship an item that is not marked Sold

    // receiveItem

    // test calling the function from an address that is not the buyer
    // test calling the function on an item not marked Shipped

}