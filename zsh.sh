#!/bin/bash

# Script para instalar ZSH + plugins + iniciar sesión en TTY1 con dwm
# Funciona en openSUSE Tumbleweed

echo "=== Instalando paquetes necesarios ==="
sudo zypper install -y zsh git curl

echo "=== Instalando plugins de ZSH ==="
sudo zypper install -y zsh-autosuggestions zsh-syntax-highlighting zsh-completions

echo "=== Instalando Oh My Zsh ==="
# Instalar oh-my-zsh sin intervención
export RUNZSH=no
export CHSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "=== Configurando ~/.zshrc ==="

cat > ~/.zshrc << 'EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
)

source $ZSH/oh-my-zsh.sh

# Plugins externos instalados vía paquetes
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Opciones útiles
setopt AUTO_CD
setopt HIST_IGNORE_DUPS
setopt HIST_VERIFY

echo "=== Cambiando el shell por defecto a zsh ==="
chsh -s /usr/bin/zsh

echo "=== Instalación completa ==="
echo "Cierra sesión y vuelve a entrar en la TTY"

