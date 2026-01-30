#!/bin/bash
# EcoPower Installer - Autor: Arthur Pimentel

VERDE='\033[0;32m'
AZUL='\033[0;34m'
VERMELHO='\033[0;31m'
RESET='\033[0m'

# Verificação de conflitos
conflitos=("optimus-manager" "prime-select" "bumblebee")

for app in "${conflitos[@]}"; do
    if command -v "$app" &> /dev/null; then
        echo -e "${VERMELHO}ERRO: Detectamos que o $app já está instalado.${RESET}"
        echo "Para evitar que seu sistema não inicie, remova-o antes de usar o EcoPower."
        exit 1
    fi
done

# Identifica o usuário real
REAL_USER=${SUDO_USER:-$USER}
USER_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

echo -e "${AZUL}Iniciando instalação do EcoPower...${RESET}"

# 1. Instalar dependências básicas
echo "Instalando dependências via APT..."
sudo apt update && sudo apt install -y brightnessctl curl git python3

# 2. Instalar EnvyControl
if ! command -v envycontrol &> /dev/null; then
    echo "Instalando EnvyControl..."
    sudo curl -L https://raw.githubusercontent.com/bayasdev/envycontrol/main/envycontrol.py -o /usr/local/bin/envycontrol
    sudo chmod +x /usr/local/bin/envycontrol
fi

# 3. Instalar auto-cpufreq
if ! command -v auto-cpufreq &> /dev/null; then
    echo "Instalando auto-cpufreq..."
    git clone https://github.com/AdnanHodzic/auto-cpufreq.git /tmp/auto-cpufreq-repo
    cd /tmp/auto-cpufreq-repo && sudo ./auto-cpufreq-installer --install
    cd - && rm -rf /tmp/auto-cpufreq-repo
else
    sudo auto-cpufreq --install
fi

# 4. Configurar binários (Removendo extensões para padrão Linux)
chmod +x ecopower.sh
chmod +x ecopower-menu.sh
sudo cp ecopower.sh /usr/local/bin/ecopower
sudo cp ecopower-menu.sh /usr/local/bin/ecopower-menu

# 5. Criar atalho de Desktop corrigido
APP_DIR="$USER_HOME/.local/share/applications"
mkdir -p "$APP_DIR"

cat <<EOF > "$APP_DIR/ecopower.desktop"
[Desktop Entry]
Name=EcoPower Control
Comment=Gerenciar Energia e GPU
Exec=gnome-terminal -- bash -c "sudo /usr/local/bin/ecopower-menu; exec bash"
Icon=power-profile-balanced-symbolic
Terminal=true
Type=Application
EOF

chown -R "$REAL_USER":"$REAL_USER" "$APP_DIR"/ecopower*
update-desktop-database "$APP_DIR"

echo -e "${VERDE}EcoPower instalado com sucesso!${RESET}"
