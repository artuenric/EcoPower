#!/bin/bash
# EcoPower Engine

VERDE='\033[0;32m'
AZUL='\033[0;34m'
VERMELHO='\033[0;31m'
RESET='\033[0m'

if [[ $EUID -ne 0 ]]; then
   echo -e "${VERMELHO}Este script precisa de sudo.${RESET}"
   exit 1
fi

case "$1" in
    --eco)
        echo -e "${VERDE}Modo ECO: Desligando a GPU, limitando CPU...${RESET}"
        envycontrol -s integrated --force
        auto-cpufreq --force powersave
        auto-cpufreq --turbo never
        brightnessctl s 20%
        read -p "Reiniciar agora? (s/n): " confirm
        [[ "$confirm" == [sS] ]] && systemctl reboot
        ;;
    --power)
        echo -e "${AZUL}Modo POWER: Ativando GPU Híbrida...${RESET}"
        envycontrol -s hybrid --force
        auto-cpufreq --force performance
        auto-cpufreq --turbo auto
        brightnessctl s 80%
        read -p "Reiniciar agora? (s/n): " confirm
        [[ "$confirm" == [sS] ]] && systemctl reboot
        ;;
    --status)
        auto-cpufreq --stats
        ;;
    *)
        echo "Uso: sudo ecopower [ --eco | --power | --status ]"
        ;;
esac
