#!/bin/sh
# cyberpunk-tmux uninstaller
# chmod +x uninstall.sh

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    printf "${CYAN}[INFO]${NC} %s\n" "$1"
}

warn() {
    printf "${YELLOW}[WARNING]${NC} %s\n" "$1"
}

success() {
    printf "${GREEN}[SUCCESS]${NC} %s\n" "$1"
}

# Confirmation prompt
confirm() {
    printf "${YELLOW}Are you sure you want to uninstall cyberpunk-tmux? (y/N): ${NC}"
    read -r response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            return 0
            ;;
        *)
            log "Uninstall cancelled"
            exit 0
            ;;
    esac
}

# Remove files
remove_files() {
    log "Removing cyberpunk-tmux files..."
    
    # Remove tmux config
    if [ -f "$HOME/.tmux.conf" ]; then
        rm "$HOME/.tmux.conf"
        log "Removed ~/.tmux.conf"
    fi
    
    # Remove TPM
    if [ -d "$HOME/.tmux/plugins/tpm" ]; then
        rm -rf "$HOME/.tmux/plugins/tpm"
        log "Removed ~/.tmux/plugins/tpm"
    fi
    
    # Remove widgets
    if [ -d "$HOME/.tmux/widgets" ]; then
        rm -rf "$HOME/.tmux/widgets"
        log "Removed ~/.tmux/widgets"
    fi
    
    # Remove remaining tmux plugins directory if empty
    if [ -d "$HOME/.tmux/plugins" ] && [ -z "$(ls -A "$HOME/.tmux/plugins")" ]; then
        rmdir "$HOME/.tmux/plugins"
        log "Removed empty ~/.tmux/plugins"
    fi
    
    if [ -d "$HOME/.tmux" ] && [ -z "$(ls -A "$HOME/.tmux")" ]; then
        rmdir "$HOME/.tmux"
        log "Removed empty ~/.tmux"
    fi
    
    # Remove Doom Emacs
    if [ -d "$HOME/.emacs.d" ]; then
        rm -rf "$HOME/.emacs.d"
        log "Removed ~/.emacs.d (Doom Emacs)"
    fi
    
    if [ -d "$HOME/.doom.d" ]; then
        rm -rf "$HOME/.doom.d"
        log "Removed ~/.doom.d"
    fi
    
    # Restore backup if it exists
    if [ -d "$HOME/.emacs.d.backup" ]; then
        mv "$HOME/.emacs.d.backup" "$HOME/.emacs.d"
        log "Restored ~/.emacs.d from backup"
    fi
}

main() {
    printf "${RED}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════╗
    ║             CYBERPUNK TMUX UNINSTALLER           ║
    ╚═══════════════════════════════════════════════════╝
EOF
    printf "${NC}\n"
    
    warn "This will remove:"
    warn "  • ~/.tmux.conf"
    warn "  • ~/.tmux/plugins/tpm"
    warn "  • ~/.tmux/widgets/"
    warn "  • ~/.emacs.d (Doom Emacs)"
    warn "  • ~/.doom.d"
    printf "\n"
    warn "TMUX and Emacs packages will remain installed."
    printf "\n"
    
    confirm
    remove_files
    
    printf "${GREEN}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════╗
    ║              UNINSTALL COMPLETE                   ║
    ╚═══════════════════════════════════════════════════╝
EOF
    printf "${NC}\n"
    
    success "cyberpunk-tmux has been removed from your system"
    log "To reinstall, run: ./install.sh"
}

main "$@"