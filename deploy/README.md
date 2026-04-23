# LAGOS Deployment: MultiPath TCP & Container Orchestration

This directory contains the deployment configurations and testbed setup for the LAGOS research framework.

## Role in LAGOS
The deployment layer focuses on **Tail-Latency Minimization** and **MPTCP Evaluation**. It provides the infrastructure to simulate wide-area overlay networks with redundant path capabilities.

## Components
- **MPTCP Testbed**: Docker Compose configurations to spin up nodes with MPTCP support enabled.
- **Network Simulation**: Scripts to induce synthetic latency and packet loss for benchmarking the Roc optimization engine.

## Getting Started
To launch the local MPTCP testbed:
```bash
cd mptcp
docker-compose up -d
```

## Structure
- `mptcp/docker-compose.yml`: Multi-node network topology with shared volumes for LAGOS binaries.
