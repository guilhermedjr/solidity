pragma solidity ^0.8.4;

contract Auction {
    address public beneficiary;
    uint256 limit_time_to_interact_with_auction;

    uint256 public highest_bid;
    address public highest_bidder;

    mapping(address => uint256) valores_a_receber;

    constructor(address beneficiary_, uint256 limit_time) {
        beneficiary = beneficiary_;
        limit_time_to_interact_with_auction = block.timestamp + limit_time;
    }

    function bid() external payable {
        require(msg.value > 0);
        require(block.timestamp < limit_time_to_interact_with_auction);

        if (msg.value > highest_bid) {
            valores_a_receber[highest_bidder] = highest_bid;

            highest_bidder = msg.sender;
            highest_bid = msg.value;
        }
    }

    event withdralSuccess(address, uint256);

    function withdral() public {
        uint256 qtd_a_receber = valores_a_receber[msg.sender];

        valores_a_receber[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: qtd_a_receber}("");
        require(success);
        emit withdralSuccess(msg.sender, qtd_a_receber);
    }
}
