import gleam/io
import gleam/list
import gleam/dynamic.{type Dynamic}
import gleam/erlang/process
import gleam/otp/static_supervisor as sup


pub type FederationMessage {
  JoinDomain(domain_id: String)
  LeaveDomain(domain_id: String)
}

@external(erlang, "os", "system_time")
fn erl_now() -> Int

pub fn main() {
  io.println("Starting LAGOS Federation Supervisor...")
  
  // Attempt to connect to the local NATS messaging plane
  // This will fail unless a NATS server is running on 4222
  let _ = connect_nats("127.0.0.1")

  let assert Ok(_) =
    sup.new(sup.OneForOne)
    |> sup.start
    
  process.sleep_forever()
}


pub fn handle_federation_event(msg: FederationMessage) {
  case msg {
    JoinDomain(id) -> io.println("Domain joined: " <> id)
    LeaveDomain(id) -> io.println("Domain left: " <> id)
  }
}

pub fn handle_flood_event(request_count: Int, threshold: Int) {
  case request_count > threshold {
    True -> {
      io.println("ALERT: DDoS Flood detected!")
      True
    }
    False -> False
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
  let now = erl_now()
  let pruned_history = prune_history(history, now, window_size)

  case list.length(pruned_history) > limit {
    True -> {
      io.println("Rate limit exceeded for domain: " <> domain_id)
      Error("Rate limit exceeded")
    }
    False -> Ok(list.append(pruned_history, [now]))
  }
}




fn prune_history(history: List(Int), now: Int, window_size: Int) {
  history
  |> list.filter(fn(ts) { ts > now - window_size })
}

pub type NatsConn

@external(erlang, "lagos_nats", "connect")
pub fn nats_connect(host: String, port: Int) -> Result(NatsConn, Dynamic)

@external(erlang, "lagos_nats", "pub")
pub fn nats_pub(conn: NatsConn, subject: String, payload: BitArray) -> Result(Nil, Dynamic)

// Federation Signaling via NATS
pub fn connect_nats(addr: String) {
  io.println("Connecting to NATS federation broker at " <> addr)
  case nats_connect(addr, 4222) {
    Ok(conn) -> {
      io.println("Successfully connected to NATS messaging plane.")
      Ok(conn)
    }
    Error(err) -> {
      io.println("Failed to connect to NATS.")
      Error(err)
    }
  }
}

pub fn publish_federation_event(conn: NatsConn, domain_id: String, event_type: String) {
  let subject = "lagos.federation." <> domain_id
  let payload = <<event_type:utf8>>
  case nats_pub(conn, subject, payload) {
    Ok(Nil) -> io.println("Published " <> event_type <> " to " <> subject)
    Error(_) -> io.println("Failed to publish event to NATS")
  }
}

pub fn on_nats_message(topic: String, _payload: BitArray) {
  io.println("Received federation signal on topic: " <> topic)
  // 1. Decode Protobuf OverlayEvent from payload
  // 2. Dispatch to internal Gleam state machine
  // 3. Trigger domain-level security or orchestration events
}


