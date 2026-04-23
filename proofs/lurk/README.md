# LAGOS Proofs: Lurk Recursive Audit

This directory contains the recursive verification logic for LAGOS, implemented in **Lurk**.

## Role in LAGOS
Lurk is the **Recursive Verification Engine**. It enables the evaluation of governance rules over historical data using Recursive SNARKs (IVC), allowing LAGOS to prove the correct state transition of the entire network over time without re-verifying every individual step.

## Features
- **Recursive Verification**: Prove long chains of execution with a single succinct proof.
- **Lisp-based Language**: Express complex functional logic in a ZK-friendly way.
- **Succinct State Transitions**: Ideal for historical auditing and checkpointing in the overlay network.

## Getting Started
To run Lurk programs:
```bash
lurk --help
```

## Structure
- `src/verify.lurk`: Recursive verification logic.
- `src/lib.lurk`: Helper functions for SNARK evaluation.
