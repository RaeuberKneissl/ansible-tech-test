#!/bin/bash

# Install dependencies
# Usage: ./install-deps.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANSIBLE_DIR="$(dirname "$SCRIPT_DIR")"

echo "Installing dependencies..."
echo "========================================"

cd "$ANSIBLE_DIR"

# Install ansible
if [[ -f "requirements.txt" ]]; then
    echo "Installing from requirements.txt..."

    python3 -m venv .venv
    source .venv/bin/activate
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
