#!/bin/bash

# Ansible deployment script for nginx
# Usage: ./deploy.sh [environment] [tags]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANSIBLE_DIR="$(dirname "$SCRIPT_DIR")"

# Default values
ENVIRONMENT="production"
TAGS=""
PLAYBOOK="site.yml"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--environment)
            ENVIRONMENT="$2"
            shift 2
            ;;
        -t|--tags)
            TAGS="$2"
            shift 2
            ;;
        -p|--playbook)
            PLAYBOOK="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -e, --environment ENV    Target environment (production|uat) [default: production]"
            echo "  -t, --tags TAGS         Ansible tags to run"
            echo "  -p, --playbook PLAYBOOK Playbook to run [default: site.yml]"
            echo "  -h, --help              Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Validate environment
if [[ ! "$ENVIRONMENT" =~ ^(production|uat)$ ]]; then
    echo "Error: Environment must be 'production' or 'uat'"
    exit 1
fi

# Check if inventory exists
INVENTORY_FILE="$ANSIBLE_DIR/inventories/$ENVIRONMENT/hosts.yml"
if [[ ! -f "$INVENTORY_FILE" ]]; then
    echo "Error: Inventory file not found: $INVENTORY_FILE"
    exit 1
fi

# Build ansible-playbook command
ANSIBLE_CMD="ansible-playbook"
ANSIBLE_CMD="$ANSIBLE_CMD -i $INVENTORY_FILE"
ANSIBLE_CMD="$ANSIBLE_CMD $ANSIBLE_DIR/$PLAYBOOK"

if [[ -n "$TAGS" ]]; then
    ANSIBLE_CMD="$ANSIBLE_CMD --tags $TAGS"
fi

echo "========================================"
echo "Deploying to: $ENVIRONMENT"
echo "Inventory: $INVENTORY_FILE"
echo "Playbook: $PLAYBOOK"
echo "Tags: ${TAGS:-all}"
echo "========================================"
echo ""

# Change to ansible directory
cd "$ANSIBLE_DIR"

# Run the playbook
echo "Running: $ANSIBLE_CMD"
eval "$ANSIBLE_CMD"
