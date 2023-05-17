// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/access/Ownable.sol";

contract DAO is Ownable {
  mapping(uint256 => Proposal) public proposals;
  mapping(string => uint256) public nameToId;
  mapping(address => mapping(uint256 => bool)) public hasVotedFor;

  uint256 public totalProposals;

  struct Proposal {
    string name;
    uint256 votesTarget;
    uint256 votesBalance;
    bool approved;
    bool closed;
  }

  function newProposal(string memory _name, uint256 _target) public onlyOwner {
    proposals[0] = Proposal(_name, _target, 0, false, false);
    nameToId[_name] = 0;
    totalProposals++;
  }

  function voteProposal(uint256 _id) public {
    require(!proposals[_id].closed, "This proposal is already closed!");
    require(
      !hasVotedFor[msg.sender][_id],
      "You've voted for this proposal already"
    );

    proposals[_id].votesBalance += 1;
    hasVotedFor[msg.sender][_id] = true;
  }
}
