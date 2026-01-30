#!/bin/bash
# EcoPower

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
        echo -e "${VERDE}Modo ECO: Desligando a GPU, limitando CPU e brilho...${RESET}"
        envycontrol -s integrated
        auto-cpufreq --force powersave
        auto-cpufreq --turbo never
        brightnessctl s 20%
        
	echo -e "${AZUL}Feito! É necessário reiniciar para desligar a GPU.${RESET}"
	read -p "Deseja reiniciar o sistema agora? (s/n): " confirm
        if [[ "$confirm" == [sS] ]]; then
            systemctl reboot
        fi
        ;;
        
    --power)
        echo -e "${AZUL}Modo POWER: Ativando Híbrido, Performance e Turbo...${RESET}"
        envycontrol -s hybrid
        auto-cpufreq --force performance
        auto-cpufreq --turbo auto
        brightnessctl s 80%
        echo -e "${VERDE}Feito! É necessário reiniciar para habilitar a GPU.${RESET}"
        read -p "Deseja reiniciar o sistema agora? (s/n): " confirm
        if [[ "$confirm" == [sS] ]]; then
            systemctl reboot
        fi
        ;;

    --status)
        auto-cpufreq --stats
        ;;

    *)
        echo "Uso: sudo ecopower [ --eco | --power | --status ]"
        ;;
esac
