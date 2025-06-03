# =============================================================================
# ~/.tmux.conf - Minimal tmux configuration with black theme and custom bindings
# =============================================================================

# Basic shell and terminal settings
set-option -g default-shell /bin/bash
set-option -g default-terminal "screen-256color"

# Change prefix from Ctrl+b to Ctrl+a
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# Mouse and copy mode settings
set-option -g mouse on
setw -g mode-keys vi

# Black background theme for all UI elements
set-option -g status-style "bg=black,fg=white"
set-option -g pane-border-style "fg=white"
set-option -g pane-active-border-style "fg=white"
set-option -g message-style "bg=black,fg=white"
set-option -g window-status-style "bg=black,fg=white"
set-option -g window-status-current-style "bg=black,fg=white,bold"

# Custom key bindings
bind-key e split-window -v -p 40 'emacs'
bind-key h split-window -h -p 50 'htop'
bind-key n split-window -p 20 'clock -t'
bind-key r source-file ~/.tmux.conf \; display-message "Config reloaded!"

# Auto-start session with emacs daemon
new-session -d -s main 'emacs --daemon'

# =============================================================================
# ONE-LINE INSTALLER SCRIPT
# =============================================================================

# Run this command to install tmux, emacs, create config, and launch tmux:
# sudo apt update && sudo apt install -y tmux emacs && cat > ~/.tmux.conf << 'EOF' && (tmux has-session -t main 2>/dev/null && tmux attach -t main || tmux new -s main)
# [Paste the above ~/.tmux.conf content between the EOF markers in actual use]

# =============================================================================
# COMPLETE INSTALLER SCRIPT (alternative to one-liner)
# =============================================================================

#!/bin/bash
# Install dependencies, create config, and launch tmux

# Install tmux and emacs if not present
sudo apt update && sudo apt install -y tmux emacs

# Write tmux configuration
cat > ~/.tmux.conf << 'EOF'
set-option -g default-shell /bin/bash
set-option -g default-terminal "screen-256color"
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix
set-option -g mouse on
setw -g mode-keys vi
set-option -g status-style "bg=black,fg=white"
set-option -g pane-border-style "fg=white"
set-option -g pane-active-border-style "fg=white"
set-option -g message-style "bg=black,fg=white"
set-option -g window-status-style "bg=black,fg=white"
set-option -g window-status-current-style "bg=black,fg=white,bold"
bind-key e split-window -v -p 40 'emacs'
bind-key h split-window -h -p 50 'htop'
bind-key n split-window -p 20 'clock -t'
bind-key r source-file ~/.tmux.conf \; display-message "Config reloaded!"
new-session -d -s main 'emacs --daemon'
EOF

# Launch or attach to tmux session
tmux has-session -t main 2>/dev/null && tmux attach -t main || tmux new -s main