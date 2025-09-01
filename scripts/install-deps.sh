#!/bin/bash

# Install Ansible dependencies
# Usage: ./install-deps.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANSIBLE_DIR="$(dirname "$SCRIPT_DIR")"

echo "Installing Ansible Galaxy dependencies..."
echo "========================================"

cd "$ANSIBLE_DIR"

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
