#!/bin/bash

# LAGOS: Latency-aware Accountable Governance for Overlay Scaling
# Setup script for Linux (Ubuntu/Debian recommended)

# Remove set -e to handle errors manually with better tracing
# set -e

# --- 0. Helper Functions & Pre-flight ---

# Detect if the script is being sourced
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    IS_SOURCED=true
    echo "Note: Script is being sourced. Sourcing will update your current session PATH."
else
    IS_SOURCED=false
fi

# Function to exit or return depending on how script was called
safe_exit() {
    local code=$1
    if [ "$IS_SOURCED" = true ]; then
        return "$code" 2>/dev/null || exit "$code"
    else
        exit "$code"
    fi
}

# Function to execute a command and handle errors
execute() {
    local label=$1
    shift
    echo " [PHASE] $label..."
    if "$@"; then
        echo " [OK] $label completed."
    else
        local exit_code=$?
        echo " [ERROR] $label failed."
        echo " Trace: Command '$*' exited with code $exit_code."
        safe_exit 1
    fi
}

echo "==================================================="
echo "   LAGOS Environment Setup - Robust Mode"
echo "==================================================="

# 1. System Dependencies
execute "Installing system dependencies" \
    sudo apt-get update && \
    sudo apt-get install -y \
    curl git build-essential pkg-config libssl-dev libreadline-dev \
    zlib1g-dev libsqlite3-dev libbz2-dev llvm libncurses5-dev \
    libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev \
    python3-openssl wget cmake m4 clang libclang-dev

# 2. Rust (Required for Sui, Lurk, Clarinet, etc.)
if ! command -v rustup &> /dev/null; then
    execute "Installing Rust" \
        sh -c "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"
    source "$HOME/.cargo/env"
else
    echo "Rust already installed."
fi

# 3. Erlang/OTP (Required for Gleam)
if ! command -v erl &> /dev/null; then
    execute "Installing Erlang" sudo apt-get install -y erlang
else
    echo "Erlang already installed."
fi

# 4. Pony (via ponyup)
if ! command -v ponyup &> /dev/null; then
    execute "Installing ponyup" \
        sh -c "curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/ponylang/ponyup/master/ponyup-init.sh | sh -s"
    export PATH="$HOME/.local/share/ponyup/bin:$PATH"
    execute "Updating Ponyc" ponyup update ponyc release
    execute "Updating Corral" ponyup update corral release
else
    echo "Ponyup already installed."
fi

# 5. Gleam
if ! command -v gleam &> /dev/null; then
    echo "Installing Gleam..."
    GLEAM_VERSION="v1.15.4"
    GLEAM_FILE="gleam-$GLEAM_VERSION-x86_64-unknown-linux-musl.tar.gz"
    execute "Downloading Gleam" wget "https://github.com/gleam-lang/gleam/releases/download/$GLEAM_VERSION/$GLEAM_FILE"
    execute "Extracting Gleam" tar -xzf "$GLEAM_FILE"
    mkdir -p "$HOME/.local/bin"
    execute "Installing Gleam binary" mv gleam "$HOME/.local/bin/gleam"
    rm "$GLEAM_FILE"
else
    echo "Gleam already installed."
fi

# 6. Sui CLI (Move)
if ! command -v sui &> /dev/null; then
    execute "Installing Sui CLI (via suiup)" \
        sh -c "curl -sSfL https://raw.githubusercontent.com/MystenLabs/suiup/main/install.sh | sh"
    # Suiup installs to ~/.suiup/bin by default
    export PATH="$HOME/.suiup/bin:$PATH"
    execute "Installing Sui toolchain" suiup install sui
else
    echo "Sui CLI already installed."
fi

# 7. Clarinet (Clarity)
if ! command -v clarinet &> /dev/null; then
    execute "Installing Clarinet (binary)" \
        sh -c "wget -q https://github.com/hirosystems/clarinet/releases/latest/download/clarinet-linux-x64-glibc.tar.gz -O clarinet.tar.gz && \
               tar -xzf clarinet.tar.gz && \
               mkdir -p $HOME/.local/bin && \
               mv clarinet $HOME/.local/bin/clarinet && \
               rm clarinet.tar.gz"
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "Clarinet already installed."
fi

# 8. Noir (via noirup)
if ! command -v nargo &> /dev/null; then
    execute "Installing Noir installer" \
        sh -c "curl -L https://raw.githubusercontent.com/noir-lang/noirup/main/install | bash"
    export PATH="$HOME/.nargo/bin:$PATH"
    execute "Installing Noir toolchain (nargo)" noirup
else
    echo "Noir already installed."
fi

# 9. Cairo (Scarb)
if ! command -v scarb &> /dev/null; then
    execute "Installing Scarb" \
        sh -c "curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh"
else
    echo "Scarb already installed."
fi

# 10. Lurk (Search for binary or skip build if exists)
if ! command -v lurk &> /dev/null; then
    echo " [INFO] Lurk binary not found. Please install via Docker-extract or use a pre-built binary."
else
    echo "Lurk already installed."
fi

# 11. Roc
if ! command -v roc &> /dev/null; then
    ROC_VERSION="roc_nightly-linux_x86_64-latest.tar.gz"
    execute "Downloading Roc" wget -q "https://github.com/roc-lang/roc/releases/download/nightly/$ROC_VERSION"
    mkdir -p "$HOME/roc"
    execute "Extracting Roc" tar -xzf "$ROC_VERSION" -C "$HOME/roc" --strip-components=1
    rm "$ROC_VERSION"
    export PATH="$HOME/roc:$PATH"
else
    echo "Roc already installed."
fi

# 12. Unison (UCM)
if ! command -v ucm &> /dev/null; then
    UCM_FILE="ucm-linux-x64.tar.gz"
    execute "Downloading Unison" wget -q "https://github.com/unisonweb/unison/releases/latest/download/$UCM_FILE"
    mkdir -p "$HOME/unison"
    execute "Extracting Unison" tar -xzf "$UCM_FILE" -C "$HOME/unison"
    rm "$UCM_FILE"
    export PATH="$HOME/unison:$PATH"
else
    echo "Unison already installed."
fi

echo "---------------------------------------------------"
echo "LAGOS setup complete!"
if [ "$IS_SOURCED" = true ]; then
    echo "Since this script was sourced, your current PATH has been updated."
    echo "However, it is still recommended to restart your shell for all profile changes to take effect."
else
    echo "Please restart your shell or run 'source ~/.bashrc' (or your shell profile) to update your PATH."
fi
echo "---------------------------------------------------"
