#!/bin/bash

# Tradução do Status para o usuário
GPU_STATE=$(envycontrol --query)
if [[ "$GPU_STATE" == "integrated" ]]; then
    STATUS="MODO ATUAL: ECO (Bateria)"
elif [[ "$GPU_STATE" == "hybrid" ]]; then
    STATUS="MODO ATUAL: POWER (Desempenho)"
else
    STATUS="MODO ATUAL: Desconhecido"
fi

# Cria o menu interativo com Whiptail
CHOICE=$(whiptail --title "EcoPower Manager" --menu "$STATUS\n\nUse as setas para navegar e Enter para selecionar:" 15 60 4 \
"1" "Ativar MODO ECO (Bateria)" \
"2" "Ativar MODO POWER (Desempenho)" \
"3" "Ver Estatísticas (--status)" \
"4" "Sair" 3>&1 1>&2 2>&3)

# Lógica baseada na escolha
case $CHOICE in
    1) sudo ecopower --eco ;;
    2) sudo ecopower --power ;;
    3) ecopower --status | whiptail --title "Status do Sistema" --scrolltext --msgbox "$(cat -)" 20 70 ;;
    4) exit 0 ;;
esac
