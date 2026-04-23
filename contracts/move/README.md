# LAGOS Governance: Move Resource Ledger

This directory contains the resource-oriented governance logic for LAGOS, implemented in **Move**.

## Role in LAGOS
Move is used to manage the **Overlay Resource Ledger**. Its unique resource-oriented paradigm ensures that network assets (e.g., bandwidth quotas, domain membership tokens) cannot be duplicated or accidentally dropped, providing strict accountability.

## Features
- **Strict Resource Safety**: Prevents double-spending of overlay resources at the bytecode level.
- **Access Control**: Robust permissioning system for domain administrators.
- **Formal Verification Support**: Designed for the Move Prover to ensure mathematical correctness of governance rules.

## Getting Started
To interact with the Move contracts, use the Sui CLI:
```bash
sui move build
```

## Structure
- `sources/Governance.move`: Primary resource management logic.
- `Move.toml`: Project configuration and dependencies.
