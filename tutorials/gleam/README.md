# Gleam Tutorial Series: LAGOS Orchestration

Gleam is the primary orchestration language for the LAGOS framework. Running on the BEAM virtual machine, it provides the fault-tolerant, concurrent foundation required for managing global-scale distributed overlay networks.

This series of tutorials will take you from the basics of Gleam to implementing core components of the LAGOS research framework.

## Curriculum

### 1. [Gleam Basics & OTP](./01_basics.gleam)
Learn the syntax of Gleam and its unique role as a type-safe language for the BEAM. We'll explore how messaging and processes form the backbone of LAGOS.

### 2. [Federation Orchestration](./02_orchestration.gleam)
Dive into domain management. This tutorial demonstrates how Gleam handles the lifecycle of federated nodes, including joining, leaving, and monitoring domain health.

### 3. [Advanced DDoS Mitigation](./03_ddos_mitigation.gleam)
Implement a core LAGOS research pillar. We'll build a high-performance sliding window rate limiter that leverages Gleam's functional purity for predictable security logic.

### 4. [Cross-Stack Integration](./04_stack_integration.gleam)
See how Gleam acts as the multi-language coordination layer. This tutorial shows how Gleam "glues" the stack together, interacting with routing hubs (Pony) and governance ledgers (Move).

---

## How to Run the Tutorials

Each tutorial can be run individually using the Gleam CLI. Ensure you are in the `tutorials/gleam` directory or have the project root correctly configured.

```bash
gleam run -m 01_basics
gleam run -m 02_orchestration
gleam run -m 03_ddos_mitigation
gleam run -m 04_stack_integration
```

## Prerequisite Knowledge
- Basic understanding of functional programming.
- Familiarity with the Actor Model (helpful but not required).

Ready to start? Begin with [01_Basics](./01_basics.gleam).
