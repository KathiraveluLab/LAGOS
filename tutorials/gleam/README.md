# Gleam Tutorial: Federation Orchestration

Gleam is the primary orchestration language for LAGOS. It runs on the BEAM virtual machine, providing massive concurrency and fault tolerance—ideal for managing global overlay networks.

## Roles in LAGOS
1.  **Domain Orchestration**: Managing the lifecycle of domains and participating nodes.
2.  **DDoS Mitigation**: Real-time detection of traffic floods through message passing.
3.  **Signaling**: Communicating across administrative domains via NATS/Protobuf.

## Tutorial: Detecting a Traffic Flood

In this tutorial, we will use Gleam's message passing to build a simple rate limiter that detects DDoS attacks.

### `tutorial.gleam`
```gleam
import gleam/io
import gleam/list

pub fn main() {
  io.println("--- LAGOS Gleam Tutorial ---")
  
  // Simulated request history (timestamps)
  let history = [100, 105, 110, 115, 120]
  let now = 125
  let window = 30
  let limit = 3

  io.println("Checking rate limit for Domain A...")
  case check_flood(history, now, window, limit) {
    True -> io.println("ALERT: DDoS Flood detected! Triggering circuit breaker.")
    False -> io.println("Traffic levels normal.")
  }
}

pub fn check_flood(history: List(Int), now: Int, window: Int, limit: Int) -> Bool {
  let active_requests = 
    history
    |> list.filter(fn(ts) { ts > now - window })
  
  list.length(active_requests) > limit
}
```

## Running the Tutorial

To run this tutorial, ensure you have Gleam installed and run:

```bash
gleam run -m tutorial
```

## Key Concepts
- **Functional Purity**: Logic is predictable and easy to test.
- **Pipelining (`|>`)**: Clean data flow for traffic analysis.
- **Fault Tolerance**: In a full LAGOS deployment, this logic would run in supervised processes that can recover instantly from failures.
