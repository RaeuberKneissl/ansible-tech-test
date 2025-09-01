# Ansible Repository

A complete Ansible repository for deploying and managing nginx web servers across multiple environments.

## Structure

```
.
├── ansible.cfg                 # Ansible configuration
├── requirements.yml            # External roles and collections
├── inventories/               # Environment-specific inventories
│   ├── production/
│   │   ├── hosts.yml          # Production inventory
│   │   └── group_vars/        # Production-specific variables
│   └── uat/
│       ├── hosts.yml          # UAT inventory
│       └── group_vars/        # UAT-specific variables
├── group_vars/                # Common group variables
├── playbooks/                 # Specific playbooks
├── scripts/                   # Helper scripts
├── collections/               # Downloaded collections (auto-created)
├── roles/                     # Downloaded roles (auto-created)
└── logs/                      # Ansible logs (auto-created)
```

## Quick Start

1. **Install dependencies:**
   ```bash
   ./scripts/install-deps.sh
   ```

2. **Deploy to UAT environment:**
   ```bash
   ./scripts/deploy.sh --environment uat
   ```

3. **Deploy to production environment:**
   ```bash
   ./scripts/deploy.sh --environment production
   ```

## Environments

### UAT Environment
- **Hosts:** uat-web-01
- **IP Range:** ToBeDefined
- **Purpose:** Testing and validation
- **Configuration:** Lower resource allocation, debug logging enabled

### Production Environment
- **Hosts:** prod-web-01, prod-web-02, prod-web-03
- **IP Range:** ToBeDefined
- **Purpose:** Live production traffic
- **Configuration:** Optimized for performance, security headers enabled

## Usage Examples

### Basic Deployment
```bash
# Deploy to UAT
./scripts/deploy.sh -e uat

# Deploy to production
./scripts/deploy.sh -e production
```

### Targeted Deployment with Tags
```bash
# Only run nginx configuration tasks
./scripts/deploy.sh -e uat -t nginx

# Only update packages
./scripts/deploy.sh -e production -t packages
```

### Manual Ansible Commands
```bash
# Deploy to UAT
ansible-playbook -i inventories/uat/hosts.yml deploy-nginx.yml

# Deploy to production
ansible-playbook -i inventories/production/hosts.yml deploy-nginx.yml

# Check syntax
ansible-playbook --syntax-check deploy-nginx.yml

# Dry run
ansible-playbook -i inventories/uat/hosts.yml deploy-nginx.yml --check
```

## Configuration

### Nginx Role
This repository uses the official `nginxinc.nginx` role from Ansible Galaxy. The role is configured with:

- **Production:** Optimized worker processes, enhanced logging, security headers
- **UAT:** Reduced workers, debug logging, server tokens enabled for troubleshooting

### Variables
- **Common variables:** `group_vars/nginx_servers.yml`
- **Environment-specific:** `inventories/{env}/group_vars/nginx_servers.yml`
- **Host-specific:** `inventories/{env}/host_vars/{hostname}.yml`

## Security Considerations

- SSH key authentication configured
- Host key checking disabled for lab environments
- Production includes security headers
- Server tokens disabled in production

## Customization

### Adding New Environments
1. Create new inventory directory: `inventories/{env_name}/`
2. Add hosts file: `inventories/{env_name}/hosts.yml`
3. Add environment variables: `inventories/{env_name}/group_vars/nginx_servers.yml`
4. Update deployment script environment validation

### Adding Custom Roles
1. Place custom roles in the `roles/` directory
2. Update `requirements.yml` if using Galaxy roles
3. Include roles in playbooks as needed

## Troubleshooting

### Common Issues
- **Connection refused:** Check SSH access and host IPs
- **Permission denied:** Verify sudo access for the ansible user
- **Role not found:** Run `./scripts/install-deps.sh` to install dependencies

### Logging
- Ansible logs are written to `logs/ansible.log`
- Increase verbosity with `-v`, `-vv`, or `-vvv` flags

### Testing
```bash
# Test connectivity
ansible -i inventories/uat/hosts.yml nginx_servers -m ping

# Gather facts
ansible -i inventories/uat/hosts.yml nginx_servers -m setup
```
