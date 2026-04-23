# LAGOS Proofs: Noir ZK-Audit

This directory contains the Zero-Knowledge (ZK) audit circuits for LAGOS, implemented in **Noir**.

## Role in LAGOS
Noir is the DSL for our **ZK-Audit** pillar. It allows network participants to prove they have followed governance rules (e.g., they didn't exceed their bandwidth quota) without revealing their underlying private data or traffic patterns.

## Features
- **Privacy-Preserving Accountability**: Generate ZK-SNARKs for audit events.
- **Developer-Friendly DSL**: Rust-like syntax for complex cryptographic circuits.
- **Backend Independence**: Compiles to ACIR, allowing for flexible proof system backends (e.g., Barretenberg).

## Getting Started
To compile the Noir circuits, use Nargo:
```bash
nargo compile
```

To generate a proof:
```bash
nargo prove
```

## Structure
- `src/main.nr`: Primary ZK-Audit logic.
- `Nargo.toml`: Circuit configuration.
