# 🌆 CYBERPUNK TMUX
## Neon-Styled Terminal Cockpit + Doom Emacs

A complete cyberpunk-themed development environment featuring a neon-styled TMUX configuration with system monitoring widgets and a fully configured Doom Emacs setup.

![Cyberpunk TMUX Screenshot](screenshot.png)
*Screenshot placeholder - your terminal will look like this after installation*

## ⚡ Quick Start

### One-Command Installation
```bash
git clone https://github.com/yourusername/cyberpunk-tmux.git
cd cyberpunk-tmux
chmod +x install.sh
./install.sh
```

### Post-Installation Steps
1. Start TMUX: `tmux`
2. Install plugins: Press `Ctrl+b` then `Shift+I`
3. Wait for plugins to install, then exit: `exit`
4. Launch Doom Emacs: `emacs`

## 🎨 Theme Features

### Color Palette
- **Background**: `#0d0d0d` (Deep Black)
- **Neon Green**: `#00ff9c` (Active elements)
- **Neon Magenta**: `#ff0066` (Highlights)
- **Text Base**: `#c0c0c0` (Primary text)

### Status Bar Layout
**Left Side**: Session name | Window list | Git branch
**Right Side**: CPU/Memory | Network Speed | Battery | Weather | BTC Price | Time

## 🎯 Key Bindings

### TMUX Shortcuts
| Key Combination | Action |
|----------------|--------|
| `Ctrl+b` | Prefix key |
| `Ctrl+b` + `r` | Reload configuration |
| `Ctrl+b` + `\|` | Split window horizontally |
| `Ctrl+b` + `-` | Split window vertically |
| `Ctrl+b` + `h/j/k/l` | Navigate panes (Vim-style) |
| `Ctrl+b` + `H/J/K/L` | Resize panes |
| `Ctrl+b` + `c` | New window |
| `Ctrl+b` + `N` | New session |
| `Ctrl+b` + `X` | Kill session |
| `Ctrl+b` + `S` | Synchronize panes |
| `Ctrl+b` + `b` | Toggle status bar |
| `Alt+h/l` | Previous/Next window |

### Copy Mode (Vi-style)
| Key | Action |
|-----|--------|
| `Ctrl+b` + `Enter` | Enter copy mode |
| `v` | Begin selection |
| `y` | Copy selection |
| `r` | Rectangle selection |

### Plugin Shortcuts
| Key Combination | Action |
|----------------|--------|
| `Ctrl+b` + `Shift+I` | Install plugins |
| `Ctrl+b` + `Shift+U` | Update plugins |
| `Ctrl+b` + `Tab` | Toggle sidebar |
| `Ctrl+b` + `Ctrl+s` | Save session |
| `Ctrl+b` + `Ctrl+r` | Restore session |

## 📊 Widget Information

### System Monitoring
- **CPU/Memory**: Real-time usage with color indicators
- **Network**: Upload/download speeds in real-time
- **Battery**: Percentage and charging status
- **Weather**: Current temperature and conditions
- **Crypto**: Bitcoin price (BTC/USD)
- **Git**: Current branch and repository status

### Widget Status Indicators
- 🟢 **Green**: Normal/Good (< 60%)
- 🟡 **Yellow**: Warning (60-80%)
- 🔴 **Red**: Critical (> 80%)

## 🔄 Session Management

### Auto-Save & Restore
Sessions are automatically saved every 15 minutes and restored on startup thanks to `tmux-resurrect` and `tmux-continuum`.

### Manual Save/Restore
- **Save**: `Ctrl+b` + `Ctrl+s`
- **Restore**: `Ctrl+b` + `Ctrl+r`

### Session Resurrection
The configuration captures:
- Window layouts
- Active panes
- Working directories
- Running programs
- Pane contents

## 🛠️ Customization

### Modifying Colors
Edit `.tmux.conf` and change the color variables:
```bash
BG_BLACK="#0d0d0d"
NEON_GREEN="#00ff9c"
NEON_MAGENTA="#ff0066"
TEXT_BASE="#c0c0c0"
```

### Adding Widgets
1. Create a new script in `~/.tmux/widgets/`
2. Make it executable: `chmod +x ~/.tmux/widgets/your_widget.sh`
3. Add it to the status bar in `.tmux.conf`

### Widget Customization
Each widget can be customized by editing its script:
- `battery.sh`: Battery display format
- `cpu_mem.sh`: CPU/memory thresholds
- `crypto.sh`: Cryptocurrency symbol
- `git_branch.sh`: Git status indicators
- `net_speed.sh`: Network interface selection
- `weather.sh`: Location and units

## 🎮 Doom Emacs Integration

### Pre-configured Features
- **Theme**: doom-dracula (matching TMUX colors)
- **Evil Mode**: Vim keybindings
- **LSP**: Language Server Protocol support
- **Magit**: Git integration
- **Treemacs**: File explorer
- **Company**: Auto-completion
- **Vertico**: Enhanced minibuffer

### Doom Commands
```bash
~/.emacs.d/bin/doom sync    # Sync configuration
~/.emacs.d/bin/doom upgrade # Upgrade Doom
~/.emacs.d/bin/doom doctor  # Check for issues
```

## 🔧 Troubleshooting

### Common Issues

**TMUX plugins not working**
- Ensure TPM is installed: `ls ~/.tmux/plugins/tpm`
- Install plugins: `Ctrl+b` + `Shift+I`

**Widgets showing "N/A"**
- Check internet connection for weather/crypto widgets
- Verify required tools are installed (acpi, curl, jq)

**Colors not displaying correctly**
- Ensure terminal supports 256 colors
- Set `TERM=screen-256color` in your shell

**Doom Emacs not starting**
- Run `~/.emacs.d/bin/doom doctor` for diagnostics
- Check Emacs installation: `emacs --version`

### Widget Debugging
Run widgets manually to test:
```bash
~/.tmux/widgets/battery.sh
~/.tmux/widgets/weather.sh
~/.tmux/widgets/crypto.sh
```

### Reset Configuration
```bash
./uninstall.sh
./install.sh
```

## 📋 Requirements

### Supported Systems
- macOS (with Homebrew)
- Debian/Ubuntu Linux
- Arch Linux
- Fedora Linux

### Dependencies
Automatically installed by the installer:
- git
- curl
- tmux
- python3
- jq
- coreutils
- ripgrep
- emacs (or emacs-nox)

## 🚀 Updates

### Updating Plugins
```bash
# In TMUX
Ctrl+b + Shift+U
```

### Updating Doom Emacs
```bash
~/.emacs.d/bin/doom upgrade
```

### Updating Cyberpunk TMUX
```bash
cd cyberpunk-tmux
git pull origin main
./install.sh  # Re-run installer
```

## 🗑️ Uninstallation

To completely remove cyberpunk-tmux:
```bash
chmod +x uninstall.sh
./uninstall.sh
```

This removes:
- TMUX configuration and plugins
- Doom Emacs and configuration
- All widget scripts

Note: TMUX and Emacs packages remain installed.

## 📄 License

MIT License - see LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 🙏 Acknowledgments

- [TMUX Plugin Manager](https://github.com/tmux-plugins/tpm)
- [Doom Emacs](https://github.com/doomemacs/doomemacs)
- [wttr.in](https://wttr.in) for weather data
- [Binance API](https://binance-docs.github.io/apidocs/) for crypto prices

## 📞 Support

- Create an issue for bugs or feature requests
- Check the troubleshooting section first
- Include your OS and error messages

---

**Made with 💜 for the cyberpunk aesthetic**