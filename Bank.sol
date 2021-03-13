pragma solidity 0.7.5;
pragma abicoder v2;
import "./Ownable.sol";

interface GovernmentInterface {
    function addTransaction(
        address _from,
        address _to,
        uint256 _amount
    ) external payable;
}

contract Bank is Ownable {
    GovermentInterface governmentInstance;

    // we want to minimize storage data, because it costs lot of gas to use storage data
    mapping(address => uint256) balance;

    event depositDone(uint256 amount, address indexed depositedTo);

    constructor(address government) {
        governmentInstance = GovermentInterface(government);
    }

    function deposit() public payable returns (uint256) {
        balance[msg.sender] += msg.value;
        emit depositDone(msg.value, msg.sender);
        return balance[msg.sender];
    }

    function withdraw(uint256 amount) public onlyOwner returns (uint256) {
        require(balance[msg.sender] >= amount);
        msg.sender.transfer(amount);
        return balance[msg.sender];
    }

    function getBalance() public view returns (uint256) {
        return balance[msg.sender];
    }

    function transfer(address recipient, uint256 amount) public {
        require(balance[msg.sender] >= amount, "Balance not sufficient");
        require(msg.sender != recipient, "Don't transfer money to yourself");

        uint256 previousSenderBalance = balance[msg.sender];

        _transfer(msg.sender, recipient, amount);

        governmentInstance.addTransaction(msg.sender, recipient, amount);

        assert(balance[msg.sender] == previousSenderBalance - amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        balance[from] = balance[from] - amount;
        balance[to] = balance[to] + amount;
    }

    function getTransfers() external view returns (uint256[] memory) {}
}
