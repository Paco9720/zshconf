#!/bin/bash

# Script de instalación y configuración de Fish para Fedora
# Cambia el shell para el usuario actual y para root
# Instala el prompt personalizado que pediste

echo "Instalando Fish..."
sudo dnf install -y fish

# Añadir fish a /etc/shells si no está
if ! grep -q "/usr/bin/fish" /etc/shells; then
    echo "Agregando /usr/bin/fish a /etc/shells"
    echo "/usr/bin/fish" | sudo tee -a /etc/shells
fi

# Cambiar shell para el usuario actual
echo "Cambiando shell del usuario actual a fish..."
chsh -s /usr/bin/fish

# Cambiar shell para root
echo "Cambiando shell de root a fish..."
sudo chsh -s /usr/bin/fish root

# Crear configuración de Fish
echo "Creando configuración de Fish..."

mkdir -p ~/.config/fish/functions

# Configuración general de Fish (config.fish)
cat << 'EOF' > ~/.config/fish/config.fish
if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Autostart X en tty1 si no hay DISPLAY
if test -z "$DISPLAY" -a (tty) = "/dev/tty1"
    exec startx
end
EOF

# Crear función del prompt
cat << 'EOF' > ~/.config/fish/functions/fish_prompt.fish
function fish_prompt
    # Directorio actual en azul
    set_color blue
    echo -n "["(prompt_pwd)"]"

    # Información de Git
    set_color red
    echo -n (fish_git_prompt)

    # Restaurar color
    set_color normal

    # Salto de línea
    echo
    echo -n "> "
end
EOF

echo "Fish instalado y configurado correctamente."
echo "Cierra sesión o reinicia tu terminal para aplicar los cambios."

