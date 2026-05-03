#[test_only]
module lagos::governance_test {
    use sui::test_scenario;
    use lagos::governance;

    const ADMIN: address = @0xCAFE;
    const NODE_OPERATOR: address = @0xBEEF;

    #[test]
    /// Test that init creates a shared Registry and TransactionLedger.
    fun test_init_creates_shared_objects() {
        let mut scenario = test_scenario::begin(ADMIN);

        // init is called automatically on publish, but we simulate it
        {
            governance::init_for_testing(test_scenario::ctx(&mut scenario));
        };

        // Verify the Registry was shared
        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let registry = test_scenario::take_shared<governance::Registry>(&scenario);
            assert!(governance::node_count(&registry) == 0, 0);
            test_scenario::return_shared(registry);
        };

        // Verify the TransactionLedger was shared
        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let ledger = test_scenario::take_shared<governance::TransactionLedger>(&scenario);
            test_scenario::return_shared(ledger);
        };

        test_scenario::end(scenario);
    }

    #[test]
    /// Test that register_node creates a NodeIdentity and increments the counter.
    fun test_register_node() {
        let mut scenario = test_scenario::begin(ADMIN);

        // Initialize shared objects
        {
            governance::init_for_testing(test_scenario::ctx(&mut scenario));
        };

        // Register a node as NODE_OPERATOR
        test_scenario::next_tx(&mut scenario, NODE_OPERATOR);
        {
            let mut registry = test_scenario::take_shared<governance::Registry>(&scenario);
            let node_id = b"node-alpha-001";
            let zk_hash = b"deadbeef01234567";

            let node = governance::register_node(
                &mut registry,
                node_id,
                zk_hash,
                test_scenario::ctx(&mut scenario),
            );

            assert!(governance::node_count(&registry) == 1, 1);
            assert!(governance::node_reputation(&node) == 100, 2);
            assert!(governance::node_owner(&node) == NODE_OPERATOR, 3);

            sui::transfer::public_transfer(node, NODE_OPERATOR);
            test_scenario::return_shared(registry);
        };

        test_scenario::end(scenario);
    }

    #[test]
    /// Test registering multiple nodes increments the counter correctly.
    fun test_register_multiple_nodes() {
        let mut scenario = test_scenario::begin(ADMIN);

        {
            governance::init_for_testing(test_scenario::ctx(&mut scenario));
        };

        // Register first node
        test_scenario::next_tx(&mut scenario, NODE_OPERATOR);
        {
            let mut registry = test_scenario::take_shared<governance::Registry>(&scenario);
            let node = governance::register_node(
                &mut registry,
                b"node-01",
                b"hash-01",
                test_scenario::ctx(&mut scenario),
            );
            assert!(governance::node_count(&registry) == 1, 0);
            sui::transfer::public_transfer(node, NODE_OPERATOR);
            test_scenario::return_shared(registry);
        };

        // Register second node
        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let mut registry = test_scenario::take_shared<governance::Registry>(&scenario);
            let node = governance::register_node(
                &mut registry,
                b"node-02",
                b"hash-02",
                test_scenario::ctx(&mut scenario),
            );
            assert!(governance::node_count(&registry) == 2, 1);
            sui::transfer::public_transfer(node, ADMIN);
            test_scenario::return_shared(registry);
        };

        test_scenario::end(scenario);
    }

    #[test]
    /// Test that record_accountability stores an entry in the ledger.
    fun test_record_accountability() {
        let mut scenario = test_scenario::begin(ADMIN);

        {
            governance::init_for_testing(test_scenario::ctx(&mut scenario));
        };

        // Record an accountability event
        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let mut ledger = test_scenario::take_shared<governance::TransactionLedger>(&scenario);
            let zk_hash = b"proof_hash_abc123";
            let action = b"domain_join";

            governance::record_accountability(
                &mut ledger,
                zk_hash,
                action,
                test_scenario::ctx(&mut scenario),
            );

            // Verify the record exists in the ledger
            assert!(governance::ledger_contains(&ledger, b"proof_hash_abc123"), 0);

            test_scenario::return_shared(ledger);
        };

        test_scenario::end(scenario);
    }
}
