actor Main
  new create(env: Env) =>
    let node1 = OverlayNode(env, "node1")
    let node2 = OverlayNode(env, "node2")
    let node3 = OverlayNode(env, "node3")

    node1.add_neighbor("node2", node2)
    node1.add_neighbor("node3", node3)
    node2.add_neighbor("node1", node1)
    node3.add_neighbor("node1", node1)

    node1.gossip(recover val ["node1"; "node2"; "node3"] end)
    node1.route_p2p("node3", "ECG_telemetry:{\"patient_id\":\"p984\",\"bpm\":72,\"ecg_mv\":[0.15,0.22,0.18],\"timestamp\":1700000000}")
