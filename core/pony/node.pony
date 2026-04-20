use "collections"

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
    """
    try
      _neighbors(target_id)?.receive_p2p(_id, data)
    else
      _env.out.print("Target " + target_id + " not in direct neighborhood, broadcasting to peers.")
      for neighbor in _neighbors.values() do
        neighbor.receive_p2p(_id, data)
      end
    end

  be receive_p2p(sender_id: String, data: String) =>
    _env.out.print("Received P2P packet from " + sender_id + " at " + _id)

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
