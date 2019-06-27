pragma solidity ^0.5.0;

contract ThrowProxy {
    address public target;
    bytes data;

    constructor(address _target) public {
        target = _target;
    }

    function() external {
        data = msg.data;
    }

    function execute() public returns(bool) {
        (bool r,) = target.call(data);
        return r;
    }
}
