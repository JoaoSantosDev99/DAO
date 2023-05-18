// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import { SinglePropDao } from "../src/SinglePropDao.sol";

contract DaoTest is Test {
  SinglePropDao public dao;

  // Agents
  address deployer;
  address zero = address(0);
  address userA = address(1);
  address userB = address(2);

  function setUp() public {
    deployer = address(this);
    dao = new SinglePropDao();
  }

  function testOwnerIsDeployer() public {
    assertEq(dao.owner(), deployer);
  }

  function testCreatProposal() public {
    string memory testName = "Proposal Name";
    uint256 testTarget = 100;

    dao.newProposal(testName, testTarget);

    (
      string memory propName,
      uint256 target,
      uint256 totalVotes,
      bool approved,
      bool finished
    ) = dao.proposals(0);

    assertEq(propName, testName);
    assertEq(target, testTarget);
    assertEq(totalVotes, 0);
    assertEq(approved, false);
    assertEq(finished, false);
  }

  function testIncreaseProposalCounter() public {
    string memory testName = "Proposal Name";
    uint256 testTarget = 100;

    assertEq(dao.totalProposals(), 0);
    dao.newProposal(testName, testTarget);
    assertEq(dao.totalProposals(), 1);
  }

  function testMapsNameToId() public {
    string memory testName = "Proposal Name";
    uint256 testTarget = 100;
    uint256 expectedId = dao.totalProposals();

    assertEq(dao.totalProposals(), 0);
    dao.newProposal(testName, testTarget);
    assertEq(dao.totalProposals(), 1);
    assertEq(dao.nameToId(testName), expectedId);

    string memory testName2 = "Proposal Name";
    uint256 testTarget2 = 100;
    uint256 expectedId2 = dao.totalProposals();

    dao.newProposal(testName2, testTarget2);
    assertEq(dao.nameToId(testName2), expectedId2);
  }

  function testVoteProposal() public {
    uint256 propId = dao.totalProposals();

    (, , uint256 totalVotes, , ) = dao.proposals(propId);

    assertEq(totalVotes, 0);
    dao.newProposal("Test", 100);
    assertEq(dao.totalProposals(), 1);

    dao.voteProposal(propId);

    (, , uint256 totalVotes2, , ) = dao.proposals(propId);
    assertEq(totalVotes2, totalVotes + 1);
  }

  function testRevertVoteTwice() public {
    uint256 propId = dao.totalProposals();

    dao.newProposal("Test", 100);
    assertEq(dao.totalProposals(), 1);

    dao.voteProposal(propId);

    vm.expectRevert(bytes("You've voted for this proposal already"));
    dao.voteProposal(propId);
  }

  function testClosesOnTargetReach() public {
    uint256 propId = dao.totalProposals();

    dao.newProposal("Test", 3);
    assertEq(dao.totalProposals(), 1);
    dao.voteProposal(propId);

    vm.prank(userA);
    dao.voteProposal(propId);

    vm.prank(userB);
    dao.voteProposal(propId);

    (, , , bool approved, bool closed) = dao.proposals(0);

    assert(approved);
    assert(closed);
  }

  function testRevertVoteOnClosed() public {
    uint256 propId = dao.totalProposals();

    dao.newProposal("Test", 3);
    assertEq(dao.totalProposals(), 1);
    dao.voteProposal(propId);

    vm.prank(userA);
    dao.voteProposal(propId);

    vm.prank(userB);
    dao.voteProposal(propId);

    (, , , bool approved, bool closed) = dao.proposals(0);

    assert(approved);
    assert(closed);

    vm.expectRevert(bytes("This proposal is already closed!"));
    dao.voteProposal(propId);
  }

  function testOwnerCloses() public {
    uint256 propId = dao.totalProposals();

    dao.newProposal("Test", 10);
    dao.closeProposal(propId);

    vm.expectRevert(bytes("This proposal is already closed!"));
    dao.voteProposal(propId);
    (, , , , bool closed) = dao.proposals(propId);
    assert(closed);
  }

  function testReverstOwnerClosesTwice() public {
    uint256 propId = dao.totalProposals();

    dao.newProposal("Test", 10);
    dao.closeProposal(propId);

    vm.expectRevert(bytes("This proposal is already closed."));
    dao.closeProposal(propId);
    (, , , , bool closed) = dao.proposals(propId);
    assert(closed);
  }

  function testRevertCloserIsNotOwner() public {
    uint256 propId = dao.totalProposals();

    dao.newProposal("Test", 10);

    vm.prank(userA);
    vm.expectRevert(bytes("Ownable: caller is not the owner"));
    dao.closeProposal(propId);

    dao.voteProposal(propId);

    (, , uint256 target, , bool closed) = dao.proposals(propId);
    assert(!closed);
    assertEq(target, 1);
  }
}
