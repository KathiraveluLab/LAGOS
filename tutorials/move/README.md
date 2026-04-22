# Move Tutorial: Governance Ledger

Move is a resource-oriented programming language designed for safe asset management. In LAGOS, Move manages the "Resource Ledger"—tracking governance tokens and administrative permissions across domains.

## Roles in LAGOS
1.  **Asset Management**: Representing domain permissions and bandwidth quotas as unique resources.
2.  **Safety**: Preventing accidental duplication or loss of governance rights through linear logic.
3.  **Auditability**: Providing a clear, cryptographic record of all governance actions.

## Tutorial: Defining a Governance Token

In this tutorial, we will define a simple governance token resource that can only be created by the domain administrator.

### `tutorial.move`
```move
module 0x1::LagosGovernance {
    use std::signer;

    /// Represent a governance right as a resource
    struct GovernanceToken has key, store {
        domain_id: u64,
        voting_power: u64,
    }

    /// Issue a new token to a specific account
    public fun issue_token(admin: &signer, recipient: address, domain_id: u64, power: u64) {
        // In a real scenario, we would check if 'admin' is the authorized issuer
        let token = GovernanceToken { domain_id, voting_power: power };
        move_to<GovernanceToken>(admin, token);
    }
}
```

## Running the Tutorial

Move code typically runs within a blockchain environment like Sui or Aptos. To check the syntax locally:

```bash
sui move build
```

## Key Concepts
- **Resources**: Values that cannot be copied or dropped, only moved.
- **Linear Logic**: Ensures that assets (like voting rights) are never created out of thin air or lost.
- **Module Safety**: Strict visibility rules for functions and data.
