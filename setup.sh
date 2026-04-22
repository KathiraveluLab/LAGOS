#!/bin/bash

# LAGOS: Latency-aware Accountable Governance for Overlay Scaling
# Setup script for Linux (Ubuntu/Debian recommended)

set -e

echo "Starting LAGOS environment setup..."

# 1. System Dependencies
echo "Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y \
    curl git build-essential pkg-config libssl-dev libreadline-dev \
    zlib1g-dev libsqlite3-dev libbz2-dev llvm libncurses5-dev \
    libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev \
    python3-openssl wget cmake m4

# 2. Rust (Required for Sui, Lurk, Clarinet, etc.)
if ! command -v rustup &> /dev/null; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "Rust already installed."
fi

# 3. Erlang/OTP (Required for Gleam)
if ! command -v erl &> /dev/null; then
    echo "Installing Erlang..."
    sudo apt-get install -y erlang
else
    echo "Erlang already installed."
fi

# 4. Pony (via ponyup)
if ! command -v ponyup &> /dev/null; then
    echo "Installing ponyup..."
    sh -c "$(curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/ponylang/ponyup/master/ponyup-init.sh)"
    export PATH="$HOME/.local/share/ponyup/bin:$PATH"
    ponyup update ponyc release
    ponyup update corral release
else
    echo "Ponyup already installed."
fi

# 5. Gleam
if ! command -v gleam &> /dev/null; then
    echo "Installing Gleam..."
    GLEAM_VERSION="v1.15.4"
    GLEAM_FILE="gleam-$GLEAM_VERSION-x86_64-unknown-linux-musl.tar.gz"
    wget "https://github.com/gleam-lang/gleam/releases/download/$GLEAM_VERSION/$GLEAM_FILE"
    tar -xzf "$GLEAM_FILE"
    mkdir -p "$HOME/.local/bin"
    mv gleam "$HOME/.local/bin/gleam"
    rm "$GLEAM_FILE"
else
    echo "Gleam already installed."
fi

# 6. Sui CLI (Move)
if ! command -v sui &> /dev/null; then
    echo "Installing Sui CLI (this may take a while if building from source)..."
    # Using cargo install for compatibility, but binaries are faster.
    # We prefer cargo install --locked for reliability in research environments.
    cargo install --locked --git https://github.com/MystenLabs/sui.git --branch mainnet sui
else
    echo "Sui CLI already installed."
fi

# 7. Clarinet (Clarity)
if ! command -v clarinet &> /dev/null; then
    echo "Installing Clarinet..."
    cargo install clarinet --locked
else
    echo "Clarinet already installed."
fi

# 8. Noir (via noirup)
if ! command -v nargo &> /dev/null; then
    echo "Installing Noir..."
    curl -L https://raw.githubusercontent.com/noir-lang/noirup/main/install | bash
    export PATH="$HOME/.nargo/bin:$PATH"
    # Source noirup if it exists
    [ -f "$HOME/.nargo/bin/noirup" ] && "$HOME/.nargo/bin/noirup"
else
    echo "Noir already installed."
fi

# 9. Cairo (Scarb)
if ! command -v scarb &> /dev/null; then
    echo "Installing Scarb..."
    curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh
else
    echo "Scarb already installed."
fi

# 10. Lurk (Build from source)
if ! command -v lurk &> /dev/null; then
    echo "Building Lurk from source..."
    cargo install --git https://github.com/lurk-lang/lurk-rs.git
else
    echo "Lurk already installed."
fi

# 11. Roc
if ! command -v roc &> /dev/null; then
    echo "Installing Roc (Nightly)..."
    ROC_VERSION="roc_nightly-linux_x86_64-latest.tar.gz"
    wget "https://github.com/roc-lang/roc/releases/download/nightly/$ROC_VERSION"
    mkdir -p "$HOME/roc"
    tar -xzf "$ROC_VERSION" -C "$HOME/roc" --strip-components=1
    rm "$ROC_VERSION"
    export PATH="$HOME/roc:$PATH"
else
    echo "Roc already installed."
fi

# 12. Unison (UCM)
if ! command -v ucm &> /dev/null; then
    echo "Installing Unison Code Manager..."
    UCM_VERSION="ucm-linux.tar.gz"
    wget "https://github.com/unisonweb/unison/releases/download/M5h/$UCM_VERSION"
    mkdir -p "$HOME/unison"
    tar -xzf "$UCM_VERSION" -C "$HOME/unison"
    rm "$UCM_VERSION"
    export PATH="$HOME/unison:$PATH"
else
    echo "Unison already installed."
fi

echo "---------------------------------------------------"
echo "LAGOS setup complete!"
echo "Please restart your shell or run 'source ~/.bashrc' (or your shell profile) to update your PATH."
echo "---------------------------------------------------"
