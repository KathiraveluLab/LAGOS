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
