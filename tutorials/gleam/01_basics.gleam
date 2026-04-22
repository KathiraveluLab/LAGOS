import gleam/io
import gleam/int
import gleam/list

// LAGOS Domain Types
pub type DomainType {
  Core
  Edge
  Federated
}

pub type DomainInfo {
  DomainInfo(id: String, kind: DomainType, node_count: Int)
}

pub fn main() {
  io.println("--- Tutorial 01: Gleam Basics in LAGOS ---")
  
  // 1. Immutable Data
  let domains = [
    DomainInfo("domain-alpha", Core, 5),
    DomainInfo("domain-beta", Edge, 12),
    DomainInfo("domain-gamma", Federated, 3),
  ]
  
  io.println("Registered Domains:")
  list.each(domains, print_domain)
  
  // 2. Functional Transformation
  let total_nodes = 
    domains
    |> list.map(fn(d) { d.node_count })
    |> int.sum
    
  io.println("Total overlay nodes monitored: " <> int.to_string(total_nodes))
  
  // 3. Error Handling (Result Type)
  check_domain_capacity(15)
  |> handle_capacity_check
}

fn print_domain(domain: DomainInfo) {
  let kind_str = case domain.kind {
    Core -> "Core"
    Edge -> "Edge"
    Federated -> "Federated"
  }
  io.println("- " <> domain.id <> " (" <> kind_str <> "): " <> int.to_string(domain.node_count) <> " nodes")
}

fn check_domain_capacity(count: Int) -> Result(String, String) {
  if count > 10 {
    Error("Capacity exceeded! Max 10 nodes for Edge domains.")
  } else {
    Ok("Capacity within limits.")
  }
}

fn handle_capacity_check(res: Result(String, String)) {
  case res {
    Ok(msg) -> io.println("OK: " <> msg)
    Error(err) -> io.println("ERROR: " <> err)
  }
}
