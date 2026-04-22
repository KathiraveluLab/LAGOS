actor OverlayNode
  let _id: String
  let _out: StdStream

  new create(id: String, out: StdStream) =>
    _id = id
    _out = out
    _out.print("Node " + _id + " is online.")

  be receive_packet(sender_id: String, data: String) =>
    _out.print("Node " + _id + " received packet from " + sender_id + ": " + data)

actor Main
  new create(env: Env) =>
    let node_a = OverlayNode("A", env.out)
    let node_b = OverlayNode("B", env.out)

    node_a.receive_packet("B", "Hello from B!")
    node_b.receive_packet("A", "Hello from A!")
