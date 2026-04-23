# LAGOS Core: Pony Routing Hub

This directory contains the high-performance routing core of the LAGOS research framework, implemented in **Pony**.

## Role in LAGOS
Pony is utilized for the **Core Routing Hub** due to its reference capabilities and data-race freedom, which are essential for low-latency, internet-scale overlay networks.

## Features
- **Kademlia-inspired Routing**: Implements XOR-based distance metrics for efficient node discovery and message propagation.
- **Loop-Secure Gossip**: A hardened gossip protocol that prevents infinite broadcast loops via residency checks and history tracking.
- **Actor-based Concurrency**: Each network node is represented as an autonomous actor, ensuring high throughput and isolation.

## Getting Started
To compile the Pony routing logic:
```bash
ponyc .
./pony
```

## Structure
- `node.pony`: Core actor representing a network node with gossip and routing logic.
- `main.pony`: Test harness for simulating local overlays.
