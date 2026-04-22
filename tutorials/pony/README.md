# Pony Tutorial: Core Routing

Pony is used in LAGOS for the high-performance routing hub. Its unique actor model ensures data-race freedom without needing locks, making it ideal for low-latency packet routing.

## Roles in LAGOS
1.  **High-Speed Routing**: Passing messages between overlay nodes at wire speed.
2.  **Tail-Latency Monitoring**: Using actors to asynchronously track and report network performance.
3.  **Gossip Discovery**: Efficiently propagating network topology updates.

## Tutorial: Simple Actor Messaging

In this tutorial, we will create an `OverlayNode` actor that receives and acknowledges "packets".

### `tutorial.pony`
```pony
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
```

## Running the Tutorial

To run this tutorial, ensure you have `ponyc` installed and run:

```bash
ponyc
./pony
```

## Key Concepts
- **Actors**: Autonomous entities that communicate via asynchronous messages.
- **Reference Capabilities**: Pony's "secret sauce" for safe, lock-free concurrency.
- **Wait-Free Execution**: Actors never block, ensuring minimal tail-latency.
