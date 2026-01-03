#!/bin/bash

# Dosya yolu
RESOLVED_CONF="/etc/systemd/resolved.conf"

# Root kontrolü
if [[ $EUID -ne 0 ]]; then
  echo "Hata: Bu script sudo hakları ile çalıştırılmalıdır."
  exit 1
fi

case "$1" in
on)
  echo "IBB Giriş Modu Aktif Ediliyor..."
  systemctl stop zapret
  sed -i 's/^DNS=/#DNS=/' "$RESOLVED_CONF"
  sed -i 's/^FallbackDNS=/#FallbackDNS=/' "$RESOLVED_CONF"
  sed -i 's/^DNSOverTLS=/#DNSOverTLS=/' "$RESOLVED_CONF"
  sed -i 's/^DNSSEC=/#DNSSEC=/' "$RESOLVED_CONF"
  systemctl restart systemd-resolved
  echo "İşlem tamam: Zapret durduruldu, DNS devre dışı."
  ;;
off)
  echo "Güvenli Mod Geri Yükleniyor..."
  sed -i 's/^#DNS=/DNS=/' "$RESOLVED_CONF"
  sed -i 's/^#FallbackDNS=/FallbackDNS=/' "$RESOLVED_CONF"
  sed -i 's/^#DNSOverTLS=/DNSOverTLS=/' "$RESOLVED_CONF"
  sed -i 's/^#DNSSEC=/DNSSEC=/' "$RESOLVED_CONF"
  systemctl start zapret
  systemctl restart systemd-resolved
  echo "İşlem tamam: Zapret başlatıldı, DNS ayarları geri yüklendi."
  ;;
*)
  echo "Kullanım: ibb-login {on|off}"
  exit 1
  ;;
esac
