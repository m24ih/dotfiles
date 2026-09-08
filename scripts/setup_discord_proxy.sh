#!/bin/bash

# ==========================================
# Discord Secure Tunnel & Config Setup
# ==========================================
# Melih'in VDS Altyapısı ve Discord Proxy Yapılandırması
# ==========================================

# --- Değişkenler ---
VDS_HOST="doAMS"
VDS_IP="206.189.108.220"
VDS_USER="root"
WRAPPER_PATH="$HOME/.local/bin/discord-secure"
DESKTOP_ENTRY="$HOME/.local/share/applications/discord.desktop"
SSH_CONFIG="$HOME/.ssh/config"
DISCORD_CONFIG="$HOME/.config/discord/settings.json"

# Renkli Çıktılar
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}>>> Discord Tünel ve Yapılandırma Kurulumu Başlatılıyor...${NC}"

# ------------------------------------------
# 1. SSH Config Yapılandırması (1Password & VDS)
# ------------------------------------------
echo -e "${GREEN}1. SSH Config ayarlanıyor...${NC}"
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Config dosyasında doAMS var mı kontrol et
if grep -q "Host $VDS_HOST" "$SSH_CONFIG"; then
  echo "   - $VDS_HOST zaten ssh config içinde mevcut."
else
  echo "   - $VDS_HOST ekleniyor..."
  cat <<EOF >>"$SSH_CONFIG"

# 1Password Agent & VDS Config (Added by script)
Host *
    IdentityAgent ~/.1password/agent.sock

Host $VDS_HOST
    HostName $VDS_IP
    User $VDS_USER
    ForwardAgent yes
EOF
  echo "   - SSH Config güncellendi."
fi

# ------------------------------------------
# 2. Discord Wrapper Script Oluşturma
# ------------------------------------------
echo -e "${GREEN}2. Wrapper Script ($WRAPPER_PATH) oluşturuluyor...${NC}"
mkdir -p "$HOME/.local/bin"

cat <<EOF >"$WRAPPER_PATH"
#!/bin/bash
# Discord Secure Launcher
# Checks for SSH tunnel on port 1080, starts it if missing, then launches Discord.

PORT=1080
HOST="$VDS_HOST"

# Tünel Kontrolü
if ! ss -lptn "sport = :\$PORT" | grep -q "\$PORT"; then
    echo "🌍 Tünel kapalı, \$HOST üzerinden bağlantı kuruluyor..."
    # 1Password onayı isteyecektir
    ssh -f -N -D \$PORT \$HOST
    sleep 2
else
    echo "✅ Tünel zaten aktif."
fi

echo "🚀 Discord başlatılıyor..."
/usr/bin/discord --proxy-server="socks5://127.0.0.1:\$PORT" "\$@" &
EOF

chmod +x "$WRAPPER_PATH"
echo "   - Wrapper script hazır ve çalıştırılabilir yapıldı."

# ------------------------------------------
# 3. Discord Desktop Entry Düzenleme
# ------------------------------------------
echo -e "${GREEN}3. Masaüstü Kısayolu (Desktop Entry) ayarlanıyor...${NC}"
mkdir -p "$HOME/.local/share/applications"

if [ -f "/usr/share/applications/discord.desktop" ]; then
  cp /usr/share/applications/discord.desktop "$DESKTOP_ENTRY"
  # Exec satırını bizim script ile değiştir
  sed -i "s|Exec=/usr/bin/discord|Exec=$WRAPPER_PATH|g" "$DESKTOP_ENTRY"
  sed -i "s|Exec=/usr/share/discord/Discord|Exec=$WRAPPER_PATH|g" "$DESKTOP_ENTRY"
  echo "   - Discord kısayolu, wrapper script'i kullanacak şekilde güncellendi."
else
  echo -e "${RED}   - HATA: Discord kurulu değil veya .desktop dosyası bulunamadı!${NC}"
fi

# ------------------------------------------
# 4. Discord settings.json (Update Loop Fix)
# ------------------------------------------
echo -e "${GREEN}4. Discord 'SKIP_HOST_UPDATE' ayarı yapılıyor...${NC}"

if [ -f "$DISCORD_CONFIG" ]; then
  # Dosya varsa ve ayar yoksa ekle
  if ! grep -q "SKIP_HOST_UPDATE" "$DISCORD_CONFIG"; then
    # Basit bir sed hilesi: son süslü parantezi bulup öncesine ayarı ekler
    # Not: JSON yapısı çok karmaşıksa jq kullanmak daha iyidir ama genelde bu çalışır.
    sed -i 's/}/, "SKIP_HOST_UPDATE": true }/' "$DISCORD_CONFIG"
    echo "   - Ayar eklendi."
  else
    echo "   - Ayar zaten mevcut."
  fi
else
  echo "   - Ayar dosyası yok, yeni oluşturuluyor..."
  mkdir -p "$(dirname "$DISCORD_CONFIG")"
  echo '{ "SKIP_HOST_UPDATE": true }' >"$DISCORD_CONFIG"
fi

echo -e "${BLUE}>>> Kurulum Tamamlandı! Discord'u menüden başlatabilirsin.${NC}"
