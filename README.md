# Dev Environment Configuration

Development environment configuration files for macOS and Ubuntu.

## Features

- **Shell**: Zsh with Oh My Zsh and Powerlevel10k theme
- **Terminal Multiplexer**: Tmux with custom Catppuccin theme
- **Editor**: Neovim with custom Lua configuration
- **Terminal**: Alacritty and Ghostty configuration
- **CLI Tools**: fzf, fd, bat, eza, zoxide, ripgrep, lazygit

## Quick Installation

### macOS

Run this command to automatically set up your development environment:

```bash
curl -fsSL https://raw.githubusercontent.com/tonmoy0010/dev-environment-files/main/install-macos.sh | bash
```

Or clone and run manually:

```bash
git clone https://github.com/tonmoy0010/dev-environment-files.git
cd dev-environment-files
chmod +x install-macos.sh
./install-macos.sh
```

### Ubuntu/Debian

Run this command to automatically set up your development environment:

```bash
curl -fsSL https://raw.githubusercontent.com/tonmoy0010/dev-environment-files/main/install-ubuntu.sh | bash
```

Or clone and run manually:

```bash
git clone https://github.com/tonmoy0010/dev-environment-files.git
cd dev-environment-files
chmod +x install-ubuntu.sh
./install-ubuntu.sh
```

## What Gets Installed

### Package Managers
- **macOS**: Homebrew
- **Ubuntu**: apt-get

### CLI Tools
- `neovim` - Modern Vim-based text editor
- `tmux` - Terminal multiplexer
- `fzf` - Fuzzy finder
- `fd` - Fast alternative to find
- `bat` - Cat clone with syntax highlighting
- `eza` - Modern ls replacement
- `zoxide` - Smarter cd command
- `ripgrep` - Fast grep alternative
- `lazygit` - Terminal UI for git commands
- `git` - Version control
- `gpg` - GNU Privacy Guard
- `yara` - Pattern matching tool
- `exiftool` - Metadata reader/writer

### Shell & Themes
- Oh My Zsh
- Powerlevel10k theme
- zsh-autosuggestions plugin
- zsh-syntax-highlighting plugin

### Tmux Plugins (via TPM)
- tmux-sensible
- tmux-resurrect
- tmux-continuum
- tmux-yank

## Post-Installation

After running the installation script:

1. **Restart your terminal** or run:
   ```bash
   source ~/.zshrc
   ```

2. **Install Tmux plugins**:
   - Open tmux: `tmux`
   - Press `Ctrl+a` then `Shift+I` to install plugins

3. **Neovim plugins**:
   - Open nvim: `nvim`
   - Plugins should auto-install on first launch

4. **Optional**: Configure Powerlevel10k:
   ```bash
   p10k configure
   ```

## Configuration Files

- `.zshrc` - Zsh configuration
- `.tmux.conf` - Tmux configuration
- `.config/nvim/` - Neovim configuration
- `.config/alacritty/` - Alacritty terminal configuration
- `.config/ghostty/` - Ghostty terminal configuration

## Ubuntu Notes

- The script creates symlinks for `fd` and `bat` commands in `~/.local/bin`
- Clipboard support uses `xclip` (installed automatically)
- If you want GUI apps like Alacritty, install separately:
  ```bash
  sudo add-apt-repository ppa:aslatter/ppa
  sudo apt update
  sudo apt install alacritty
  ```

## macOS Notes

- On Apple Silicon Macs, Homebrew is installed to `/opt/homebrew`
- Clipboard support uses `pbcopy` (built-in)
- If you want Alacritty, install via Homebrew:
  ```bash
  brew install --cask alacritty
  ```

## Manual Package Installation

### macOS
```bash
brew install bat eza ripgrep fd tldr delta dust procs btop lazygit zoxide fzf git jq tmux vim nvim
```

### Ubuntu
```bash
sudo apt-get install git curl wget build-essential zsh tmux ripgrep neovim fd-find bat

# lazygit (install from GitHub releases)
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit lazygit.tar.gz
```

## Keyboard Bindings

### Tmux

**Prefix Key**: `Ctrl+a` (instead of default `Ctrl+b`)

#### Session & Window Management
- `prefix + r` - Reload tmux configuration
- `prefix + c` - Create new window
- `prefix + |` - Split pane vertically
- `prefix + -` - Split pane horizontally

#### Navigation (Vim-style, no prefix needed)
- `Ctrl+h` - Move to left pane
- `Ctrl+j` - Move to down pane
- `Ctrl+k` - Move to up pane
- `Ctrl+l` - Move to right pane

#### Resize Panes
- `prefix + h` - Resize pane left
- `prefix + j` - Resize pane down
- `prefix + k` - Resize pane up
- `prefix + l` - Resize pane right

#### Copy Mode (Vi-style)
- `prefix + [` - Enter copy mode
- `v` - Begin selection (in copy mode)
- `y` - Copy selection (in copy mode)
- Mouse drag + `y` - Select and copy text

#### Plugin Manager
- `prefix + Shift+I` - Install TPM plugins
- `prefix + U` - Update plugins
- `prefix + Alt+u` - Uninstall plugins

---

### Neovim

**Leader Key**: `Space`

#### General
- `jk` - Exit insert mode (alternative to ESC)
- `<leader>nh` - Clear search highlights

#### Numbers
- `<leader>+` - Increment number under cursor
- `<leader>-` - Decrement number under cursor

#### Window Management
- `<leader>sv` - Split window vertically
- `<leader>sh` - Split window horizontally
- `<leader>se` - Make splits equal size
- `<leader>sx` - Close current split

#### Tab Management
- `<leader>to` - Open new tab
- `<leader>tx` - Close current tab
- `<leader>tn` - Go to next tab
- `<leader>tp` - Go to previous tab
- `<leader>tf` - Open current buffer in new tab

#### File Explorer (nvim-tree)
- `<leader>ee` - Toggle file explorer
- `<leader>ef` - Toggle file explorer on current file
- `<leader>ec` - Collapse file explorer
- `<leader>er` - Refresh file explorer

#### Fuzzy Finder (Telescope)
- `<leader>ff` - Find files in current directory
- `<leader>fr` - Find recent files
- `<leader>fs` - Live grep (search string in project)
- `<leader>fc` - Find string under cursor
- `<leader>ft` - Find TODO comments
- `<leader>fk` - Find keymaps
- `<leader>fz` - Find directories with zoxide

**Telescope Navigation (in picker):**
- `Ctrl+k` - Move to previous result
- `Ctrl+j` - Move to next result
- `Ctrl+q` - Send selected to quickfix list
- `Ctrl+t` - Open in Trouble

#### LSP (Language Server)
- `gR` - Show references
- `gD` - Go to declaration
- `gd` - Go to definition
- `gi` - Show implementations
- `gt` - Show type definitions
- `K` - Show hover documentation
- `<leader>ca` - Show code actions
- `<leader>rn` - Rename symbol
- `<leader>D` - Show diagnostics for file
- `<leader>d` - Show diagnostics for current line
- `[d` - Go to previous diagnostic
- `]d` - Go to next diagnostic
- `<leader>rs` - Restart LSP server

#### Diagnostics & Errors (Trouble)
- `<leader>xx` - Toggle diagnostics list
- `<leader>xw` - Toggle workspace diagnostics
- `<leader>xd` - Toggle document diagnostics
- `<leader>xq` - Toggle quickfix list
- `<leader>xl` - Toggle location list
- `<leader>xt` - Toggle TODO comments in Trouble

#### TODO Comments
- `]t` - Next TODO comment
- `[t` - Previous TODO comment

#### Git (LazyGit)
- `<leader>lg` - Open LazyGit interface

---

### Zsh & CLI Tools

#### FZF (Fuzzy Finder)
- `Ctrl+T` - Fuzzy find files in current directory
- `Ctrl+R` - Fuzzy search command history
- `Alt+C` - Fuzzy change directory

#### Zoxide (Smart cd)
- `z <partial-path>` - Jump to a directory (e.g., `z proj`)
- `zi` - Interactive directory selection

#### General Zsh
- `ESC ESC` - Add `sudo` to current command (sudo plugin)

---

## License

MIT License - See LICENSE file for details