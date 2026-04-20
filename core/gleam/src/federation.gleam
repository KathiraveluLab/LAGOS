import gleam/io
import gleam/erlang/process
import gleam/otp/supervisor

pub type FederationMessage {
  JoinDomain(domain_id: String)
  LeaveDomain(domain_id: String)
}

pub fn main() {
  io.println("Starting LAGOS Federation Supervisor...")
  
  let children = []
  
  let assert Ok(_) =
    supervisor.start_spec(
      supervisor.Spec(
        argument: Nil,
        max_frequency: 5,
        max_seconds: 1,
        init: fn(_) { supervisor.Ok(children) },
      ),
    )
    
  process.sleep_forever()
}

pub fn handle_federation_event(msg: FederationMessage) {
  case msg {
    JoinDomain(id) -> io.println("Domain joined: " <> id)
    LeaveDomain(id) -> io.println("Domain left: " <> id)
  }
}

pub fn handle_flood_event(request_count: Int, threshold: Int) {
  if request_count > threshold {
    io.println("ALERT: DDoS Flood detected!")
    True
  } else {
    False
  }
}

// Sliding Window Rate Limiter
pub fn check_rate_limit(
  domain_id: String,
  history: List(Int),
  window_size: Int,
  limit: Int,
) {
  // Use Erlang interop for real-world timestamps
  let now = os.system_time(os.Millisecond)
  let pruned_history = prune_history(history, now, window_size)

  if list.length(pruned_history) > limit {
    io.println("Rate limit exceeded for domain: " <> domain_id)
    Error("Rate limit exceeded")
  } else {
    Ok(list.append(pruned_history, [now]))
  }
}

fn prune_history(history: List(Int), now: Int, window_size: Int) {
  history
  |> list.filter(fn(ts) { ts > now - window_size })
}

// Federation Signaling via NATS
pub fn connect_nats(addr: String) {
  io.println("Connecting to NATS federation broker at " <> addr)
  # Subscription logic for "lagos.federation.>"
  # In a production environment, this would spawn a NATS client process
  # and subscribe to the federated signaling topic.
}

pub fn on_nats_message(topic: String, _payload: BitArray) {
  io.println("Received federation signal on topic: " <> topic)
  # 1. Decode Protobuf OverlayEvent from payload
  # 2. Dispatch to internal Gleam state machine
  # 3. Trigger domain-level security or orchestration events
}
