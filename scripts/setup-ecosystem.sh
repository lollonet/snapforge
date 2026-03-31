#!/bin/bash
#
# SnapForge Ecosystem Setup Script
# Downloads and sets up all SnapForge components
#

set -e

GITHUB_ORG="lollonet"
INSTALL_DIR="${SNAPFORGE_DIR:-$HOME/snapforge}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_banner() {
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║   ███████╗███╗   ██╗ █████╗ ██████╗ ███████╗ ██████╗     ║"
    echo "║   ██╔════╝████╗  ██║██╔══██╗██╔══██╗██╔════╝██╔═══██╗    ║"
    echo "║   ███████╗██╔██╗ ██║███████║██████╔╝█████╗  ██║   ██║    ║"
    echo "║   ╚════██║██║╚██╗██║██╔══██║██╔═══╝ ██╔══╝  ██║   ██║    ║"
    echo "║   ███████║██║ ╚████║██║  ██║██║     ██║     ╚██████╔╝    ║"
    echo "║   ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝      ╚═════╝     ║"
    echo "║                                                           ║"
    echo "║           Open-Source Multiroom Audio Ecosystem           ║"
    echo "║                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_dependencies() {
    log_info "Checking dependencies..."

    local missing=()

    if ! command -v git &> /dev/null; then
        missing+=("git")
    fi

    if ! command -v docker &> /dev/null; then
        log_warn "Docker not found - required for server/client deployment"
    fi

    if [ ${#missing[@]} -gt 0 ]; then
        log_error "Missing required dependencies: ${missing[*]}"
        exit 1
    fi

    log_info "All required dependencies found"
}

clone_repo() {
    local repo=$1
    local target=$2

    if [ -d "$target" ]; then
        log_warn "$target already exists, skipping..."
        return 0
    fi

    log_info "Cloning $repo..."
    git clone "https://github.com/${GITHUB_ORG}/${repo}.git" "$target"
}

setup_server() {
    log_info "Setting up snapMULTI (server)..."

    clone_repo "snapMULTI" "$INSTALL_DIR/server"

    if [ -d "$INSTALL_DIR/server" ]; then
        cd "$INSTALL_DIR/server"
        if [ -f ".env.example" ]; then
            if [ ! -f ".env" ]; then
                cp .env.example .env
                log_info "Created .env from template - please edit with your settings"
            fi
        fi
    fi
}

setup_client() {
    log_info "Setting up SnapClient Pi (client)..."

    clone_repo "snapclient-pi" "$INSTALL_DIR/client"
}

setup_controller() {
    log_warn "SnapCTRL is distributed separately and is not provisioned by this public setup script"
}

print_summary() {
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}                   Setup Complete!                         ${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Components installed in: $INSTALL_DIR"
    echo ""
    echo "  📦 Server:     $INSTALL_DIR/server"
    echo "  📦 Client:     $INSTALL_DIR/client"
    echo "  📦 Controller: not provisioned by this public script"
    echo ""
    echo "Next steps:"
    echo ""
    echo "  1. Configure the server:"
    echo "     cd $INSTALL_DIR/server"
    echo "     nano .env  # Set your music library paths"
    echo "     docker compose up -d"
    echo ""
    echo "  2. Set up SnapClient Pi endpoints (on Raspberry Pi):"
    echo "     cd $INSTALL_DIR/client"
    echo "     ./scripts/setup.sh"
    echo ""
    echo "  3. Use the built-in web UI first:"
    echo "     open http://<server-ip>:1780"
    echo ""
    echo "  4. Native controller and mobile client availability varies by platform"
    echo ""
    echo "Documentation: https://github.com/${GITHUB_ORG}/snapforge"
    echo ""
}

main() {
    print_banner

    echo "This script will set up the SnapForge open platform."
    echo "Install directory: $INSTALL_DIR"
    echo ""
    read -p "Continue? [Y/n] " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo "Aborted."
        exit 0
    fi

    check_dependencies

    mkdir -p "$INSTALL_DIR"

    setup_server
    setup_client
    setup_controller

    print_summary
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dir)
            INSTALL_DIR="$2"
            shift 2
            ;;
        --server-only)
            main() {
                print_banner
                check_dependencies
                mkdir -p "$INSTALL_DIR"
                setup_server
                print_summary
            }
            shift
            ;;
        --client-only)
            main() {
                print_banner
                check_dependencies
                mkdir -p "$INSTALL_DIR"
                setup_client
                print_summary
            }
            shift
            ;;
        --controller-only)
            main() {
                print_banner
                check_dependencies
                mkdir -p "$INSTALL_DIR"
                setup_controller
                print_summary
            }
            shift
            ;;
        -h|--help)
            echo "SnapForge Ecosystem Setup"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --dir PATH         Install directory (default: ~/snapforge)"
            echo "  --server-only      Install only the server component"
            echo "  --client-only      Install only the client component"
            echo "  --controller-only  Print controller availability note only"
            echo "  -h, --help         Show this help message"
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

main
