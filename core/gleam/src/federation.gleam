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
