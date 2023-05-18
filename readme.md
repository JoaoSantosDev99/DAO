# Single Proposal DAO

A contract that provides a simple voting contest to individual proposals. Capable of holding multiple proposals at once, but never cross-checking information between them. Each proposal has a target amount of votes that once reached closes the proposal with an "approved" status.

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)

## Notes

- Only owner can create proposal
- Only owner can disable proposal
- User can't vote twice
- Name to Id mapping to facilitate indexing
- Target amount is set at proposal creation
- Auto-closes when target amount is reached

## Installation and Testing

Clone repository

```bash
  git clone git@github.com:JoaoSantosDev99/DAO.git
  cd SinglePropDao
```

Tests and coverage

```bash
  forge install
  forge test
  forge coverage
```

## Optimizations/Sugestions

Auto closing a proposal by time can be added by integrading [Chainlink's Automation](https://docs.chain.link/chainlink-automation/introduction) and setting a specific time for the contract to disable the desired ID, if the target amount is not yet reached by then.
