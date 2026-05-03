# LAGOS Automated Setup Guide

The `setup.sh` script is designed to automate the installation of all nine specialized toolchains and their dependencies required for the LAGOS framework. It uses a "robust mode" which handles paths, environment variables, and safe fallbacks.

This document breaks down the 13 automated steps executed by the script.

## The 13 Steps of `setup.sh`

### 1. System Dependencies
Installs common build tools and system-level libraries via `apt-get` required for compiling downstream languages. This includes `build-essential`, `curl`, `git`, `libssl-dev`, `cmake`, and `clang`.

### 2. Rust Toolchain
Installs Rust using `rustup`. Rust is a critical prerequisite because several of the core toolchains (like Sui, Lurk, Clarinet, and Noir) are written in Rust or require Cargo to build properly.

### 3. Erlang/OTP
Installs Erlang via `apt-get`. The BEAM virtual machine and OTP framework are strict requirements for running Gleam applications, which powers the LAGOS Federation Supervisor.

### 4. Pony (`ponyup`)
Installs `ponyup`, the official toolchain multiplexer for the Pony language. The script subsequently uses it to install and update `ponyc` (the compiler) and `corral` (the dependency manager).

### 5. Gleam
Downloads a pre-compiled musl-based release of the Gleam compiler (v1.15.4) from its official GitHub repository, extracting and placing it in your `~/.local/bin` directory.

### 6. Sui CLI (Move)
Installs the Sui CLI using the `suiup` installer. After installation, the script also runs `sui move build` against the `contracts/move` directory to verify the toolchain is working correctly and to pre-compile the LAGOS governance contracts.

### 7. Clarinet (Clarity)
Downloads the pre-compiled binary release of Clarinet. Clarinet is a dedicated local development environment and testing harness for Clarity smart contracts.

### 8. Noir (`nargo`)
Installs `noirup` and subsequently `nargo` (Noir's package manager and build tool). This toolchain is used for writing circuits in Noir and generating zero-knowledge proofs.

### 9. Cairo (`scarb`)
Installs Scarb via its official installation script. Scarb acts as the build toolchain and package manager for the Cairo language.

### 10. Lurk
Lurk installation requires a specialized build process. The script attempts a hybrid approach:
- First, it checks for a pre-existing local binary.
- If missing but Docker is available, it uses Docker to compile the binary against a stable Debian environment (avoiding local C++ toolchain conflicts) and extracts the `lurk` binary to your host machine.

### 11. Roc
Downloads the latest nightly build of the Roc language compiler directly from its GitHub release page and installs it to the `~/roc` directory.

### 12. Unison (UCM)
Downloads the latest Linux release of the Unison Codebase Manager (`ucm`), which is used for compiling and executing Unison code, storing it in `~/unison`.

### 13. NATS Messaging Plane
Checks for an active Docker installation and automatically spins up a NATS server container (`lagos-nats` running `nats:latest`) on port `4222`. This is required for the local cross-domain signaling orchestrated by the Gleam federation module.

---

## Verifying the Setup

At the end of its execution, the script runs a final verification loop to ensure the following commands are accessible in your terminal:
`ponyc`, `gleam`, `sui`, `clarinet`, `nargo`, `scarb`, `roc`, `ucm`, and `lurk`.

> **Note:** Unless you run the script using `source setup.sh`, the PATH updates are written directly to your `~/.bashrc`. You will need to either restart your terminal session or manually run `source ~/.bashrc` to make the commands available in your current window.
