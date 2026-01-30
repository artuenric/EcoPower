#!/bin/bash

# 1. Captura as saídas técnicas
GPU_STATE=$(envycontrol --query)
CPU_STATE=$(auto-cpufreq --get-state | grep "Currently using" | awk '{print $NF}')

# 2. Traduz para o "Linguajar EcoPower"
if [[ "$GPU_STATE" == "integrated" ]]; then
    STATUS_TEXT="${VERDE}ECO (Bateria)${RESET}"
elif [[ "$GPU_STATE" == "hybrid" ]]; then
    STATUS_TEXT="${AZUL}POWER (Desempenho)${RESET}"
else
    STATUS_TEXT="${AMARELO}Customizado / Desconhecido${RESET}"
fi

# 3. Interface Visual
clear
echo -e "${AZUL}=== EcoPower Manager ===${RESET}"
echo -e "MODO ATUAL: $STATUS_TEXT"
echo "---------------------------"
echo "1) Mudar para modo ECO (Bateria)"
echo "2) Mudar para modo POWER (Desempenho)"
echo "3) Ver estatísticas detalhadas (--status)"
echo "4) Sair"
echo "---------------------------"
read -p "Escolha uma opção [1-4]: " opcao

case $opcao in
    1) sudo ecopower --eco ;;
    2) sudo ecopower --power ;;
    3) ecopower --status; read -p "Pressione Enter para voltar..." ;;
    4) exit 0 ;;
    *) echo "Opção inválida." ; sleep 2 ;;
esac
