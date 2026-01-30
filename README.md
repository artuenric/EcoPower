# 🌿 EcoPower Manager

O EcoPower é uma suíte de scripts para Linux projetada especificamente para notebooks gamer híbridos 
(como o Acer Nitro V15). Ele gerencia a alternância entre economia extrema de bateria e performance máxima, controlando a GPU NVIDIA e o Governor da CPU em um único lugar. 

Para isso, o projeto integra o [EnvyControl](https://github.com/bayasdev/envycontrol), que manipula o initramfs para desativar a GPU dedicada, e o [auto-cpufreq](https://github.com/AdnanHodzic/auto-cpufreq), 
que ajusta dinamicamente os estados da CPU e o Turbo Boost.

## Funcionalidades
- **Modo ECO:** Desliga a GPU NVIDIA, limita o Turbo Boost da CPU.
- **Modo POWER:** Ativa a GPU NVIDIA (modo híbrido), libera o clock da CPU.
- **Interface TUI:** Menu interativo navegável pelas setas do teclado.
- **Atalho Desktop:** Inicie o gerenciador diretamente do seu menu de aplicativos.

## Requisitos
- Notebook com gráficos híbridos (Intel/AMD + NVIDIA).
- Sistema Baseado em Debian/Ubuntu (Debian, Pop!_OS, Mint, Zorin, etc).
- Gerenciador de janelas GNOME (para suporte total aos atalhos).

## Instalação

Primeiro, garanta que você tem o `git` instalado:
```
Bash
sudo apt update && sudo apt install git -y
```
Agora, clone o repositório e execute o instalador:
```
Bash
# Clone o projeto
git clone https://github.com/artuenric/EcoPower.git

# Acesse a pasta
cd EcoPower

# Dê permissão de execução ao instalador
chmod +x install.sh

# Rode a instalação
sudo ./install.sh

```

## Usando
Após a instalação, basta procurar por "EcoPower" no seu menu de aplicativos. Uma janela de terminal abrirá com o menu interativo.

Nota: Ao trocar de modo (ECO <-> POWER), o sistema solicitará o reinício para aplicar as mudanças de driver da GPU.

## Desinstalação
Se desejar remover o EcoPower e restaurar as configurações padrão do sistema:
```
Bash
sudo chmod +x uninstall.sh
sudo ./uninstall.sh
```
## Licença
Distribuído sob a licença MIT. Veja LICENSE para mais informações.

Desenvolvido por Arthur Pimentel 🚀
