module lagos::governance {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    struct NodeIdentity has key, store {
        id: UID,
        node_id: vector<u8>,
        owner: address,
        reputation: u64,
    }

    struct Registry has key {
        id: UID,
        node_count: u64,
    }

    struct TransactionLedger has key {
        id: UID,
        transactions: u64,
    }

    fun init(ctx: &mut TxContext) {
        let registry = Registry {
            id: object::new(ctx),
            node_count: 0,
        };
        let ledger = TransactionLedger {
            id: object::new(ctx),
            transactions: 0,
        };
        transfer::share_object(registry);
        transfer::share_object(ledger);
    }

    public entry fun log_transaction(
        ledger: &mut TransactionLedger,
        _ctx: &mut TxContext
    ) {
        ledger.transactions = ledger.transactions + 1;
    }

    public entry fun register_node(
        registry: &mut Registry,
        node_id: vector<u8>,
        ctx: &mut TxContext
    ) {
        let node = NodeIdentity {
            id: object::new(ctx),
            node_id,
            owner: tx_context::sender(ctx),
            reputation: 100,
        };
        registry.node_count = registry.node_count + 1;
        transfer::transfer(node, tx_context::sender(ctx));
    }
}
