#!/bin/bash
set -e

# 🚀 ANSIBLE ENDPOINT VALIDATOR - SETUP SCRIPT
# Instalator wszystkich dependencies dla 10 protokołów

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$PROJECT_DIR/setup.log"

log() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} $1"
    echo "[$(date +'%H:%M:%S')] $1" >> "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
    echo "[ERROR] $1" >> "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
    echo "[WARNING] $1" >> "$LOG_FILE"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
    echo "[INFO] $1" >> "$LOG_FILE"
}

# Banner
show_banner() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║  🎯 ANSIBLE ENDPOINT VALIDATOR - SETUP                       ║
║  📧 Autor: Tom Sapletta | tom.sapletta.com                   ║
║  🔧 Installing dependencies for 10+ protocols                ║
╚══════════════════════════════════════════════════════════════╝
EOF
}

# Check OS and package manager
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        PKG_MANAGER="brew"
    elif [[ -f /etc/debian_version ]]; then
        OS="debian"
        PKG_MANAGER="apt"
    elif [[ -f /etc/redhat-release ]]; then
        OS="redhat"
        PKG_MANAGER="yum"
    elif [[ -f /etc/arch-release ]]; then
        OS="arch"
        PKG_MANAGER="pacman"
    else
        OS="unknown"
        PKG_MANAGER="unknown"
    fi

    info "Detected OS: $OS ($PKG_MANAGER)"
}

# Install system dependencies
install_system_deps() {
    log "📦 Installing system dependencies..."

    case $PKG_MANAGER in
        "apt")
            sudo apt update
            sudo apt install -y \
                python3 python3-pip python3-venv \
                curl wget netcat-openbsd \
                postgresql-client mysql-client \
                ldap-utils \
                sshpass \
                git
            ;;
        "yum")
            sudo yum install -y \
                python3 python3-pip \
                curl wget nc \
                postgresql mysql \
                openldap-clients \
                sshpass \
                git
            ;;
        "brew")
            brew install \
                python3 \
                curl wget netcat \
                postgresql mysql-client \
                openldap \
                sshpass \
                git
            ;;
        "pacman")
            sudo pacman -Sy --noconfirm \
                python python-pip \
                curl wget gnu-netcat \
                postgresql mysql \
                openldap \
                sshpass \
                git
            ;;
        *)
            warning "Unknown package manager. Install dependencies manually."
            ;;
    esac
}

# Install Python dependencies
install_python_deps() {
    log "🐍 Installing Python dependencies..."

    # Create virtual environment
    python3 -m venv "$PROJECT_DIR/venv"
    source "$PROJECT_DIR/venv/bin/activate"

    # Upgrade pip
    pip install --upgrade pip

    # Install Ansible and collections
    pip install \
        ansible>=6.0.0 \
        jinja2 \
        pyyaml \
        requests \
        psycopg2-binary \
        pymongo \
        redis \
        boto3 \
        azure-identity \
        azure-mgmt-storage \
        google-cloud-storage \
        ldap3 \
        pika \
        kafka-python

    # Install Ansible collections
    ansible-galaxy collection install \
        community.general \
        community.postgresql \
        community.mysql \
        community.mongodb \
        community.rabbitmq \
        community.docker \
        kubernetes.core \
        amazon.aws \
        azure.azcollection \
        google.cloud

    log "✅ Python dependencies installed"
}

# Create project structure
create_structure() {
    log "📁 Creating project structure..."

    cd "$PROJECT_DIR"

    # Create directories
    mkdir -p {environments,protocols/{http,database,file,network,email,ftp,cloud,messaging,ldap,containers},templates,reports,scripts,tests}

    # Create .gitkeep files
    touch reports/.gitkeep

    log "✅ Directory structure created"
}

# Generate protocol configurations
generate_protocol_configs() {
    log "⚙️  Generating protocol configurations..."

    # HTTP Protocol
    cat > protocols/http/.env << 'EOF'
# HTTP/HTTPS Endpoints Configuration
API_BASE_URL=https://httpbin.org
API_HEALTH_ENDPOINT=${API_BASE_URL}/status/200
API_AUTH_ENDPOINT=${API_BASE_URL}/bearer
EXTERNAL_API_1=https://api.github.com
EXTERNAL_API_2=https://jsonplaceholder.typicode.com/posts/1
WEB_TIMEOUT=10
EOF

    cat > protocols/http/endpoints.yml << 'EOF'
---
http_endpoints:
  - name: "API Health Check"
    url: "{{ api_health_endpoint | default('https://httpbin.org/status/200') }}"
    method: GET
    expected_status: 200
    timeout: "{{ web_timeout | default(10) }}"

  - name: "External API 1"
    url: "{{ external_api_1 | default('https://api.github.com') }}"
    method: GET
    expected_status: 200

  - name: "External API 2"
    url: "{{ external_api_2 | default('https://jsonplaceholder.typicode.com/posts/1') }}"
    method: GET
    expected_status: 200
EOF

    # Database Protocol
    cat > protocols/database/.env << 'EOF'
# Database Connections Configuration
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=postgres

MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=mysql
MYSQL_DB=mysql

MONGO_HOST=localhost
MONGO_PORT=27017
MONGO_USER=admin
MONGO_PASSWORD=admin
MONGO_DB=admin

REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
EOF

    cat > protocols/database/endpoints.yml << 'EOF'
---
database_endpoints:
  postgres:
    login_host: "{{ postgres_host | default('localhost') }}"
    login_port: "{{ postgres_port | default(5432) }}"
    login_user: "{{ postgres_user | default('postgres') }}"
    login_password: "{{ postgres_password | default('') }}"
    login_db: "{{ postgres_db | default('postgres') }}"

  mysql:
    login_host: "{{ mysql_host | default('localhost') }}"
    login_port: "{{ mysql_port | default(3306) }}"
    login_user: "{{ mysql_user | default('root') }}"
    login_password: "{{ mysql_password | default('') }}"
    login_db: "{{ mysql_db | default('mysql') }}"

  mongodb:
    hosts: "{{ mongo_host | default('localhost') }}:{{ mongo_port | default(27017) }}"
    database: "{{ mongo_db | default('admin') }}"
    username: "{{ mongo_user | default('') }}"
    password: "{{ mongo_password | default('') }}"

  redis:
    host: "{{ redis_host | default('localhost') }}"
    port: "{{ redis_port | default(6379) }}"
    password: "{{ redis_password | default('') }}"
EOF

    # File System Protocol
    cat > protocols/file/.env << 'EOF'
# File System Paths Configuration
INPUT_DIR=/tmp/input
OUTPUT_DIR=/tmp/output
ERROR_DIR=/tmp/error
CONFIG_DIR=/etc/myapp
LOG_DIR=/var/log/myapp
DATA_DIR=/data
BACKUP_DIR=/backup
EOF

    cat > protocols/file/endpoints.yml << 'EOF'
---
file_endpoints:
  - path: "{{ input_dir | default('/tmp/input') }}"
    name: "Input Directory"
    required: true

  - path: "{{ output_dir | default('/tmp/output') }}"
    name: "Output Directory"
    required: true

  - path: "{{ error_dir | default('/tmp/error') }}"
    name: "Error Directory"
    required: false

  - path: "{{ config_dir | default('/etc/myapp') }}"
    name: "Config Directory"
    required: true

  - path: "{{ log_dir | default('/var/log/myapp') }}"
    name: "Log Directory"
    required: false
EOF

    # Network Services Protocol
    cat > protocols/network/.env << 'EOF'
# Network Services Configuration
SSH_HOST=localhost
SSH_PORT=22
TELNET_HOST=localhost
TELNET_PORT=23
SNMP_HOST=localhost
SNMP_PORT=161
DNS_HOST=8.8.8.8
DNS_PORT=53
NTP_HOST=pool.ntp.org
NTP_PORT=123
EOF

    cat > protocols/network/endpoints.yml << 'EOF'
---
network_services:
  - name: "SSH Service"
    host: "{{ ssh_host | default('localhost') }}"
    port: "{{ ssh_port | default(22) }}"
    timeout: 5

  - name: "DNS Service"
    host: "{{ dns_host | default('8.8.8.8') }}"
    port: "{{ dns_port | default(53) }}"
    timeout: 3

  - name: "NTP Service"
    host: "{{ ntp_host | default('pool.ntp.org') }}"
    port: "{{ ntp_port | default(123) }}"
    timeout: 5
EOF

    # Email Protocol
    cat > protocols/email/.env << 'EOF'
# Email Services Configuration
SMTP_HOST=localhost
SMTP_PORT=25
SMTP_USER=
SMTP_PASSWORD=
SMTP_TLS=false
SMTP_FROM=test@example.com
SMTP_TO=recipient@example.com
EOF

    cat > protocols/email/endpoints.yml << 'EOF'
---
email_config:
  host: "{{ smtp_host | default('localhost') }}"
  port: "{{ smtp_port | default(25) }}"
  username: "{{ smtp_user | default('') }}"
  password: "{{ smtp_password | default('') }}"
  secure: "{{ smtp_tls | default(false) }}"
  from: "{{ smtp_from | default('test@example.com') }}"
  to: "{{ smtp_to | default('recipient@example.com') }}"
EOF

    # Generate remaining protocols (FTP, Cloud, Messaging, LDAP, Containers)
    generate_remaining_protocols

    log "✅ Protocol configurations generated"
}

generate_remaining_protocols() {
    # FTP Protocol
    cat > protocols/ftp/.env << 'EOF'
# FTP/SFTP Configuration
FTP_HOST=localhost
FTP_PORT=21
FTP_USER=ftpuser
FTP_PASSWORD=ftppass
SFTP_HOST=localhost
SFTP_PORT=22
SFTP_USER=sftpuser
SFTP_KEY_FILE=~/.ssh/id_rsa
EOF

    # Cloud Protocol
    cat > protocols/cloud/.env << 'EOF'
# Cloud Services Configuration
AWS_REGION=us-east-1
AWS_S3_BUCKET=test-bucket
AZURE_RESOURCE_GROUP=test-rg
AZURE_STORAGE_ACCOUNT=teststorage
GCP_PROJECT_ID=test-project
GCP_BUCKET=test-gcp-bucket
EOF

    # Messaging Protocol
    cat > protocols/messaging/.env << 'EOF'
# Message Queue Configuration
RABBITMQ_HOST=localhost
RABBITMQ_PORT=5672
RABBITMQ_USER=guest
RABBITMQ_PASSWORD=guest
RABBITMQ_VHOST=/
KAFKA_HOST=localhost
KAFKA_PORT=9092
KAFKA_TOPIC=test-topic
EOF

    # LDAP Protocol
    cat > protocols/ldap/.env << 'EOF'
# LDAP/Active Directory Configuration
LDAP_HOST=localhost
LDAP_PORT=389
LDAP_USER=cn=admin,dc=example,dc=com
LDAP_PASSWORD=admin
LDAP_BASE_DN=dc=example,dc=com
AD_HOST=localhost
AD_PORT=389
AD_DOMAIN=example.com
EOF

    # Containers Protocol
    cat > protocols/containers/.env << 'EOF'
# Container Services Configuration
DOCKER_HOST=unix:///var/run/docker.sock
K8S_NAMESPACE=default
K8S_CONTEXT=default
CONTAINER_NAMES=nginx,redis,postgres
K8S_SERVICES=api-service,db-service
EOF

    # Generate corresponding .yml files for remaining protocols
    cat > protocols/ftp/endpoints.yml << 'EOF'
---
ftp_services:
  - host: "{{ ftp_host | default('localhost') }}"
    port: "{{ ftp_port | default(21) }}"
    username: "{{ ftp_user | default('') }}"
    password: "{{ ftp_password | default('') }}"
    name: "FTP Server"
EOF
}

# Create main playbook
create_main_playbook() {
    log "📝 Creating main validation playbook..."

    cat > validate_endpoints.yml << 'EOF'
# 🎯 ANSIBLE ENDPOINT VALIDATOR - Main Playbook
# Minimalist approach: Maximum protocols, minimum code

---
- name: "🔍 Ultimate Endpoint Validation"
  hosts: "{{ target_hosts | default('all') }}"
  gather_facts: true
  vars:
    env: "{{ environment | default('dev') }}"
    protocols_dir: "{{ playbook_dir }}/protocols"

  vars_files:
    - "environments/{{ env }}.yml"

  pre_tasks:
    - name: "📋 Load protocol configurations"
      include_vars: "{{ item }}"
      with_fileglob:
        - "{{ protocols_dir }}/*/endpoints.yml"
      tags: always

    - name: "🔧 Load .env files"
      shell: |
        if [ -f "{{ item }}/.env" ]; then
          cat "{{ item }}/.env" | grep -v '^#' | grep '=' || true
        fi
      with_fileglob:
        - "{{ protocols_dir }}/*"
      register: env_contents
      tags: always

  tasks:
    # 🌐 HTTP/HTTPS Validation (1 task = all endpoints)
    - name: "🌐 HTTP/HTTPS Endpoints"
      uri:
        url: "{{ item.url }}"
        method: "{{ item.method | default('GET') }}"
        timeout: "{{ item.timeout | default(10) }}"
        status_code: "{{ item.expected_status | default(200) }}"
      loop: "{{ http_endpoints | default([]) }}"
      register: http_results
      failed_when: false
      tags: [http, web]

    # 💾 Database Validation (1 task per DB type)
    - name: "💾 PostgreSQL Connection"
      postgresql_ping: "{{ database_endpoints.postgres }}"
      register: postgres_result
      failed_when: false
      when: database_endpoints.postgres is defined
      tags: [database, postgres]

    - name: "💾 MySQL Connection"
      mysql_ping: "{{ database_endpoints.mysql }}"
      register: mysql_result
      failed_when: false
      when: database_endpoints.mysql is defined
      tags: [database, mysql]

    - name: "💾 MongoDB Connection"
      mongodb_ping: "{{ database_endpoints.mongodb }}"
      register: mongodb_result
      failed_when: false
      when: database_endpoints.mongodb is defined
      tags: [database, mongodb]

    - name: "💾 Redis Connection"
      redis: "{{ database_endpoints.redis }}"
      register: redis_result
      failed_when: false
      when: database_endpoints.redis is defined
      tags: [database, redis]

    # 📁 File System Validation
    - name: "📁 File System Paths"
      stat:
        path: "{{ item.path }}"
      loop: "{{ file_endpoints | default([]) }}"
      register: file_results
      tags: [filesystem, files]

    # 🔌 Network Services Validation
    - name: "🔌 Network Services"
      wait_for:
        host: "{{ item.host }}"
        port: "{{ item.port }}"
        timeout: "{{ item.timeout | default(5) }}"
        state: started
      loop: "{{ network_services | default([]) }}"
      register: network_results
      failed_when: false
      tags: [network, tcp]

    # 📧 Email Service Validation
    - name: "📧 SMTP Service"
      mail:
        to: "{{ email_config.to }}"
        subject: "Ansible Validation Test"
        body: "This is a test email from Ansible validation"
        host: "{{ email_config.host }}"
        port: "{{ email_config.port }}"
        username: "{{ email_config.username | default(omit) }}"
        password: "{{ email_config.password | default(omit) }}"
        secure: "{{ email_config.secure | default(omit) }}"
        dry_run: true
      register: email_result
      failed_when: false
      when: email_config is defined
      tags: [email, smtp]

    # 📊 Generate Validation Report
    - name: "📊 Generate HTML Report"
      template:
        src: "templates/report.html.j2"
        dest: "{{ playbook_dir }}/reports/validation_{{ inventory_hostname }}_{{ ansible_date_time.epoch }}.html"
      delegate_to: localhost
      run_once: true
      tags: [report]

    # 📋 Display Summary
    - name: "📋 Validation Summary"
      debug:
        msg: |
          🎯 ENDPOINT VALIDATION COMPLETED
          ================================
          Host: {{ inventory_hostname }}
          Environment: {{ env }}
          Timestamp: {{ ansible_date_time.iso8601 }}

          Results Summary:
          ✅ HTTP: {{ (http_results.results | default([]) | selectattr('status', 'equalto', 200) | list | length) }}/{{ (http_endpoints | default([]) | length) }}
          ✅ Files: {{ (file_results.results | default([]) | selectattr('stat.exists', 'equalto', true) | list | length) }}/{{ (file_endpoints | default([]) | length) }}
          ✅ Network: {{ (network_results.results | default([]) | rejectattr('failed', 'equalto', true) | list | length) }}/{{ (network_services | default([]) | length) }}
      tags: [summary]
EOF

    log "✅ Main playbook created"
}

# Create additional files
create_additional_files() {
    log "📄 Creating additional configuration files..."

    # Ansible configuration
    cat > ansible.cfg << 'EOF'
[defaults]
inventory = inventory.yml
host_key_checking = False
stdout_callback = community.general.yaml
timeout = 30
gathering = smart
fact_caching = memory
retry_files_enabled = False

[privilege_escalation]
become = False

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
pipelining = True
EOF

    # Inventory file
    cat > inventory.yml << 'EOF'
---
all:
  children:
    local:
      hosts:
        localhost:
          ansible_connection: local
          environment: dev

    development:
      hosts:
        dev-server-01:
          ansible_host: 10.0.1.10
          environment: dev

    staging:
      hosts:
        staging-server:
          ansible_host: 10.0.2.10
          environment: staging

    production:
      hosts:
        prod-server-01:
          ansible_host: 10.0.3.10
          environment: production
        prod-server-02:
          ansible_host: 10.0.3.11
          environment: production
EOF

    # Environment configurations
    cat > environments/dev.yml << 'EOF'
---
# Development Environment Configuration
environment_name: "Development"
api_timeout: 10
network_timeout: 5
enable_debug: true
report_format: "html"
EOF

    cat > environments/production.yml << 'EOF'
---
# Production Environment Configuration
environment_name: "Production"
api_timeout: 30
network_timeout: 10
enable_debug: false
report_format: "html"
strict_validation: true
EOF

    # Quick launcher script
    cat > validate.sh << 'EOF'
#!/bin/bash
# 🚀 Quick validation launcher

source venv/bin/activate
ansible-playbook validate_endpoints.yml \
  -e "environment=${1:-dev}" \
  -e "target_hosts=${2:-localhost}" \
  "${@:3}"
EOF

    chmod +x validate.sh

    log "✅ Additional files created"
}

# Main installation function
main() {
    show_banner
    log "🚀 Starting Ansible Endpoint Validator setup..."

    detect_os
    install_system_deps
    install_python_deps
    create_structure
    generate_protocol_configs
    create_main_playbook
    create_additional_files

    log "🎉 Setup completed successfully!"

    cat << EOF

┌─────────────────────────────────────────────────────────────┐
│  ✅ ANSIBLE ENDPOINT VALIDATOR READY!                      │
│                                                             │
│  🚀 Quick Start:                                           │
│     ./validate.sh                     # Validate dev env   │
│     ./validate.sh production          # Validate prod      │
│                                                             │
│  📊 Reports: ./reports/                                     │
│  ⚙️  Configs: ./protocols/*/                                │
│  🌍 Environments: ./environments/                          │
│                                                             │
│  📚 Full docs: ./README.md                                 │
└─────────────────────────────────────────────────────────────┘

EOF
}

# Execute main function
main "$@"