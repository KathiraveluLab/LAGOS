# LAGOS Cryptographic Proofs

This directory contains the zero-knowledge and arithmetic proof circuits that provide accountable governance for LAGOS.

## Proof Systems
- **[Noir](./noir/)**: ZK-SNARK DSL for privacy-preserving domain membership and audit proofs.
- **[Cairo](./cairo/)**: STARK-provable programs for complex network arithmetic and metric verification.
- **[Lurk](./lurk/)**: Recursive SNARKs (IVC) for provable evaluation of deep historical state transitions.

## Verification Workflow
Participants generate proofs using these toolchains, which are then verified by the orchestration layer to ensure compliance without revealing private traffic data.
