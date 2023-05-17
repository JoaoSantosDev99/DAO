// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Dao.sol";

contract DaoTest is Test {
  DAO public dao;

  // Agents
  address deployer;
  address zero = address(0);
  address userA = address(1);
  address userB = address(2);

  function setUp() public {
    deployer = address(this);
    dao = new DAO();
  }

  function testCreatProposal() public {
    assertEq(dao.totalProposals(), 0);
    dao.newProposal("test", 100);
    // assertEq(dao.proposals[0].name, "test");
    assertEq(dao.totalProposals(), 1);
  }

  function testOwnerIsDeployer() public {
    assertEq(dao.owner(), deployer);
  }

  // function test_RevertWenCallerIsNotOwner() public {}
}
