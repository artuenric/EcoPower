#!/bin/bash
# EcoPower Uninstaller

VERMELHO='\033[0;31m'
VERDE='\033[0;32m'
RESET='\033[0m'

if [[ $EUID -ne 0 ]]; then
   echo -e "${VERMELHO}Precisa de sudo.${RESET}"
   exit 1
fi

# Restaurar padrões
envycontrol -s hybrid --force 2>/dev/null 
auto-cpufreq --remove 2>/dev/null

# Remover ficheiros instalados
rm -f /usr/local/bin/ecopower
rm -f /usr/local/bin/ecopower-menu

REAL_USER=${SUDO_USER:-$USER}
USER_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)
APP_DIR="$USER_HOME/.local/share/applications"

rm -f "$APP_DIR"/ecopower*
update-desktop-database "$APP_DIR" 2>/dev/null

systemctl unmask power-profiles-daemon
systemctl start power-profiles-daemon

echo -e "${VERDE}Removido com sucesso.${RESET}"
