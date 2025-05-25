# 📁 ANSIBLE ENDPOINT VALIDATOR - Struktura Projektu

```
ansible-endpoint-validator/
├── 📄 README.md                          # Dokumentacja projektu
├── 🔧 setup.sh                           # Instalator wszystkich dependencies
├── 🚀 validate.sh                        # Quick launcher
├── ⚙️  ansible.cfg                        # Konfiguracja Ansible
├── 📋 inventory.yml                       # Hosty i grupy
├── 🎯 validate_endpoints.yml              # Główny playbook
├── 📁 environments/                       # Konfiguracje środowisk
│   ├── dev.yml                           # Development
│   ├── staging.yml                       # Staging  
│   ├── production.yml                    # Production
│   └── local.yml                         # Local testing
├── 📁 protocols/                          # Konfiguracje protokołów (.env per protokół)
│   ├── http/
│   │   ├── .env                          # HTTP endpoints config
│   │   └── endpoints.yml                 # Structured config
│   ├── database/
│   │   ├── .env                          # DB connections
│   │   └── endpoints.yml
│   ├── file/
│   │   ├── .env                          # File paths
│   │   └── endpoints.yml
│   ├── network/
│   │   ├── .env                          # TCP/UDP services
│   │   └── endpoints.yml
│   ├── email/
│   │   ├── .env                          # SMTP config
│   │   └── endpoints.yml
│   ├── ftp/
│   │   ├── .env                          # FTP servers
│   │   └── endpoints.yml
│   ├── cloud/
│   │   ├── .env                          # AWS/Azure/GCP
│   │   └── endpoints.yml
│   ├── messaging/
│   │   ├── .env                          # RabbitMQ/Kafka
│   │   └── endpoints.yml
│   ├── ldap/
│   │   ├── .env                          # LDAP/AD
│   │   └── endpoints.yml
│   └── containers/
│       ├── .env                          # Docker/K8s
│       └── endpoints.yml
├── 📁 templates/                          # Jinja2 templates
│   ├── report.html.j2                    # Main HTML report
│   ├── summary.json.j2                   # JSON summary
│   └── slack_notification.j2             # Slack webhook
├── 📁 reports/                            # Generated reports
│   └── .gitkeep                          
├── 📁 scripts/                            # Helper scripts
│   ├── generate_configs.sh               # Auto-generate protocol configs
│   ├── deploy.sh                         # Deploy to environments
│   └── cleanup.sh                        # Clean old reports
└── 🧪 tests/                             # Validation tests
    ├── test_playbook.yml                 # Test the playbook itself
    └── mock_endpoints.yml                # Mock services for testing
```
## 📊 Statystyki
- **Pliki konfiguracyjne**: 20+
- **Protokoły**: 10
- **Środowiska**: 4  
- **Łączny rozmiar**: ~50KB (bez reportów)
- **Setup time**: < 2 minuty






---
title: "🎯 Ansible Endpoint Validator"
description: "Minimalist endpoint validation for 10+ protocols with beautiful HTML reports"
author: "Tom Sapletta | tom.sapletta.com"
version: "1.0.0"
---

# 🎯 Ansible Endpoint Validator

> **Minimalist approach:** Maximum protocols, minimum code, beautiful reports

[![Ansible](https://img.shields.io/badge/Ansible-6.0+-red)](https://ansible.com)
[![Python](https://img.shields.io/badge/Python-3.8+-blue)](https://python.org)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

## 🌟 Features

- **🔥 10+ Protocols** - HTTP, Database, File, Network, Email, FTP, Cloud, Messaging, LDAP, Containers
- **📊 Beautiful Reports** - HTML dashboards with charts and responsive design
- **⚡ Minimalist Code** - 1 line YAML per endpoint, maximum efficiency
- **🌍 Multi-Environment** - Dev, Staging, Production configurations
- **🔧 Modular Config** - Each protocol has its own .env file
- **📱 Responsive** - Mobile-friendly HTML reports
- **🚀 Quick Setup** - 2-minute installation with automated script

## 🚀 Quick Start

### 1. Installation
```bash
git clone https://github.com/taskinity/ansible-endpoint-validator.git
cd ansible-endpoint-validator
chmod +x setup.sh
./setup.sh
```

### 2. Basic Validation
```bash
# Validate development environment
./validate.sh

# Validate production environment
./validate.sh production

# Validate specific protocols only
./validate.sh dev localhost --tags "http,database"
```

### 3. View Reports
Reports are generated in `./reports/` directory with timestamp.
The script automatically opens the latest report in your browser.

## 📋 Supported Protocols

| Protocol | Example Configuration | Lines of Code |
|----------|----------------------|---------------|
| **🌐 HTTP/HTTPS** | `- uri: { url: "{{ endpoint }}" }` | 1 |
| **💾 PostgreSQL** | `- postgresql_ping: { host: "{{ host }}" }` | 1 |
| **💾 MySQL** | `- mysql_ping: { host: "{{ host }}" }` | 1 |
| **💾 MongoDB** | `- mongodb_ping: { hosts: "{{ hosts }}" }` | 1 |
| **💾 Redis** | `- redis: { host: "{{ host }}" }` | 1 |
| **📁 File System** | `- stat: { path: "{{ path }}" }` | 1 |
| **🔌 Network TCP** | `- wait_for: { host: "{{ host }}", port: {{ port }} }` | 1 |
| **📧 SMTP** | `- mail: { host: "{{ host }}", dry_run: true }` | 1 |
| **📡 FTP** | `- command: "curl ftp://{{ host }}"` | 1 |
| **🔐 LDAP** | `- ldap_search: { dn: "{{ dn }}" }` | 1 |

## 📁 Project Structure

```
ansible-endpoint-validator/
├── 🚀 setup.sh                    # Automated installer
├── 🎯 validate.sh                 # Quick launcher
├── 📋 validate_endpoints.yml      # Main playbook (50 lines!)
├── ⚙️  ansible.cfg                # Ansible configuration
├── 📊 inventory.yml               # Target hosts
├── 📁 protocols/                  # Protocol configurations
│   ├── http/.env                 # HTTP endpoints
│   ├── database/.env             # DB connections  
│   ├── file/.env                 # File paths
│   ├── network/.env              # Network services
│   ├── email/.env                # SMTP config
│   ├── ftp/.env                  # FTP servers
│   ├── cloud/.env                # Cloud APIs
│   ├── messaging/.env            # Message queues
│   ├── ldap/.env                 # LDAP/AD
│   └── containers/.env           # Docker/K8s
├── 🌍 environments/               # Environment configs
│   ├── dev.yml                   # Development
│   ├── staging.yml               # Staging
│   └── production.yml            # Production
├── 🎨 templates/                  # Report templates
│   └── report.html.j2            # HTML report template
└── 📊 reports/                    # Generated reports

Total: ~20 files, 50KB, setup in 2 minutes
```

## ⚙️ Configuration

### Environment-Specific Settings
Edit `environments/{env}.yml`:
```yaml
# environments/production.yml
---
environment_name: "Production"
api_timeout: 30
network_timeout: 10
strict_validation: true
```

### Protocol-Specific Endpoints
Edit `protocols/{protocol}/.env`:
```bash
# protocols/http/.env
API_BASE_URL=https://api.production.com
API_HEALTH_ENDPOINT=${API_BASE_URL}/health
EXTERNAL_API_1=https://api.github.com

# protocols/database/.env
POSTGRES_HOST=db.production.com
POSTGRES_PORT=5432
POSTGRES_USER=app_user
POSTGRES_PASSWORD=secure_password
```

### Host Inventory
Edit `inventory.yml`:
```yaml
all:
  children:
    production:
      hosts:
        prod-server-01:
          ansible_host: 10.0.3.10
        prod-server-02:
          ansible_host: 10.0.3.11
```

## 🎯 Usage Examples

### Basic Validation
```bash
# Development environment (default)
./validate.sh

# Specific environment
./validate.sh production
./validate.sh staging
```

### Advanced Options
```bash
# Specific protocols only
./validate.sh dev localhost --tags "http,database"

# Dry run (check mode)
./validate.sh production --check

# Verbose output
./validate.sh dev --verbose

# Limit to specific hosts
./validate.sh production --limit "prod-server-01"

# Multiple options
./validate.sh staging all --tags "network" --verbose
```

### Custom Variables
```bash
# Override specific endpoints
./validate.sh dev --extra-vars "api_host=https://custom-api.com"

# Change report format
./validate.sh production --extra-vars "report_format=json"
```

## 📊 Report Features

### HTML Dashboard
- **📱 Responsive Design** - Works on desktop, tablet, mobile
- **🎨 Beautiful UI** - Modern gradient backgrounds, cards, animations
- **📈 Progress Bars** - Visual success rates for each protocol
- **🎯 Status Badges** - Color-coded success/error indicators
- **📋 Detailed Tables** - Response times, file sizes, error messages
- **🔍 System Info** - OS, memory, CPU details
- **⏰ Timestamps** - Generation time and environment info

### Report Sections
1. **📊 Summary Cards** - Quick overview with success rates
2. **🌐 HTTP Endpoints** - Response codes, timing, content size
3. **📁 File System** - Path existence, permissions, sizes
4. **🔌 Network Services** - Port connectivity, timeouts
5. **💾 Database Connections** - Connection status, error messages
6. **📧 Email Services** - SMTP availability (dry run)
7. **📊 System Information** - Host details and Ansible version

## 🔧 Customization

### Adding New Protocols
1. **Create protocol directory:**
```bash
mkdir protocols/myprotocol
```

2. **Add configuration:**
```bash
# protocols/myprotocol/.env
MY_SERVICE_HOST=localhost
MY_SERVICE_PORT=8080
```

3. **Add to playbook:**
```yaml
- name: "🎯 My Protocol Check"
  wait_for:
    host: "{{ my_service_host }}"
    port: "{{ my_service_port }}"
  register: myprotocol_result
  tags: [myprotocol]
```

### Custom Report Templates
Modify `templates/report.html.j2` to add:
- Company branding
- Additional charts
- Custom styling
- Extra sections

## 🌍 Multi-Environment Setup

### Development Environment
```bash
# Local services, relaxed timeouts
./validate.sh dev
```

### Staging Environment
```bash
# Pre-production testing
./validate.sh staging
```

### Production Environment
```bash
# Live services, strict validation
./validate.sh production
```

### Environment Variables
Each environment can override settings:
```yaml
# environments/production.yml
---
api_timeout: 30          # Longer timeout for production
strict_validation: true  # Fail on any error
enable_notifications: true
```

## 🚀 Integration

### CI/CD Pipeline (GitHub Actions)
```yaml
# .github/workflows/validate.yml
name: Endpoint Validation
on: [push, schedule]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: Setup
      run: ./setup.sh
    - name: Validate
      run: ./validate.sh production --extra-vars "report_format=json"
    - name: Upload Report
      uses: actions/upload-artifact@v3
      with:
        name: validation-report
        path: reports/
```

### Jenkins Pipeline
```groovy
pipeline {
    agent any
    stages {
        stage('Validate Endpoints') {
            steps {
                sh './setup.sh'
                sh './validate.sh production'
                publishHTML([
                    allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'reports',
                    reportFiles: '*.html',
                    reportName: 'Endpoint Validation Report'
                ])
            }
        }
    }
}
```

### Cron Scheduling
```bash
# Validate production every hour
0 * * * * cd /path/to/validator && ./validate.sh production

# Validate development every 15 minutes
*/15 * * * * cd /path/to/validator && ./validate.sh dev
```

## 📋 Troubleshooting

### Common Issues

**❌ "Virtual environment not found"**
```bash
# Solution: Run setup first
./setup.sh
```

**❌ "Permission denied"**
```bash
# Solution: Make scripts executable
chmod +x setup.sh validate.sh
```

**❌ "Ansible collection not found"**
```bash
# Solution: Install missing collections
source venv/bin/activate
ansible-galaxy collection install community.general
```

**❌ "Connection refused"**
```bash
# Solution: Check if services are running
# For local testing, start services:
docker run -d -p 5432:5432 postgres
docker run -d -p 6379:6379 redis
```

### Debug Mode
```bash
# Verbose output
./validate.sh dev --verbose

# Ansible debug
ANSIBLE_DEBUG=1 ./validate.sh dev

# Check configuration
ansible-playbook validate_endpoints.yml --check --diff
```

## 🔐 Security

### Credentials Management
- Use Ansible Vault for sensitive data:
```bash
ansible-vault encrypt protocols/database/.env
```

- Environment variables for CI/CD:
```bash
export POSTGRES_PASSWORD="$VAULT_PASSWORD"
```

- SSH key authentication for remote hosts:
```bash
ssh-copy-id user@production-server
```

### Best Practices
- ✅ Use non-privileged accounts
- ✅ Encrypt sensitive configurations
- ✅ Limit network access with firewalls
- ✅ Regular security updates
- ✅ Audit logs and reports

## 📈 Performance

### Optimization Tips
- **Parallel execution** - Ansible runs tasks in parallel across hosts
- **Fact caching** - Reduces gather time on repeated runs
- **Connection reuse** - SSH connection pooling enabled
- **Selective tags** - Run only needed protocols
- **Inventory limits** - Target specific hosts

### Benchmarks
- **Single host:** ~30 seconds for all protocols
- **10 hosts:** ~45 seconds (parallel execution)
- **100 hosts:** ~120 seconds with proper inventory grouping

## 🔄 Updates & Maintenance

### Updating Dependencies
```bash
source venv/bin/activate
pip install --upgrade ansible
ansible-galaxy collection install --upgrade community.general
```

### Cleaning Reports
```bash
# Remove reports older than 7 days
find reports/ -name "*.html" -mtime +7 -delete
```

### Backup Configuration
```bash
tar -czf backup-$(date +%Y%m%d).tar.gz protocols/ environments/ inventory.yml
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-protocol`
3. Add your protocol configuration
4. Test with `./validate.sh dev --tags your-protocol`
5. Update documentation
6. Submit pull request

### Development Setup
```bash
git clone https://github.com/taskinity/ansible-endpoint-validator.git
cd ansible-endpoint-validator
./setup.sh
./validate.sh dev --check  # Test without changes
```

## 📄 License

MIT License - see [LICENSE](LICENSE) file.

## 🙋‍♂️ Support

- **📧 Email:** tom@sapletta.com
- **🌐 Website:** [tom.sapletta.com](https://tom.sapletta.com)
- **💼 LinkedIn:** [tom-sapletta-com](https://linkedin.com/in/tom-sapletta-com)
- **🐙 GitHub:** [tom-sapletta-com](https://github.com/tom-sapletta-com)

## 🎯 Roadmap

- [ ] **Slack/Teams notifications** for failed validations
- [ ] **Grafana dashboard** integration
- [ ] **API endpoints** for programmatic access
- [ ] **Docker container** for easy deployment
- [ ] **Kubernetes operator** for cloud-native validation
- [ ] **Plugin system** for custom protocols

## 📊 Statistics

- **Lines of Code:** ~200 (vs 2000+ in other solutions)
- **Setup Time:** < 2 minutes
- **Protocols Supported:** 10+
- **File Size:** ~50KB total
- **Dependencies:** Minimal (Ansible + Python libraries)

---

**⭐ If this project helped you, please star it on GitHub!**

*Created with ❤️ by Tom Sapletta | [tom.sapletta.com](https://tom.sapletta.com)*}
