#!/usr/bin/env bash
# ==============================================================================
# PRİZ / AC MODU PERFORMANS BETİĞİ (KDE Plasma PowerDevil Entegrasyonu)
# ==============================================================================
# Bu betik, dizüstü bilgisayar şarja / prize takıldığında
# KDE PowerDevil tarafından otomatik olarak tetiklenir.
# Amaç: Bataryadayken askıya alınan veya kapatılan servisleri tekrar devreye almaktır.

set -e

# 1. Sunshine GameStream Sunucusunu Yeniden Başlat (Eğer etkinse)
if systemctl --user is-enabled --quiet app-dev.lizardbyte.app.Sunshine.service 2>/dev/null || \
   systemctl --user is-enabled --quiet sunshine.service 2>/dev/null; then
    systemctl --user start sunshine.service 2>/dev/null || true
fi

# 2. KDE Baloo Dosya İndeksleyicisini Devam Ettir
if command -v balooctl6 &>/dev/null; then
    balooctl6 resume 2>/dev/null || true
elif command -v balooctl &>/dev/null; then
    balooctl resume 2>/dev/null || true
fi

# 3. TLP AC Modunu Tetikle (Udev gecikmelerini önlemek için anında uygula)
if command -v tlp &>/dev/null; then
    sudo -n tlp ac 2>/dev/null || true
fi

# ------------------------------------------------------------------------------
# İLERİDE İSTEĞE BAĞLI EKLENEBİLECEK SERVİSLER
# ------------------------------------------------------------------------------
# # Syncthing tekrar başlat:
# systemctl --user start syncthing.service 2>/dev/null || true

# 4. Kullanıcıya hafif masaüstü bildirimi gönder
if command -v notify-send &>/dev/null; then
    notify-send -u low -i ac-adapter-symbolic \
        "Performans Modu Aktif" \
        "Prize takıldı: Sunshine ve Baloo yeniden başlatıldı, TLP AC profili uygulandı." 2>/dev/null || true
fi
