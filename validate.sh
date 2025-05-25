#!/bin/bash
set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Project configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$PROJECT_DIR/venv"
PLAYBOOK="validate_endpoints.yml"

# Helper functions
log() { echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# Banner
show_banner() {
    cat << 'EOF'
┌─────────────────────────────────────────────────────────────┐
│  🎯 ANSIBLE ENDPOINT VALIDATOR                              │
│  📧 Tom Sapletta | tom.sapletta.com                         │
│  🔍 Minimalist validation for 10+ protocols                 │
└─────────────────────────────────────────────────────────────┘
EOF
}

# Check prerequisites
check_setup() {
    if [[ ! -d "$VENV_DIR" ]]; then
        error "Virtual environment not found. Run ./setup.sh first."
        exit 1
    fi

    if [[ ! -f "$PLAYBOOK" ]]; then
        error "Playbook not found. Run ./setup.sh first."
        exit 1
    fi
}

# Load environment variables from protocol configs
load_protocol_envs() {
    log "🔧 Loading protocol configurations..."

    for env_file in protocols/*/.env; do
        if [[ -f "$env_file" ]]; then
            protocol=$(basename $(dirname "$env_file"))
            info "Loading $protocol configuration"
            set -a
            source "$env_file"
            set +a
        fi
    done
}

# Show help
show_help() {
    cat << EOF
🎯 Ansible Endpoint Validator - Usage

SYNOPSIS:
    $0 [ENVIRONMENT] [TARGETS] [OPTIONS]

PARAMETERS:
    ENVIRONMENT    Target environment (dev|staging|production|local)
                   Default: dev

    TARGETS        Target hosts or groups (localhost|all|production)
                   Default: localhost

OPTIONS:
    --tags TAG     Run specific protocol tags (http,database,files,network)
    --check        Dry run mode (don't make changes)
    --verbose      Verbose output (-vvv)
    --limit HOST   Limit to specific hosts
    --help         Show this help

EXAMPLES:
    $0                           # Validate dev environment on localhost
    $0 production               # Validate production environment
    $0 dev all --tags http      # Only HTTP endpoints on all dev hosts
    $0 staging --check          # Dry run on staging
    $0 local --verbose          # Verbose local validation

PROTOCOLS SUPPORTED:
    🌐 HTTP/HTTPS    📁 File System    🔌 Network Services
    💾 Databases     📧 Email SMTP     📡 FTP/SFTP
    ☁️  Cloud APIs    📊 Message Queues 🔐 LDAP/AD
    🚀 Containers    🎯 Custom Scripts

CONFIGURATION:
    Edit files in protocols/*/         Protocol-specific configs
    Edit environments/*.yml           Environment-specific settings
    Edit inventory.yml               Target hosts and groups

REPORTS:
    📊 HTML reports: ./reports/
    📋 JSON output:  Add --extra-vars "report_format=json"

MORE INFO:
    📚 Documentation: ./README.md
    🌐 Website: https://tom.sapletta.com
    📧 Support: tom@sapletta.com
EOF
}

# Main validation function
run_validation() {
    local environment="${1:-dev}"
    local targets="${2:-localhost}"
    shift 2 || true
    local extra_args="$@"

    log "🎯 Starting endpoint validation..."
    info "Environment: $environment"
    info "Targets: $targets"

    # Activate virtual environment
    source "$VENV_DIR/bin/activate"

    # Load protocol configurations
    load_protocol_envs

    # Build ansible-playbook command
    local ansible_cmd=(
        "ansible-playbook"
        "$PLAYBOOK"
        "-e" "environment=$environment"
        "-e" "target_hosts=$targets"
        "-i" "inventory.yml"
    )

    # Add extra arguments
    if [[ -n "$extra_args" ]]; then
        ansible_cmd+=($extra_args)
    fi

    # Execute validation
    log "🚀 Executing: ${ansible_cmd[*]}"
    "${ansible_cmd[@]}"

    # Show results
    if [[ $? -eq 0 ]]; then
        log "✅ Validation completed successfully!"
        info "📊 Check reports in: ./reports/"

        # Find latest report
        latest_report=$(ls -t reports/*.html 2>/dev/null | head -1)
        if [[ -n "$latest_report" ]]; then
            info "📄 Latest report: $latest_report"

            # Try to open in browser (macOS/Linux)
            if command -v open >/dev/null 2>&1; then
                info "🌐 Opening report in browser..."
                open "$latest_report"
            elif command -v xdg-open >/dev/null 2>&1; then
                info "🌐 Opening report in browser..."
                xdg-open "$latest_report"
            fi
        fi
    else
        error "❌ Validation failed!"
        exit 1
    fi
}

# Parse command line arguments
main() {
    case "${1:-}" in
        --help|-h)
            show_help
            exit 0
            ;;
        --version|-v)
            echo "Ansible Endpoint Validator v1.0.0"
            exit 0
            ;;
    esac

    show_banner
    check_setup
    run_validation "$@"
}

# Execute main function
main "$@"
