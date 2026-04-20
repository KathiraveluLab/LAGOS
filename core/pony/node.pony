use "collections"

actor OverlayNode
  let _env: Env
  let _id: String
  let _neighbors: Map[String, OverlayNode tag] = _neighbors.create()

  new create(env: Env, id: String) =>
    _env = env
    _id = id
    _env.out.print("LAGOS Overlay Node " + _id + " initialized.")

  be add_neighbor(id: String, neighbor: OverlayNode tag) =>
    _neighbors(id) = neighbor
    _env.out.print("Neighbor " + id + " added to " + _id)

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
