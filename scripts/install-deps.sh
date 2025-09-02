#!/bin/zsh -i

# Install dependencies
# Usage: ./install-deps.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${(%):-%N}")" && pwd)"
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

        if ! grep -q 'eval "$(direnv hook zsh)"' ~/.zshrc; then
            echo "Adding direnv hook to .zshrc"
            echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
        fi
        source ~/.zshrc
    fi
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
    direnv allow
    eval "$(direnv export zsh)"

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
