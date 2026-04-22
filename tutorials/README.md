# LAGOS Polyglot Tutorials

Welcome to the LAGOS tutorials repository! This directory contains hands-on examples for the nine specialized programming languages that power the LAGOS research framework.

## Why Nine Languages?

LAGOS adopts a "best-tool-for-the-job" philosophy to address complex networking and governance challenges:
- **Safety & Performance**: Pony (Core Routing), Roc (Optimization).
- **Scale & Federation**: Gleam (Orchestration on BEAM), Unison (Deployment).
- **Cryptographic Governance**: Move (Ledger), Clarity (Policy), Noir (ZK), Cairo (Arithmetic), Lurk (Verification).

## Tutorial Structure

Each tutorial is designed to demonstrate a specific "LAGOS Use Case":

| Language | Tutorial Role | Use Case |
| :--- | :--- | :--- |
| [Gleam](./gleam/) | **Major Tutorial** | Federation Orchestration & DDoS Mitigation |
| [Pony](./pony/) | Core Routing | Tail-Latency Minimization & P2P Gossip |
| [Move](./move/) | Asset Ledger | Governance Token Management |
| [Clarity](./clarity/) | Policy Contract | Domain-Level Access Control |
| [Noir](./noir/) | ZK-Circuits | Anonymous Domain Membership Proofs |
| [Cairo](./cairo/) | Arithmetic Proofs | Provable Network Metrics |
| [Lurk](./lurk/) | Recursive Audit | Multi-step Policy Verification |
| [Roc](./roc/) | High-perf Logic | Real-time Latency Benchmarking |
| [Unison](./unison/) | Code Deployment | Content-addressed Topology Updates |

## Getting Started

1.  **Environment Setup**: Ensure you have the toolchains installed (see the main [README.md](../README.md)).
2.  **Explore**: Start with the [Gleam Tutorial](./gleam/) to understand how the system orchestrates federated nodes.
3.  **Cross-Language testing**: Follow the instructions in each `README.md` to run the sample code.
