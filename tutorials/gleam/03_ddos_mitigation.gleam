import gleam/io
import gleam/list
import gleam/int

// LAGOS Pillar 4: Internet-scale DDoS Mitigation
// Using a Sliding Window Rate Limiter

pub type Trafficstats {
  Trafficstats(
    domain_id: String,
    window_size_ms: Int,
    max_requests: Int,
    history: List(Int), // List of timestamps in ms
  )
}

pub fn main() {
  io.println("--- Tutorial 03: Advanced DDoS Mitigation ---")
  
  let now = 5000 // Current simulation time
  
  let stats = Trafficstats(
    domain_id: "domain-primary",
    window_size_ms: 1000, // 1 second window
    max_requests: 5,
    history: [4100, 4250, 4400, 4800, 4900] // 5 requests in last 1s
  )
  
  io.println("Analyzing traffic for " <> stats.domain_id <> "...")
  io.println("New incoming request at t=" <> int.to_string(now))
  
  case record_and_check_flood(stats, now) {
    Ok(updated_stats) -> {
      io.println("PASS: Request allowed. Active window count: " <> 
        int.to_string(list.length(updated_stats.history)))
    }
    Error(msg) -> {
      io.println("ALERT: " <> msg)
      io.println("DDoS Mitigation Triggered: Blacklisting source IP in Routing Hub (Pony).")
    }
  }
}

pub fn record_and_check_flood(stats: Trafficstats, now: Int) -> Result(Trafficstats, String) {
  // 1. Prune history (remove timestamps outside the current window)
  let threshold = now - stats.window_size_ms
  let pruned_history = 
    stats.history
    |> list.filter(fn(ts) { ts >= threshold })
    
  // 2. Check if the window is already full
  if list.length(pruned_history) >= stats.max_requests {
    Error("DDoS Attack Detected! Rate limit of " <> 
      int.to_string(stats.max_requests) <> " requests/sec exceeded.")
  } else {
    // 3. Add current request and return updated stats
    let new_history = list.append(pruned_history, [now])
    Ok(Trafficstats(..stats, history: new_history))
  }
}

// Behavioral roles in the stack
pub fn trigger_governance_audit(domain_id: String) {
  io.println("Flagging " <> domain_id <> " for ZK-Audit (Noir).")
  // In LAGOS, this would emit a NATS message to the Proofs module
}
