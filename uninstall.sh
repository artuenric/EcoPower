#!/bin/bash
# EcoPower Uninstaller - Autor: Arthur Pimentel

VERMELHO='\033[0;31m'
VERDE='\033[0;32m'
RESET='\033[0m'

if [[ $EUID -ne 0 ]]; then
   echo -e "${VERMELHO}Este script precisa de sudo para remover os arquivos do sistema.${RESET}"
   exit 1
fi

echo -e "${VERMELHO}Iniciando a remoção completa do EcoPower...${RESET}"

# 1. Restaurar o Hardware ao estado original
echo "Restaurando configurações de fábrica..."
envycontrol -s hybrid --force 2>/dev/null 
auto-cpufreq --force reset 2>/dev/null

# 2. Desinstalar o daemon do auto-cpufreq
if command -v auto-cpufreq &> /dev/null; then
    echo "Removendo serviço auto-cpufreq..."
    auto-cpufreq --remove
fi

# 3. Remover binários (Motor e Menu)
echo "Removendo binários em /usr/local/bin..."
rm -f /usr/local/bin/ecopower
rm -f /usr/local/bin/ecopower-menu.sh

# 4. Remover Atalhos de Desktop
# Identifica o usuário real para limpar a pasta correta
REAL_USER=${SUDO_USER:-$USER}
USER_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)
APP_DIR="$USER_HOME/.local/share/applications"

echo "Limpando atalhos em $APP_DIR..."
rm -f "$APP_DIR/ecopower.desktop"
rm -f "$APP_DIR/ecopower-eco.desktop"    # Limpa o antigo, se existir
rm -f "$APP_DIR/ecopower-power.desktop"  # Limpa o antigo, se existir

# 5. Reativar o serviço padrão do GNOME
echo "Reativando Power Profiles Daemon..."
systemctl unmask power-profiles-daemon
systemctl start power-profiles-daemon

update-desktop-database "$APP_DIR" 2>/dev/null

echo -e "${VERDE}EcoPower foi totalmente removido.${RESET}"
echo "Recomendamos reiniciar para que os drivers de vídeo voltem ao padrão."
