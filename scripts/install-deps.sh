#!/bin/bash

# Install dependencies
# Usage: ./install-deps.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANSIBLE_DIR="$(dirname "$SCRIPT_DIR")"

echo "Installing dependencies..."
echo "========================================"

cd "$ANSIBLE_DIR"

if [[ $OSTYPE == 'darwin'* ]]; then
    # Check for Homebrew and install if we don't have it
    if ! command -v brew >/dev/null 2>&1; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew analytics off
    fi

    # Check for direnv and install if we don't have it
    if ! brew ls --versions direnv > /dev/null; then
        echo "Installing direnv..."
        brew install direnv
        echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
        source ~/.zshrc
    fi

    direnv allow
fi

# Install ansible
if [[ -f "requirements.txt" ]]; then
    echo "Installing from requirements.txt..."
    pip3 install -r requirements.txt
else
    echo "Error: requirements.txt not found in $ANSIBLE_DIR"
    exit 1
fi

# Install collections and roles
if [[ -f "requirements.yml" ]]; then
    echo "Installing from requirements.yml..."
    ansible-galaxy install -r requirements.yml --force
    echo ""
    echo "Dependencies installed successfully!"
else
    echo "Error: requirements.yml not found in $ANSIBLE_DIR"
    exit 1
fi

echo ""
echo "Available roles:"
ansible-galaxy list
