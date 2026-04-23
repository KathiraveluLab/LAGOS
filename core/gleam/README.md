# LAGOS Core: Gleam Federation Orchestration

This directory contains the distributed orchestration layer of the LAGOS framework, implemented in **Gleam**.

## Role in LAGOS
Gleam handles the **Federated SDN Orchestration** and **Cross-Domain Signaling**. Running on the Erlang/BEAM VM, it provides the fault tolerance and scalability required for multi-domain governance.

## Features
- **Sliding-Window Rate Limiting**: Advanced DDoS mitigation logic to protect domains from flood events at the orchestration level.
- **NATS Messaging Plane**: Integrated signaling via a lightweight NATS FFI (`lagos_nats.erl`) for low-latency cross-domain communication.
- **OTP Supervision**: Adopts standard OTP patterns for high availability and resilient service management.

## Getting Started
To compile the federation logic:
```bash
gleam build
```

To run tests:
```bash
gleam test
```

## Structure
- `src/federation.gleam`: Primary orchestration logic and rate limiting.
- `src/lagos_nats.erl`: Lightweight NATS transport layer for OTP 25 compatibility.
- `test/lagos_integration_test.gleam`: Integration scenarios for domain joining and traffic filtering.
