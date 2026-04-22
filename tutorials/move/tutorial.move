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
