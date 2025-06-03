# ╔═══════════════════════════════════════════════════╗
# ║                CYBERPUNK TMUX CONFIG              ║
# ║                   NEON EDITION                    ║
# ╚═══════════════════════════════════════════════════╝

# ═══════════════════════════════════════════════════════════════════════════════
# CORE SETTINGS
# ═══════════════════════════════════════════════════════════════════════════════

# Set prefix to Ctrl-b (default, but explicit)
set -g prefix C-b
unbind C-a

# Reload config
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# Enable mouse support
set -g mouse on

# Fix colors and enable 256 color support
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",*256col*:Tc"

# Start windows and panes at 1, not 0
set -g base-index 1
setw -g pane-base-index 1

# Renumber windows sequentially after closing any of them
set -g renumber-windows on

# Increase scrollback buffer size
set -g history-limit 50000

# Display tmux messages for 4 seconds
set -g display-time 4000

# Focus events enabled for terminals that support them
set -g focus-events on

# Super useful when using "grouped sessions" and multi-monitor setup
setw -g aggressive-resize on

# ═══════════════════════════════════════════════════════════════════════════════
# CYBERPUNK COLOR SCHEME
# ═══════════════════════════════════════════════════════════════════════════════

# Color palette
BG_BLACK="#0d0d0d"
NEON_GREEN="#00ff9c"
NEON_MAGENTA="#ff0066"
TEXT_BASE="#c0c0c0"
DARK_GRAY="#1a1a1a"
MID_GRAY="#333333"
LIGHT_GRAY="#666666"

# ═══════════════════════════════════════════════════════════════════════════════
# PANE SETTINGS
# ═══════════════════════════════════════════════════════════════════════════════

# Pane border colors
set -g pane-border-style fg=$LIGHT_GRAY
set -g pane-active-border-style fg=$NEON_GREEN

# Split panes using | and -
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
unbind '"'
unbind %

# Vim-style pane navigation
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Pane resizing
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# ═══════════════════════════════════════════════════════════════════════════════
# WINDOW SETTINGS
# ═══════════════════════════════════════════════════════════════════════════════

# New window in current path
bind c new-window -c "#{pane_current_path}"

# Window navigation
bind -n M-h previous-window
bind -n M-l next-window

# ═══════════════════════════════════════════════════════════════════════════════
# STATUS BAR CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════════

# Status bar position and refresh
set -g status-position bottom
set -g status-interval 5

# Status bar colors
set -g status-style bg=$BG_BLACK,fg=$TEXT_BASE

# Status bar length
set -g status-left-length 100
set -g status-right-length 100

# Left status: session name, window list, git branch
set -g status-left "#[fg=$NEON_MAGENTA,bold]  #S #[fg=$LIGHT_GRAY]│ "
set -g status-left-style fg=$NEON_MAGENTA

# Right status: system info
set -g status-right "#[fg=$LIGHT_GRAY]#(~/.tmux/widgets/cpu_mem.sh) #[fg=$LIGHT_GRAY]│ #[fg=$NEON_GREEN]#(~/.tmux/widgets/net_speed.sh) #[fg=$LIGHT_GRAY]│ #[fg=$NEON_MAGENTA]#{battery_percentage} #{battery_status_bg} #[fg=$LIGHT_GRAY]│ #[fg=$TEXT_BASE]#(~/.tmux/widgets/weather.sh) #[fg=$LIGHT_GRAY]│ #[fg=$NEON_GREEN]#(~/.tmux/widgets/crypto.sh) #[fg=$LIGHT_GRAY]│ #[fg=$NEON_MAGENTA,bold]%H:%M"

# Window status format
setw -g window-status-format "#[fg=$LIGHT_GRAY] #I:#W "
setw -g window-status-current-format "#[fg=$NEON_GREEN,bold] #I:#W #[fg=$TEXT_BASE]#(~/.tmux/widgets/git_branch.sh) "

# Activity monitoring
setw -g monitor-activity on
set -g visual-activity off
setw -g window-status-activity-style fg=$NEON_MAGENTA

# ═══════════════════════════════════════════════════════════════════════════════
# COPY MODE SETTINGS
# ═══════════════════════════════════════════════════════════════════════════════

# Vi-style copy mode
setw -g mode-keys vi

# Copy mode bindings
bind Enter copy-mode
bind -T copy-mode-vi v send-keys -X begin-selection
bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
bind -T copy-mode-vi r send-keys -X rectangle-toggle

# ═══════════════════════════════════════════════════════════════════════════════
# PLUGIN CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════════

# Plugin list
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'tmux-plugins/tmux-prefix-highlight'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tmux-battery'
set -g @plugin 'tmux-plugins/tmux-net-speed'
set -g @plugin 'tmux-plugins/tmux-cpu'
set -g @plugin 'tmux-plugins/tmux-open'
set -g @plugin 'tmux-plugins/tmux-sidebar'

# Plugin configurations
set -g @resurrect-capture-pane-contents 'on'
set -g @continuum-restore 'on'
set -g @continuum-boot 'on'

# Battery plugin colors
set -g @batt_color_status_primary_charged $NEON_GREEN
set -g @batt_color_status_primary_charging $NEON_MAGENTA
set -g @batt_color_status_primary_discharging $NEON_MAGENTA

# Net speed format
set -g @net_speed_format "↑%10s ↓%10s"

# CPU format
set -g @cpu_low_fg_color $NEON_GREEN
set -g @cpu_medium_fg_color $NEON_MAGENTA
set -g @cpu_high_fg_color $NEON_MAGENTA

# Prefix highlight
set -g @prefix_highlight_fg $BG_BLACK
set -g @prefix_highlight_bg $NEON_MAGENTA
set -g @prefix_highlight_show_copy_mode 'on'
set -g @prefix_highlight_copy_mode_attr "fg=$BG_BLACK,bg=$NEON_GREEN"

# Sidebar
set -g @sidebar-tree-command 'tree -C'
set -g @sidebar-tree-position 'right'

# ═══════════════════════════════════════════════════════════════════════════════
# CUSTOM KEYBINDINGS
# ═══════════════════════════════════════════════════════════════════════════════

# Quick window/session management
bind N new-session
bind X confirm-before -p "Kill session #S? (y/n)" kill-session

# Synchronize panes
bind S setw synchronize-panes

# Clear screen and history
bind C-l send-keys 'C-l' \; clear-history

# Toggle status bar
bind b set-option status

# Nested tmux session support
bind -n C-q send-prefix

# ═══════════════════════════════════════════════════════════════════════════════
# INITIALIZE TMUX PLUGIN MANAGER
# ═══════════════════════════════════════════════════════════════════════════════

# Keep this line at the very bottom of tmux.conf
run '~/.tmux/plugins/tpm/tpm'