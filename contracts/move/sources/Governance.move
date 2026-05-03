module lagos::governance {
    use sui::table::{Self, Table};

    public struct NodeIdentity has key, store {
        id: UID,
        node_id: vector<u8>,
        owner: address,
        reputation: u64,
        zk_proof_hash: vector<u8>, // Cryptographic link to Noir proofs
    }

    public struct Registry has key {
        id: UID,
        node_count: u64,
    }


    public struct TransactionLedger has key {
        id: UID,
        history: Table<vector<u8>, Accountability>,
    }

    public struct Accountability has store {
        zk_proof_hash: vector<u8>,
        timestamp: u64,
        action: vector<u8>,
    }

    fun init(ctx: &mut TxContext) {
        let registry = Registry {
            id: object::new(ctx),
            node_count: 0,
        };
        let ledger = TransactionLedger {
            id: object::new(ctx),
            history: table::new(ctx),
        };
        transfer::share_object(registry);
        transfer::share_object(ledger);
    }

    public fun record_accountability(
        ledger: &mut TransactionLedger,
        zk_proof_hash: vector<u8>,
        action: vector<u8>,
        ctx: &mut TxContext
    ) {
        let record = Accountability {
            zk_proof_hash,
            timestamp: tx_context::epoch(ctx),
            action,
        };
        table::add(&mut ledger.history, zk_proof_hash, record);
    }

    public fun register_node(
        registry: &mut Registry,
        node_id: vector<u8>,
        zk_proof_hash: vector<u8>,
        ctx: &mut TxContext
    ): NodeIdentity {
        let node = NodeIdentity {
            id: object::new(ctx),
            node_id,
            owner: tx_context::sender(ctx),
            reputation: 100,
            zk_proof_hash,
        };
        registry.node_count = registry.node_count + 1;
        node
    }

    // --- Public Accessors ---

    public fun node_count(registry: &Registry): u64 {
        registry.node_count
    }

    public fun node_reputation(node: &NodeIdentity): u64 {
        node.reputation
    }

    public fun node_owner(node: &NodeIdentity): address {
        node.owner
    }

    public fun ledger_contains(ledger: &TransactionLedger, zk_proof_hash: vector<u8>): bool {
        table::contains(&ledger.history, zk_proof_hash)
    }

    // --- Test Helpers ---

    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(ctx)
    }
}
