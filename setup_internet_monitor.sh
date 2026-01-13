#!/bin/bash

# --- AYARLAR ---
# Healthchecks.io'dan aldığın Laptop Ping URL'ini buraya yapıştır:
PING_URL="BURAYA_PING_URL_ADRESINI_YAPISTIR"
SCRIPT_DIR="$HOME/Documents/scripts"
SYSTEMD_DIR="$HOME/.config/systemd/user"

echo "Genel İnternet İzleme Sistemi kurulumu başlatılıyor..."

# 1. Klasörleri oluştur
mkdir -p "$SCRIPT_DIR"
mkdir -p "$SYSTEMD_DIR"

# 2. Ping Scriptini oluştur (Genel adlandırma)
cat <<EOF >"$SCRIPT_DIR/internet_heartbeat.sh"
#!/bin/bash
# Herhangi bir bağlantı sorunu veya DNS hatasında --fail hata döndürür
curl --fail --connect-timeout 10 -s "$PING_URL" > /dev/null
EOF

chmod +x "$SCRIPT_DIR/internet_heartbeat.sh"
echo "✓ İzleme scripti oluşturuldu: $SCRIPT_DIR/internet_heartbeat.sh"

# 3. Systemd Service dosyasını oluştur
cat <<EOF >"$SYSTEMD_DIR/internet_monitor.service"
[Unit]
Description=General Internet Connection Heartbeat

[Service]
Type=oneshot
ExecStart=$SCRIPT_DIR/internet_heartbeat.sh
EOF

# 4. Systemd Timer dosyasını oluştur
cat <<EOF >"$SYSTEMD_DIR/internet_monitor.timer"
[Unit]
Description=Run Internet Connection Check every minute

[Timer]
OnCalendar=*:0/1
Unit=internet_monitor.service

[Install]
WantedBy=timers.target
EOF

# 5. Kapanışta Duraklatma (Pause) servisini oluştur
cat <<EOF >"$SYSTEMD_DIR/internet_pause.service"
[Unit]
Description=Pause Connection Monitor on Shutdown/Sleep
DefaultDependencies=no
Before=shutdown.target sleep.target

[Service]
Type=oneshot
ExecStart=/usr/bin/curl -s "$PING_URL/pause"

[Install]
WantedBy=shutdown.target sleep.target
EOF

echo "✓ Systemd servisleri (Genel) oluşturuldu."

# 6. Servisleri aktif et
systemctl --user daemon-reload
systemctl --user enable --now internet_monitor.timer
systemctl --user enable --now internet_pause.service

echo "-----------------------------------------------"
echo "GENEL KURULUM TAMAMLANDI!"
echo "1. Durum: \$(systemctl --user is-active internet_monitor.timer)"
echo "2. Dosya Konumu: $SCRIPT_DIR"
echo "-----------------------------------------------"
