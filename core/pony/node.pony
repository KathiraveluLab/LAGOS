use "collections"

use @calculate99thPercentileC[F64](latencies: Pointer[F64] tag, len: USize)

actor OverlayNode
  let _env: Env
  let _id: String
  let _neighbors: Map[String, OverlayNode tag] = _neighbors.create()
  var _tail_latency: F64 = 0.0

  new create(env: Env, id: String) =>
    _env = env
    _id = id
    _env.out.print("LAGOS Overlay Node " + _id + " initialized.")

  be update_tail_latency(latency: F64) =>
    _tail_latency = latency
    if _tail_latency > 1.0 then
      _env.out.print("WARNING: High tail latency detected at " + _id + ": " + _tail_latency.string())
    end

  be route_p2p(target_id: String, data: String) =>
    """
    Route data through the peer-to-peer overlay to optimize last-mile latency.
    Uses Kademlia XOR metric for neighbor selection.
    """
    let target_hash = _hash(target_id)
    var closest_neighbor: (OverlayNode tag | None) = None
    var min_distance: U64 = 0xFFFFFFFFFFFFFFFF

    for (id, neighbor) in _neighbors.pairs() do
      let distance = _xor_distance(_hash(id), target_hash)
      if (closest_neighbor is None) or (distance < min_distance) then
        closest_neighbor = neighbor
        min_distance = distance
      end
    end

    match closest_neighbor
    | let n: OverlayNode tag => n.receive_p2p(_id, data)
    | None => _env.out.print("No neighbors found for P2P routing.")
    end

  be receive_p2p(sender_id: String, data: String) =>
    _env.out.print("Received P2P packet from " + sender_id + " at " + _id)

  be gossip(known_nodes: Array[String] val) =>
    """
    Gossip protocol for node discovery in the last mile.
    """
    _env.out.print(_id + " gossiping with neighbors about " + known_nodes.size().string() + " nodes.")
    for neighbor in _neighbors.values() do
      neighbor.receive_gossip(_id, known_nodes)
    end

  be receive_gossip(sender_id: String, nodes: Array[String] val) =>
    _env.out.print(_id + " received gossip from " + sender_id)

  fun _hash(s: String): U64 =>
    var h: U64 = 0
    for c in s.values() do
      h = (h * 31) + c.u64()
    end
    h

  fun _xor_distance(a: U64, b: U64): U64 =>
    a xor b

  be publish_heartbeat() =>
    """
    Publish node status to the NATS federation signaling topic.
    """
    _env.out.print("Publishing heartbeat for " + _id + " to NATS lagos.federation.heartbeat")
    // Logic to serialize Protobuf OverlayEvent and publish via NATS client

  be ping(sender_id: String) =>
    """
    Handle a latency probe from a neighbor.
    """
    _env.out.print("Received ping from " + sender_id + " at " + _id)
    try
      _neighbors(sender_id)?.pong(_id)
    end

  be pong(responder_id: String) =>
    """
    Handle a latency response.
    """
    _env.out.print("Received pong from " + responder_id + " at " + _id)
