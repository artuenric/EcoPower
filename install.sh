#!/bin/bash
# EcoPower Installer - Autor: Arthur Pimentel

VERDE='\033[0;32m'
AZUL='\033[0;34m'
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


# Identifica o usuário real para não instalar tudo na pasta do Root
REAL_USER=${SUDO_USER:-$USER}
USER_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

echo -e "${AZUL}Iniciando instalação do EcoPower...${RESET}"

# 1. Instalar dependências básicas do Sistema
echo "Instalando dependências via APT..."
sudo apt update && sudo apt install -y brightnessctl curl git python3

# 2. Instalar EnvyControl
if ! command -v envycontrol &> /dev/null; then
    echo "Instalando EnvyControl..."
    sudo curl -L https://raw.githubusercontent.com/bayasdev/envycontrol/main/envycontrol.py -o /usr/local/bin/envycontrol
    sudo chmod +x /usr/local/bin/envycontrol
fi

# 3. Instalar auto-cpufreq e ativar o Daemon
if ! command -v auto-cpufreq &> /dev/null; then
    echo "Instalando auto-cpufreq..."
    git clone https://github.com/AdnanHodzic/auto-cpufreq.git /tmp/auto-cpufreq-repo
    cd /tmp/auto-cpufreq-repo && sudo ./auto-cpufreq-installer --install
    cd - && rm -rf /tmp/auto-cpufreq-repo
else
    sudo auto-cpufreq --install
fi

# 4. Configurar o script principal
chmod +x ecopower.sh
sudo cp ecopower.sh /usr/local/bin/ecopower

# 5. Criar atalhos de Desktop na Home do Usuário Real
APP_DIR="$USER_HOME/.local/share/applications"
mkdir -p "$APP_DIR"

echo "Criando atalhos em $APP_DIR..."

cat <<EOF > "$APP_DIR/ecopower.desktop"
[Desktop Entry]
Name=EcoPower Control
Comment=Gerenciar Energia e GPU
Exec=gnome-terminal -- bash -c "/usr/local/bin/ecopower-menu.sh; exec bash"
Icon=power-profile-balanced-symbolic
Terminal=true
Type=Application
EOF

# Ajusta as permissões para o seu usuário ser o dono dos ícones
chown -R "$REAL_USER":"$REAL_USER" "$APP_DIR"/ecopower*
update-desktop-database "$APP_DIR"

echo -e "${VERDE}EcoPower instalado com sucesso! Procure por 'EcoPower' no menu de apps.${RESET}"
