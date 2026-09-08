#!/bin/bash
# ==============================================================================
# SSH Sunucusu (sshd) Güvenlik ve Ağ Erişim Kısıtlaması
# ==============================================================================
# Bu betik, SSH sunucusuna sadece izin verilen yerel ağlardan ve VPN'den (Tailscale vb.)
# erişim sağlayan kısıtlama dosyasını /etc/ssh/sshd_config.d/ altına kurar.

set -e

echo ":: SSH sunucusu güvenlik yapılandırması..."

SSHD_CONFIG_DIR="/etc/ssh/sshd_config.d"
TARGET_FILE="$SSHD_CONFIG_DIR/10-allowed-networks.conf"

sudo mkdir -p "$SSHD_CONFIG_DIR"

sudo tee "$TARGET_FILE" > /dev/null << 'EOF'
AllowUsers melih@192.168.1.* melih@192.168.0.* melih@100.*.*.* melih@127.0.0.1
EOF

sudo chmod 644 "$TARGET_FILE"
echo "  -> Yapılandırma dosyası oluşturuldu: $TARGET_FILE"

# sshd servisi aktifse veya kuruluysa yeniden başlat
if systemctl is-active --quiet sshd 2>/dev/null; then
    echo ":: sshd servisi yeniden başlatılıyor..."
    sudo systemctl restart sshd
fi

echo ":: SSH sunucusu güvenlik yapılandırması tamamlandı!"
