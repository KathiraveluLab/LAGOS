# LAGOS Functions: Unison Distributed Primitives

This directory contains the distributed logic primitives for the LAGOS framework, implemented in **Unison**.

## Role in LAGOS
Unison is utilized for **Content-Addressed Function Management**. In a decentralized overlay, traditional versioning is replaced by content-addressing, ensuring that every node executes the exact same bytecode for a given function hash.

## Features
- **Content-Addressed Logic**: Functions are identified by their structural hash, eliminating dependency conflicts and "dependency hell."
- **Seamless Remote Execution**: Unison allows for "shipping code to data," which is essential for low-latency optimization at the network edge.
- **Typed Distributed Communication**: Strong type safety across the network boundary, ensuring that remote function calls are always protocol-compliant.

## Getting Started
To interact with the Unison primitives, use the Unison Codebase Manager (UCM):
```bash
ucm
```

## Structure
- `src/`: Unison source files (managed via UCM).
- `base.u`: Base types for federation communication.
- `orchestration.u`: Distributed orchestration primitives.
