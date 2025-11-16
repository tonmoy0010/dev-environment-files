#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

echo_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

echo_info "Starting Ubuntu development environment setup."

# Update package lists
echo_info "Updating package lists."
sudo apt-get update

# Install basic dependencies
echo_info "Installing basic dependencies."
PACKAGES=(
    "git"
    "curl"
    "wget"
    "build-essential"
    "zsh"
    "tmux"
    "ripgrep"
    "unzip"
    "software-properties-common"
    "gpg"
    "xclip"  # For clipboard support in tmux
)

for package in "${PACKAGES[@]}"; do
    if dpkg -l | grep -q "^ii  $package "; then
        echo_info "$package already installed, skipping."
    else
        echo_info "Installing $package."
        sudo apt-get install -y "$package"
    fi
done

# Install Neovim (latest stable version)
if ! command -v nvim &> /dev/null; then
    echo_info "Installing Neovim."
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install -y neovim
else
    echo_info "Neovim already installed, skipping."
fi

# Install fd (fd-find)
if ! command -v fd &> /dev/null && ! command -v fdfind &> /dev/null; then
    echo_info "Installing fd."
    sudo apt-get install -y fd-find
    # Create symlink for fd command
    mkdir -p ~/.local/bin
    ln -sf $(which fdfind) ~/.local/bin/fd
else
    echo_info "fd already installed, skipping."
fi

# Install bat (batcat)
if ! command -v bat &> /dev/null && ! command -v batcat &> /dev/null; then
    echo_info "Installing bat."
    sudo apt-get install -y bat
    # Create symlink for bat command
    mkdir -p ~/.local/bin
    ln -sf /usr/bin/batcat ~/.local/bin/bat
else
    echo_info "bat already installed, skipping."
fi

# Install fzf
if ! command -v fzf &> /dev/null; then
    echo_info "Installing fzf."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --key-bindings --completion --no-update-rc
else
    echo_info "fzf already installed, skipping."
fi

# Install eza (modern ls replacement)
if ! command -v eza &> /dev/null; then
    echo_info "Installing eza."
    # Install eza from its repository
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt-get update
    sudo apt-get install -y eza
else
    echo_info "eza already installed, skipping."
fi

# Install zoxide
if ! command -v zoxide &> /dev/null; then
    echo_info "Installing zoxide."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
else
    echo_info "zoxide already installed, skipping."
fi

# Install lazygit
if ! command -v lazygit &> /dev/null; then
    echo_info "Installing lazygit."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
else
    echo_info "lazygit already installed, skipping."
fi

# Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo_info "Installing Oh My Zsh."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo_info "Oh My Zsh already installed, skipping."
fi

# Install Powerlevel10k theme
if [ ! -d "${HOME}/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo_info "Installing Powerlevel10k theme."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${HOME}/.oh-my-zsh/custom/themes/powerlevel10k
else
    echo_info "Powerlevel10k already installed, skipping."
fi

# Install zsh-autosuggestions
if [ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    echo_info "Installing zsh-autosuggestions."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions
else
    echo_info "zsh-autosuggestions already installed, skipping."
fi

# Install zsh-syntax-highlighting
if [ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    echo_info "Installing zsh-syntax-highlighting."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
else
    echo_info "zsh-syntax-highlighting already installed, skipping."
fi

# Install TPM (Tmux Plugin Manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo_info "Installing Tmux Plugin Manager."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo_info "TPM already installed, skipping."
fi

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Copy config files
echo_info "Copying configuration files."

# Copy .zshrc
echo_info "Copying .zshrc."
cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"

# Copy .tmux.conf
echo_info "Copying .tmux.conf."
cp "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"

# Copy .config directory contents
echo_info "Copying .config files."
mkdir -p "$HOME/.config"

# Copy Alacritty config
if [ -d "$SCRIPT_DIR/.config/alacritty" ]; then
    mkdir -p "$HOME/.config/alacritty"
    cp -r "$SCRIPT_DIR/.config/alacritty/"* "$HOME/.config/alacritty/"
fi

# Copy Ghostty config
if [ -d "$SCRIPT_DIR/.config/ghostty" ]; then
    mkdir -p "$HOME/.config/ghostty"
    cp -r "$SCRIPT_DIR/.config/ghostty/"* "$HOME/.config/ghostty/"
fi

# Copy Neovim config
if [ -d "$SCRIPT_DIR/.config/nvim" ]; then
    mkdir -p "$HOME/.config/nvim"
    cp -r "$SCRIPT_DIR/.config/nvim/"* "$HOME/.config/nvim/"
fi

# Add ~/.local/bin to PATH if not already in .zshrc
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.zshrc"; then
    echo_info "Adding ~/.local/bin to PATH."
    echo '' >> "$HOME/.zshrc"
    echo '# Local bin directory' >> "$HOME/.zshrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
fi

# Set zsh as default shell if not already
if [ "$SHELL" != "$(which zsh)" ]; then
    echo_info "Setting zsh as default shell."
    chsh -s "$(which zsh)"
else
    echo_info "zsh is already the default shell, skipping."
fi

echo_info "Setup complete!"
echo_warning "Please log out and log back in for the shell change to take effect."
echo_warning "Or run 'source ~/.zshrc' to apply changes in the current terminal."
echo_warning "For tmux plugins, open tmux and press 'prefix + I' (Ctrl+a then Shift+I) to install plugins."
echo_warning "For Neovim plugins, open nvim and they should auto-install on first launch."
echo_warning "Note: You may need to update the .tmux.conf to use 'xclip' instead of 'pbcopy' for clipboard functionality."
