#!/usr/bin/env bash
#
# Zsh & Oh My Zsh Kurulum ve Eklenti Yapılandırma Betiği
#

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}:: Zsh ve Oh My Zsh ortamı yapılandırılıyor...${NC}"

# 1. Oh My Zsh Kurulumu
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${GREEN}:: Oh My Zsh kuruluyor (unattended)...${NC}"
    KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${GREEN}:: Oh My Zsh zaten kurulu.${NC}"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# 2. Özel Eklentilerin Kurulumu
declare -A PLUGINS=(
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
    ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    ["zsh-completions"]="https://github.com/zsh-users/zsh-completions"
    ["zsh-history-substring-search"]="https://github.com/zsh-users/zsh-history-substring-search"
    ["zsh-autopair"]="https://github.com/hlissner/zsh-autopair"
)

mkdir -p "$ZSH_CUSTOM/plugins"

for plugin in "${!PLUGINS[@]}"; do
    if [ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
        echo -e "${GREEN}:: Eklenti indiriliyor: $plugin...${NC}"
        git clone --depth=1 "${PLUGINS[$plugin]}" "$ZSH_CUSTOM/plugins/$plugin" 2>/dev/null || {
            echo -e "${YELLOW}⚠️ Uyarı: $plugin klonlanamadı.${NC}"
        }
    else
        echo -e "${GREEN}:: Eklenti hazır: $plugin${NC}"
    fi
done

echo -e "${GREEN}✅ Zsh ve Oh My Zsh ortamı başarıyla hazırlandı.${NC}"
