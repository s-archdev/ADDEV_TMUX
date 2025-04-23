#!/bin/bash
# ADDEV_TMUX - Ultimate TMUX setup for Mac
# Created by: [Your Name]
# GitHub: https://github.com/[username]/ADDEV_TMUX

# Directory Setup
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_DIR="$SCRIPT_DIR/config"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"
ASSETS_DIR="$SCRIPT_DIR/assets"

# Ensure required directories exist
mkdir -p "$CONFIG_DIR" "$SCRIPTS_DIR" "$ASSETS_DIR"

# Check for tmux installation
if ! command -v tmux >/dev/null 2>&1; then
    echo "TMUX is not installed! Installing..."
    if command -v brew >/dev/null 2>&1; then
        brew install tmux
    else
        echo "Homebrew not found. Please install Homebrew first or install TMUX manually."
        exit 1
    fi
fi

# Check for required tools and install if needed
required_tools=("glances" "htop" "ncdu" "neofetch" "jq" "bat" "exa" "fzf" "ripgrep")
for tool in "${required_tools[@]}"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "Installing $tool..."
        brew install "$tool"
    fi
done

# Create ASCII logo file if not exists
if [ ! -f "$ASSETS_DIR/addev_logo.txt" ]; then
    cp "$SCRIPT_DIR/ascii.txt" "$ASSETS_DIR/addev_logo.txt"
fi

# Create or update tmux configuration
cat > "$CONFIG_DIR/tmux.conf" << 'EOF'
# ADDEV TMUX Configuration

# Basic Settings
set -g default-terminal "screen-256color"
set -g history-limit 20000
set -g buffer-limit 20
set -g status-interval 5
set -g mouse on

# Start windows and panes at 1, not 0
set -g base-index 1
setw -g pane-base-index 1

# Automatically renumber windows when closing
set -g renumber-windows on

# Keybindings
# Remap prefix from 'C-b' to 'C-a'
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# Split panes using | and -
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
unbind '"'
unbind %

# Reload config file
bind r source-file ~/.tmux.conf \; display "Configuration Reloaded!"

# Switch panes using Alt-arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Resize panes
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Visual Styling
# Status bar
set -g status-style bg=black,fg=white
set -g status-left "#[fg=green]#H #[fg=white]• #[fg=green,bright]#(uname -r)#[default]"
set -g status-left-length 50
set -g status-right "#[fg=yellow,bg=black]#(uptime | cut -f 4-5 -d ' ' | cut -f 1 -d ',') #[fg=white,bg=black]• #[fg=green,bg=black]%a %d-%m-%Y #[fg=white]• #[fg=green,bg=black]%H:%M:%S#[default]"
set -g status-right-length 60

# Window status
setw -g window-status-current-style fg=white,bold,bg=blue
setw -g window-status-style fg=cyan,bg=black

# Pane border
set -g pane-border-style fg=green,bg=black
set -g pane-active-border-style fg=white,bg=black

# Message text
set -g message-style fg=white,bold,bg=black

# Mode style (copy mode)
setw -g mode-style fg=white,bold,bg=blue
EOF

# Create session launcher script
cat > "$SCRIPTS_DIR/launch_session.sh" << 'EOF'
#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
ASSETS_DIR="$PARENT_DIR/assets"

SESSION_NAME="ADDEV"

# If the session exists, attach to it
if tmux has-session -t $SESSION_NAME 2>/dev/null; then
    tmux attach-session -t $SESSION_NAME
    exit 0
fi

# Create a new session with a window for the ADDEV logo
tmux new-session -d -s $SESSION_NAME -n "ADDEV Logo"

# Display the ADDEV logo in the first window
tmux send-keys -t $SESSION_NAME:1 "cat $ASSETS_DIR/addev_logo.txt && echo '\n\n ADDEV TMUX Environment - Press Ctrl+a ? for help' && sleep 1" C-m

# Create a window for system monitoring with Glances
tmux new-window -t $SESSION_NAME:2 -n "System Monitor"
tmux send-keys -t $SESSION_NAME:2 "glances" C-m

# Create a window for file exploration
tmux new-window -t $SESSION_NAME:3 -n "Files"
tmux send-keys -t $SESSION_NAME:3 "cd ~ && clear && exa -la --git --header" C-m

# Create a development window with split panes
tmux new-window -t $SESSION_NAME:4 -n "Dev"
tmux split-window -h -t $SESSION_NAME:4
tmux split-window -v -t $SESSION_NAME:4.1

# Create a notes/scratch window
tmux new-window -t $SESSION_NAME:5 -n "Notes"

# Select the logo window initially
tmux select-window -t $SESSION_NAME:1

# Attach to the session
tmux attach-session -t $SESSION_NAME
EOF

# Make scripts executable
chmod +x "$SCRIPTS_DIR/launch_session.sh"

# Create main launcher
cat > "$SCRIPT_DIR/addev-tmux" << 'EOF'
#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_DIR="$SCRIPT_DIR/config"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"

# Link tmux config if needed
if [ ! -f "$HOME/.tmux.conf" ] || [ ! -L "$HOME/.tmux.conf" ]; then
    # Backup existing configuration if it exists
    if [ -f "$HOME/.tmux.conf" ]; then
        echo "Backing up existing tmux configuration to ~/.tmux.conf.backup"
        cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup"
    fi
    echo "Linking ADDEV TMUX configuration to ~/.tmux.conf"
    ln -sf "$CONFIG_DIR/tmux.conf" "$HOME/.tmux.conf"
fi

# Launch the TMUX session
bash "$SCRIPTS_DIR/launch_session.sh"
EOF

chmod +x "$SCRIPT_DIR/addev-tmux"

echo "ADDEV TMUX setup is complete!"
echo "Run ./addev-tmux to start your TMUX environment"
