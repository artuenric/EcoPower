#!/bin/bash
# EcoPower Uninstaller - Autor: Arthur Pimentel

VERMELHO='\033[0;31m'
VERDE='\033[0;32m'
RESET='\033[0m'

if [[ $EUID -ne 0 ]]; then
   echo -e "${VERMELHO}Este script precisa de sudo para remover os arquivos do sistema.${RESET}"
   exit 1
fi

echo -e "${VERMELHO}Iniciando a remoção do EcoPower...${RESET}"

# 1. Voltar o hardware ao estado padrão antes de desinstalar
echo "Restaurando configurações padrão de hardware..."
# Garante que a GPU volte ao modo híbrido
envycontrol -s hybrid --force 2>/dev/null 
# Reseta o auto-cpufreq para o modo automático
auto-cpufreq --force reset 2>/dev/null

# 2. Remover o daemon do auto-cpufreq e o software
if command -v auto-cpufreq &> /dev/null; then
    echo "Removendo auto-cpufreq..."
    sudo auto-cpufreq --remove
fi

# 3. Remover binários e atalhos
echo "Limpando arquivos do sistema..."
rm -f /usr/local/bin/ecopower
rm -f /usr/local/bin/envycontrol
rm -f ~/.local/share/applications/ecopower-eco.desktop
rm -f ~/.local/share/applications/ecopower-power.desktop

# 4. Reativar o serviço padrão do GNOME (que o auto-cpufreq desativa)
echo "Reativando o Power Profiles Daemon do GNOME..."
systemctl unmask power-profiles-daemon
systemctl start power-profiles-daemon

echo -e "${VERDE}EcoPower removido com sucesso!${RESET}"
echo "Recomendamos reiniciar o sistema para normalizar os drivers de vídeo."
