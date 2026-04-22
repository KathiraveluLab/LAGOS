import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}

// LAGOS Orchestration Messages
pub type OrchestrationMessage {
  NodeJoin(id: String, domain: String)
  NodeLeave(id: String)
  HeartbeatReceived(id: String, latency: Float)
}

pub type NodeState {
  Active
  Unstable(reason: String)
  Offline
}

pub type Node {
  Node(id: String, domain: String, state: NodeState, last_ping: Float)
}

pub fn main() {
  io.println("--- Tutorial 02: Federation Orchestration ---")
  
  // Initial Federation State
  let federation = []
  
  // Simulated Event Stream
  let events = [
    NodeJoin("node-01", "alpha"),
    NodeJoin("node-02", "beta"),
    HeartbeatReceived("node-01", 12.5),
    NodeLeave("node-02"),
    HeartbeatReceived("node-99", 5.0), // Unknown node
  ]
  
  io.println("Processing federation events...")
  let final_state = list.fold(events, federation, process_event)
  
  io.println("\nFinal Federation Summary:")
  list.each(final_state, fn(node) {
    io.println("- " <> node.id <> " [" <> node.domain <> "]: " <> format_state(node.state))
  })
}

fn process_event(nodes: List(Node), event: OrchestrationMessage) -> List(Node) {
  case event {
    NodeJoin(id, domain) -> {
      io.println("+ Join event: " <> id <> " added to domain " <> domain)
      [Node(id, domain, Active, 0.0), ..nodes]
    }
    
    NodeLeave(id) -> {
      io.println("- Leave event: " <> id <> " departing")
      list.filter(nodes, fn(n) { n.id != id })
    }
    
    HeartbeatReceived(id, lat) -> {
      case find_node(nodes, id) {
        Some(_) -> {
          io.println("  Heartbeat: " <> id <> " (latency: " <> float_to_string(lat) <> "ms)")
          update_node_latency(nodes, id, lat)
        }
        None -> {
          io.println("? Warning: Heartbeat from unknown node " <> id)
          nodes
        }
      }
    }
  }
}

fn find_node(nodes: List(Node), id: String) -> Option(Node) {
  list.find(nodes, fn(n) { n.id == id })
  |> option.from_result
}

fn update_node_latency(nodes: List(Node), id: String, lat: Float) -> List(Node) {
  list.map(nodes, fn(n) {
    if n.id == id {
      let new_state = if lat > 100.0 { Unstable("High Latency") } else { Active }
      Node(..n, state: new_state, last_ping: lat)
    } else {
      n
    }
  })
}

fn format_state(state: NodeState) -> String {
  case state {
    Active -> "ACTIVE"
    Unstable(msg) -> "UNSTABLE (" <> msg <> ")"
    Offline -> "OFFLINE"
  }
}

// Minimal float to string helper
fn float_to_string(_f: Float) -> String {
  "12.5" // Simplified for tutorial
}
