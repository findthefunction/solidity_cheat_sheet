// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


// Set up interface
interface IERC20 {
  function transfer(address, uint) external returns (bool);

  function transferFrom(
    address,
    address,
    uint
  ) external returns (bool);
}

contract CrowdFund {
  event Launch(
    uint id, 
    address indexed creator,
    uint goal,
    uint32 startAt,
    uint32 endAt
  );
  event Cancel(uint id);
  event Pledge(uint indexed id, address indexed caller, uint amount);
  event Claim(uint id);
  event Refund(uint id, address indexed caller, uint amount);

  struct Campaign {
    // Creator of campaign
    address creator;
    // Amount of tokens to raise
    uint goal;
    // Total amount pledged
    uint pledged;
    // Timestamp of start of campaign
    uint32 startAt;
    // Timestamp of end of campaign
    uint32 endAt;
    // True if goal was reached and creator has claimed the tokens.
    bool claimed;
  }


IERC20 public immutable token;
// Total count of campaigns created
// Also used to generate id for new campaigns.
uint public count;
// Mapping from id to Campaign
mapping(uint => Campaign) public campaigns;
// Mappijng from campaign id => pledger => amount pledged
mapping(uint => mapping(address => uint)) public pledgeAmount;

constructor(address _token) {
  token = IERC20(_token);
}

function launch(
  uint _goal,
  uint32 _startAt,
  uint32 _endAt
) external {
  require(_startAt >= block.timestamp, "start at < now");
  require(_endAt >= _startAt, "end at < start at");
  require(_endAt <= block.timestamp + 90 days, "end at > max duration");

  count += 1;
  campaigns[count] = Campaign({
    creator: msg.sender,
    goal: _goal,
    pledged: 0,
    startAt: _startAt,
    endAt: _endAt,
    claimed: false
  });
}

}