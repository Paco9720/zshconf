#!/usr/bin/env bash

set -e

# Detectar distro
if [ -f /etc/os-release ]; then
    . /etc/os-release
    distro=$ID
else
    echo "No se pudo detectar la distribución"
    exit 1
fi

echo "[*] Instalando fish..."

case "$distro" in
    opensuse*|suse|sles)
        sudo zypper install -y fish
        ;;
    debian|ubuntu|linuxmint)
        sudo apt update
        sudo apt install -y fish
        ;;
    fedora)
        sudo dnf install -y fish
        ;;
    arch)
        sudo pacman -Sy --noconfirm fish
        ;;
    *)
        echo "Distribución no soportada automáticamente. Instala fish manualmente."
        exit 1
        ;;
esac

# Verificar ruta de fish
FISH_PATH=$(command -v fish)
if [ -z "$FISH_PATH" ]; then
    echo "Error: fish no se instaló correctamente."
    exit 1
fi
echo "[*] Fish instalado en $FISH_PATH"

# Asegurarse de que esté en /etc/shells
if ! grep -q "$FISH_PATH" /etc/shells; then
    echo "[*] Agregando $FISH_PATH a /etc/shells"
    echo "$FISH_PATH" | sudo tee -a /etc/shells
fi

# Cambiar la shell por defecto
echo "[*] Cambiando shell por defecto a fish..."
chsh -s "$FISH_PATH"

# Crear función fish_prompt
CONFIG_DIR="$HOME/.config/fish/functions"
mkdir -p "$CONFIG_DIR"

cat > "$CONFIG_DIR/fish_prompt.fish" << 'EOF'
function fish_prompt
    set_color white
    echo -n "["(prompt_pwd)"]"
    set_color normal
    echo
    echo -n "> "
end
EOF

echo "[*] Prompt personalizado agregado."

echo
echo "✅ Instalación y configuración completa."
echo "ℹ️  Cierra la sesión y vuelve a entrar para que fish sea tu shell por defecto."

