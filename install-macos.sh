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

echo_info "Starting macOS development environment setup."

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo_info "Installing Homebrew."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo_info "Homebrew already installed, skipping."
fi

# Update Homebrew
echo_info "Updating Homebrew."
brew update

# Install packages
PACKAGES=(
    "neovim"
    "tmux"
    "fzf"
    "fd"
    "bat"
    "eza"
    "zoxide"
    "git"
    "gpg"
    "ripgrep"
    "wget"
    "curl"
    "yara"
    "exiftool"
    "lazygit"
)

echo_info "Installing CLI tools."
for package in "${PACKAGES[@]}"; do
    if brew list "$package" &>/dev/null; then
        echo_info "$package already installed, skipping."
    else
        echo_info "Installing $package."
        brew install "$package"
    fi
done

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

# Copy Ghostyy config
if [ -d "$SCRIPT_DIR/.config/ghostty" ]; then
    mkdir -p "$HOME/.config/ghostty"
    cp -r "$SCRIPT_DIR/.config/ghostty/"* "$HOME/.config/ghostty/"
fi

# Copy Neovim config
if [ -d "$SCRIPT_DIR/.config/nvim" ]; then
    mkdir -p "$HOME/.config/nvim"
    cp -r "$SCRIPT_DIR/.config/nvim/"* "$HOME/.config/nvim/"
fi

# Set zsh as default shell if not already
if [ "$SHELL" != "$(which zsh)" ]; then
    echo_info "Setting zsh as default shell."
    chsh -s "$(which zsh)"
else
    echo_info "zsh is already the default shell, skipping."
fi

# Install fzf key bindings and fuzzy completion
if [ -f "$(brew --prefix)/opt/fzf/install" ]; then
    echo_info "Installing fzf key bindings."
    "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc
fi

echo_info "Setup complete!"
echo_warning "Please restart your terminal or run 'source ~/.zshrc' to apply changes."
echo_warning "For tmux plugins, open tmux and press 'prefix + I' (Ctrl+a then Shift+I) to install plugins."
echo_warning "For Neovim plugins, open nvim and they should auto-install on first launch."
