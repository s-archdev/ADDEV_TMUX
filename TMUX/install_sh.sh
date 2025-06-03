#!/bin/sh
# cyberpunk-tmux installer - one-command setup
# chmod +x install.sh

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

log() {
    printf "${CYAN}[INFO]${NC} %s\n" "$1"
}

success() {
    printf "${GREEN}[SUCCESS]${NC} %s\n" "$1"
}

error() {
    printf "${RED}[ERROR]${NC} %s\n" "$1"
    exit 1
}

# Detect OS
detect_os() {
    if [ "$(uname)" = "Darwin" ]; then
        OS="macos"
        log "Detected macOS"
    elif [ -f /etc/debian_version ]; then
        OS="debian"
        log "Detected Debian-based Linux"
    elif [ -f /etc/arch-release ]; then
        OS="arch"
        log "Detected Arch Linux"
    elif [ -f /etc/fedora-release ]; then
        OS="fedora"
        log "Detected Fedora"
    else
        error "Unsupported OS. This installer works on macOS, Debian/Ubuntu, Arch, and Fedora only."
    fi
}

# Install packages based on OS
install_packages() {
    log "Installing required packages..."
    
    case $OS in
        macos)
            if ! command -v brew >/dev/null 2>&1; then
                log "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install git curl tmux python3 jq coreutils ripgrep emacs
            ;;
        debian)
            sudo apt-get update
            sudo apt-get install -y git curl tmux python3 jq coreutils ripgrep emacs-nox
            ;;
        arch)
            sudo pacman -Sy --noconfirm git curl tmux python jq coreutils ripgrep emacs-nox
            ;;
        fedora)
            sudo dnf install -y git curl tmux python3 jq coreutils ripgrep emacs-nox
            ;;
    esac
    success "Packages installed successfully"
}

# Install Doom Emacs
install_doom_emacs() {
    log "Installing Doom Emacs..."
    
    if [ -d "$HOME/.emacs.d" ]; then
        log "Backing up existing .emacs.d to .emacs.d.backup"
        mv "$HOME/.emacs.d" "$HOME/.emacs.d.backup"
    fi
    
    git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.emacs.d"
    "$HOME/.emacs.d/bin/doom" install --no-hooks
    
    # Create basic Doom config with doom-dracula theme
    mkdir -p "$HOME/.doom.d"
    cat > "$HOME/.doom.d/init.el" << 'EOF'
(doom! :input
       :completion
       company
       vertico
       
       :ui
       doom
       doom-dashboard
       doom-quit
       hl-todo
       modeline
       nav-flash
       ophints
       (popup +defaults)
       treemacs
       unicode
       vc-gutter
       vi-tilde-fringe
       workspaces
       zen
       
       :editor
       (evil +everywhere)
       file-templates
       fold
       (format +onsave)
       multiple-cursors
       rotate-text
       snippets
       
       :emacs
       dired
       electric
       ibuffer
       undo
       vc
       
       :term
       vterm
       
       :checkers
       syntax
       
       :tools
       direnv
       docker
       editorconfig
       (eval +overlay)
       gist
       lookup
       lsp
       magit
       make
       pass
       pdf
       prodigy
       rgb
       tmux
       upload
       
       :os
       (:if IS-MAC macos)
       tty
       
       :lang
       emacs-lisp
       json
       javascript
       markdown
       org
       python
       sh
       yaml
       
       :email
       
       :app
       
       :config
       literate
       (default +bindings +smartparens))
EOF

    cat > "$HOME/.doom.d/config.el" << 'EOF'
(setq doom-theme 'doom-dracula)
(setq display-line-numbers-type 'relative)
EOF
    
    "$HOME/.emacs.d/bin/doom" sync
    success "Doom Emacs installed with doom-dracula theme"
}

# Install TPM
install_tpm() {
    log "Installing TMUX Plugin Manager..."
    if [ -d "$HOME/.tmux/plugins/tpm" ]; then
        rm -rf "$HOME/.tmux/plugins/tpm"
    fi
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    success "TPM installed"
}

# Copy configuration files
copy_configs() {
    log "Copying configuration files..."
    
    # Copy .tmux.conf
    cp .tmux.conf "$HOME/.tmux.conf"
    
    # Create widgets directory and copy scripts
    mkdir -p "$HOME/.tmux/widgets"
    cp widgets/* "$HOME/.tmux/widgets/"
    chmod +x "$HOME/.tmux/widgets/"*
    
    success "Configuration files copied"
}

# Main installation
main() {
    printf "${MAGENTA}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════╗
    ║              CYBERPUNK TMUX INSTALLER             ║
    ║                   NEON EDITION                    ║
    ╚═══════════════════════════════════════════════════╝
EOF
    printf "${NC}\n"
    
    detect_os
    install_packages
    install_doom_emacs
    install_tpm
    copy_configs
    
    printf "${GREEN}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════╗
    ║                 INSTALLATION COMPLETE             ║
    ╚═══════════════════════════════════════════════════╝
EOF
    printf "${NC}\n"
    
    printf "${CYAN}Next steps:${NC}\n"
    printf "1. Start tmux: ${GREEN}tmux${NC}\n"
    printf "2. Install plugins: Press ${MAGENTA}Ctrl+b${NC} then ${MAGENTA}Shift+I${NC}\n"
    printf "3. Exit tmux: ${GREEN}exit${NC}\n"
    printf "4. Launch Doom Emacs: ${GREEN}emacs${NC}\n"
    printf "\nFor full documentation, see README.md\n"
}

main "$@"