// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/access/Ownable.sol";

contract SinglePropDao is Ownable {
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
    proposals[totalProposals] = Proposal(_name, _target, 0, false, false);
    nameToId[_name] = totalProposals;
    totalProposals++;
  }

  function voteProposal(uint256 _id) public {
    require(!proposals[_id].closed, "This proposal is already closed!");
    require(
      !hasVotedFor[msg.sender][_id],
      "You've voted for this proposal already"
    );

    proposals[_id].votesBalance += 1;

    if (proposals[_id].votesBalance >= proposals[_id].votesTarget) {
      proposals[_id].approved = true;
      proposals[_id].closed = true;
    }

    hasVotedFor[msg.sender][_id] = true;
  }

  function closeProposal(uint256 _id) public onlyOwner {
    require(!proposals[_id].closed, "This proposal is already closed.");
    proposals[_id].closed = true;
  }
}
