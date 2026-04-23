# LAGOS End-to-End User Guide

This guide describes the unified workflow of the **Latency-aware Accountable Governance for Overlay Scaling (LAGOS)** framework. LAGOS uses a polyglot architecture to decompose decentralized networking into five distinct phases.

## 1. End-To-End Workflow

The following sequence describes how a single network governance event (e.g., a domain join or a resource reallocation) is handled across the polyglot stack:

### Phase 1: Ingress & Orchestration (Gleam)
**Goal**: Fault-tolerant management of federated network signals.
- **Action**: A network signal is received via NATS. Gleam (on the BEAM VM) validates the signal and performs initial DDoS mitigation (rate-limiting).
- **Usage**: `cd core/gleam && gleam run`

### Phase 2: High-Performance Routing (Pony)
**Goal**: Race-free routing with minimal tail-latency.
- **Action**: The orchestration layer triggers the Pony Actor Hub. Pony uses its Kademlia-style XOR metric to select the optimal next-hop for the data, ensuring extreme performance through its capability-secure actor model.
- **Usage**: `cd core/pony && ponyc . && ./pony`

### Phase 3: Real-Time Optimization (Roc & Unison)
**Goal**: Dynamic bottleneck identification and logic deployment.
- **Action**: **Roc** performs near-real-time traffic analysis to identify latency spikes. If a bottleneck is found, **Unison** deploys a new content-addressed function primitive to the affected nodes to optimize the path.
- **Usage**: `cd logic/roc && roc run benchmark.roc`

### Phase 4: Governance Enforcement (Move & Clarity)
**Goal**: Decidable policy enforcement and resource safety.
- **Action**: The routing change is submitted to the governance layer. **Move** ensures that network resources (e.g., bandwidth credits) are safely "transferred" without duplication, while **Clarity** verifies the change against a non-Turing complete (decidable) policy set.
- **Usage**: `cd contracts/move && sui move build`

### Phase 5: Auditing & Accountability (Noir, Cairo, & Lurk)
**Goal**: Private, verifiable proof of correct execution.
- **Action**: Finally, **Noir** and **Cairo** generate a STARK-provable proof of the authorized transition. **Lurk** performs a recursive audit to verify that the entire chain of governance across different administrative domains remains compliant with global laws.
- **Usage**: `cd proofs/noir && nargo check && nargo prove`

---

## 2. Component Command Reference

| Subsystem | Language | CLI Tool | Primary Command |
| :--- | :--- | :--- | :--- |
| **Orchestration** | Gleam | `gleam` | `gleam run` |
| **Routing Core** | Pony | `ponyc` | `ponyc . && ./pony` |
| **Governance** | Move | `sui move` | `sui move build` |
| **Policy** | Clarity | `clarinet` | `clarinet check` |
| **ZK-Audit** | Noir | `nargo` | `nargo check` |
| **Arithmetic Proofs** | Cairo | `scarb` | `scarb build` |
| **Optimization** | Roc | `roc` | `roc run <file>` |
| **Functions** | Unison | `ucm` | `ucm` |

## 3. Troubleshooting
- **Lurk Build**: If `lurk` fails to build from source on your host, use the Docker-based stabilization method provided in the [README](README.md).
- **Infinite Loops**: The Pony routing logic has been hardened with a gossip history check to prevent broadcast storms.
- **Environment**: Always ensure you have run `source ~/.bashrc` after a fresh installation to synchronize the language toolchains.

