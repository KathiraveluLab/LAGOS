// LAGOS Node Validation Circuit (Noir)
// ZK-Accountability proof logic

fn main(node_id : Field, min_id : Field, max_id : Field) {
    // Verify that the node_id is within the governed range
    // without revealing the node_id in the public proof.
    assert(node_id as u64 >= min_id as u64);
    assert(node_id as u64 <= max_id as u64);
}

#[test]
fn test_valid_node() {
    main(100, 50, 150);
}

// Verifies that a DDoS countermeasure reduced traffic by at least X%
// without revealing the raw request counts.
fn verify_mitigation(pre_count: u64, post_count: u64, reduction_threshold: u64) {
    let reduction = (pre_count - post_count) * 100 / pre_count;
    assert(reduction >= reduction_threshold);
}
