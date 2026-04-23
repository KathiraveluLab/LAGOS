# LAGOS Governance: Clarity Decidable Policy

This directory contains the decidable security and governance policies for LAGOS, implemented in **Clarity**.

## Role in LAGOS
Clarity is used for **Security Policy Enforcement**. Because Clarity is a non-Turing complete (decidable) language, it allows the LAGOS framework to predict the outcome and gas consumption of any policy evaluation before execution, eliminating "out-of-gas" vulnerabilities in critical governance paths.

## Features
- **Predictable Outcomes**: Every policy evaluation is guaranteed to terminate and its complexity is known ahead of time.
- **No Compiler Re-entry**: Eliminates re-entrancy attacks common in other smart contract environments.
- **Human-Readable Lisp Syntax**: Facilitates easier auditing of complex security rules.

## Getting Started
To test the Clarity contracts, use Clarinet:
```bash
clarinet test
```

## Structure
- `contracts/policy.clarity`: Core governance and security policy rules.
- `Clarinet.toml`: Project configuration.
