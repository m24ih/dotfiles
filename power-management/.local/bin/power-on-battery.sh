#!/usr/bin/env bash
# ==============================================================================
# BATARYA MODU GÜÇ TASARRUFU BETİĞİ (KDE Plasma PowerDevil Entegrasyonu)
# ==============================================================================
# Bu betik, dizüstü bilgisayar şarjdan çıkarılıp bataryaya geçildiğinde
# KDE PowerDevil tarafından otomatik olarak tetiklenir.
# Amaç: Arka planda donanım ve işlemci tüketen gereksiz servisleri durdurarak
# pil ömrünü maksimum seviyeye çıkarmaktır.

set -e

# 1. Sunshine GameStream Sunucusunu Durdur (NVIDIA RTX 4060 dGPU'yu uykuya geçirir)
if systemctl --user is-active --quiet app-dev.lizardbyte.app.Sunshine.service 2>/dev/null || \
   systemctl --user is-active --quiet sunshine.service 2>/dev/null; then
    systemctl --user stop sunshine.service 2>/dev/null || true
fi

# 2. KDE Baloo Dosya İndeksleyicisini Askıya Al (Disk ve CPU taramasını durdurur)
if command -v balooctl6 &>/dev/null; then
    balooctl6 suspend 2>/dev/null || true
elif command -v balooctl &>/dev/null; then
    balooctl suspend 2>/dev/null || true
fi

# ------------------------------------------------------------------------------
# İLERİDE İSTEĞE BAĞLI EKLENEBİLECEK SERVİSLER (İhtiyaca göre yorum kaldırılabilir)
# ------------------------------------------------------------------------------
# # Docker konteynerlerini durdur:
# if command -v docker &>/dev/null; then
#     docker stop $(docker ps -q) 2>/dev/null || true
# fi

# # Free Download Manager'ı kapat:
# pkill -f "fdm --hidden" 2>/dev/null || true

# # Syncthing dosya senkronizasyonunu durdur:
# systemctl --user stop syncthing.service 2>/dev/null || true

# 3. Kullanıcıya hafif masaüstü bildirimi gönder
if command -v notify-send &>/dev/null; then
    notify-send -u low -i battery-profile-powersave-symbolic \
        "Pil Tasarrufu Aktif" \
        "Batarya moduna geçildi: Sunshine ve Baloo dosya indeksleme durduruldu." 2>/dev/null || true
fi
