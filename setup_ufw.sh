#!/bin/bash
# ==============================================================================
# UFW GÜVENLİK DUVARI KURALLARI
# ==============================================================================
# Bu betik, sistem servislerinin (KDE Connect, Syncthing, Jellyfin, SSH, Sunshine)
# yerel ağda sorunsuz çalışabilmesi için gerekli port kurallarını tanımlar.

set -e

echo ":: UFW güvenlik duvarı yapılandırılıyor..."

# Temel Politika
sudo ufw default deny incoming
sudo ufw default allow outgoing

# 1. KDE Connect
sudo ufw allow 1714:1764/udp comment 'KDE Connect'
sudo ufw allow 1714:1764/tcp comment 'KDE Connect'

# 2. Syncthing (Dosya Senkronizasyonu)
sudo ufw allow syncthing comment 'Syncthing'

# 3. SSH
sudo ufw allow 22/tcp comment 'SSH'

# 4. Jellyfin Medya Sunucusu
sudo ufw allow 8096/tcp comment 'Jellyfin HTTP'
sudo ufw allow 8920/tcp comment 'Jellyfin HTTPS'
sudo ufw allow 1900/udp comment 'Jellyfin DLNA Discovery'
sudo ufw allow 7359/udp comment 'Jellyfin Auto Discovery'

# 5. Sunshine GameStream & Moonlight
sudo ufw allow 47984/tcp comment 'Sunshine HTTP/HTTPS'
sudo ufw allow 47989/tcp comment 'Sunshine Web UI'
sudo ufw allow 48010/tcp comment 'Sunshine Control TCP'
sudo ufw allow 5353/udp comment 'mDNS / Sunshine Discovery'
sudo ufw allow 47998:48000/udp comment 'Sunshine Video/Control Stream'
sudo ufw allow 48002/udp comment 'Sunshine Audio Stream'
sudo ufw allow 48010/udp comment 'Sunshine Mic Stream'

# UFW'yi etkinleştir ve yeniden yükle
sudo ufw --force enable
sudo ufw reload

echo ":: UFW kuralları başarıyla güncellendi!"
