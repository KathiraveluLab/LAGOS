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
    node1.route_p2p("node3", "PMU_synchrophasor:{\"substation_id\":\"pmu_sub12\",\"freq_hz\":60.02,\"phase_deg\":14.2,\"timestamp\":1700000001}")
    node1.route_p2p("node3", "C_ITS_telemetry:{\"vehicle_id\":\"v_alpha\",\"speed_kmh\":64.5,\"lane\":2,\"timestamp\":1700000002}")
    node1.route_p2p("node3", "DigitalTwin_telemetry:{\"machine_id\":\"cnc_cell04\",\"vibration_g\":0.042,\"temp_c\":48.1,\"timestamp\":1700000003}")
    node1.route_p2p("node3", "HFT_order_telemetry:{\"order_id\":\"ord_8891\",\"pair\":\"ETH-USDC\",\"qty\":45.0,\"max_slippage\":0.001,\"timestamp\":1700000004}")
    node1.route_p2p("node3", "Gaming_state_telemetry:{\"match_id\":\"m_arena_7\",\"tick\":1420,\"player_pos\":[104.2,45.8,12.0],\"anti_cheat_hash\":\"0xfa7291\",\"timestamp\":1700000005}")
