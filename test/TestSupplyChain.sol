pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SupplyChain.sol";
import "../contracts//Proxy.sol";

contract TestSupplyChain {

    uint public initialBalance = 1 ether;
    SupplyChain public sc;
    Proxy public seller;
    Proxy public buyer;

    string name = "item1";
    uint256 price = 10 ;
    uint256 itemSku = 0;

    constructor() public payable {}

    function() external payable{}

    event LogTestShipped(bool result);

    function beforeAll() public{
        sc = SupplyChain(DeployedAddresses.SupplyChain());
        seller = new Proxy(sc);
        buyer = new Proxy(sc);

        uint256 seedValue = price + 10;
        address(buyer).transfer(seedValue);
        seller.addItem(name, price);
    }

    function testAddItem() public {
        string memory expectedName = "item1";
        uint256 expectedPrice = 10;
        uint256 expectedSku = 0;
        uint256 expectedState = 0;
        address expectedSeller = address(seller);
        address expectedBuyer = address(0);

        (string memory _name, uint _sku, uint _price, uint _state, address _seller, address _buyer) = sc.fetchItem(expectedSku);

        Assert.equal(_name, expectedName, "Name should match");
        Assert.equal(_sku, expectedSku, "Sku Number should be same");
        Assert.equal(_price, expectedPrice, "Price should match");
        Assert.equal(_state, expectedState, "State should be same");
        Assert.equal(_seller, expectedSeller, "Seller should match");
        Assert.equal(_buyer, expectedBuyer, "Buyer should match");
    }

    // test for failure if user does not send enough funds
    function testPurchaseItemWithLessFund() public {
        uint256 amount = price-1; 
        bool r = buyer.buyItem(itemSku, amount);
        Assert.isFalse(r, "Should be false because not enough funds were sent!");
    }

    // test for purchasing an item that is not for Sale
    function testPurchasingItemNotForSale() public {
        uint256 amount = price+1;
        bool r = buyer.buyItem(5, amount);
        Assert.isFalse(r, "Should be false because Item is not on sale!");
    }

    // shipItem
    function testShipItem() public {
        uint256 amount = price+1;
        buyer.buyItem(itemSku, amount);
        bool r = seller.shipItem(itemSku);
        Assert.isTrue(r, "Should be true as Item is shipped!");
    }

    // test for calls that are made by not the seller
    function testCallsNotMadeBySeller() public {
        bool r = buyer.shipItem(itemSku);
         Assert.isFalse(r, "Should be false because call is not made by seller!");
    }
    // test for trying to ship an item that is not marked Sold
    function testShipItemsNotMarkedSold() public {
        bool r = seller.shipItem(itemSku);
        Assert.isFalse(r, "Should be false because Item is not marked Sold!");
    }

    // receiveItem
    function testReceiveItem() public {
        uint256 amount = price+1;
        buyer.buyItem(itemSku, amount);
        seller.shipItem(itemSku);
        bool r = buyer.receiveItem(itemSku);
        Assert.isTrue(r, "Should be true because Item is received by the buyer!");
    }
    // test calling the function from an address that is not the buyer
    function testFunctionCallsNotMadeByBuyer() public {
        bool r = seller.receiveItem(itemSku);
        Assert.isFalse(r, "Should be false because call is not made by buyer!");
    }
    // test calling the function on an item not marked Shipped
    function testItemNotMarkedShipped() public {
        uint256 amount = price+1;
        buyer.buyItem(itemSku, amount);
        bool r = buyer.receiveItem(itemSku);
        Assert.isFalse(r, "Should be false because Item is not yet marked Shipped!");
    }
}