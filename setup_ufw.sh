#!/bin/bash
# ==============================================================================
# UFW GÜVENLİK DUVARI KURALLARI
# ==============================================================================

sudo ufw allow 1714:1764/udp # KDE Connect
sudo ufw allow 1714:1764/tcp # KDE Connect
sudo ufw allow syncthing     # Syncthing

# Jellyfin Medya Sunucusu Kuralları
sudo ufw allow 8096/tcp      # Jellyfin HTTP Web Arayüzü
sudo ufw allow 8920/tcp      # Jellyfin HTTPS Web Arayüzü
sudo ufw allow 1900/udp      # Jellyfin DLNA Keşif Servisi
sudo ufw allow 7359/udp      # Jellyfin Otomatik İstemci Keşfi (Android TV / Roku vb.)

sudo ufw reload
