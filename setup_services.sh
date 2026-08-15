#!/bin/bash
# ==============================================================================
# SİSTEM VE KULLANICI SERVİSLERİNİ OTOMATİK ETKİNLEŞTİRME BETİĞİ
# ==============================================================================
# Bu betik, dotfiles kurulumu sonrasında gerekli tüm sistem (sudo) ve kullanıcı 
# (--user) systemd servislerini güvenli bir şekilde kontrol eder ve aktifleşir.

set -e

echo ":: Sistem ve Kullanıcı Servisleri Yapılandırılıyor..."

# ------------------------------------------------------------------------------
# 1. KULLANICI SERVİSLERİ (USER SERVICES)
# ------------------------------------------------------------------------------
echo ":: Kullanıcı servisleri denetleniyor ve aktifleştiriliyor..."

USER_SERVICES=(
    "proton-pass-ssh-agent.service" # Proton Pass CLI SSH Agent
    "psd.service"                   # Profile Sync Daemon (Tarayıcı Profil RAM Senkronu)
    "arch-update.timer"             # Arch Güncelleme Kontrol Zamanlayıcısı
    "warp-taskbar.service"          # Cloudflare WARP Sistem Tepsi Servisi
    "syncthing.service"             # Syncthing Kullanıcı Servisi
)

# Systemd daemon yenile
systemctl --user daemon-reload

for service in "${USER_SERVICES[@]}"; do
    if systemctl --user list-unit-files "$service" &>/dev/null; then
        echo "  -> Kullanıcı Servisi Etkinleştiriliyor: $service"
        systemctl --user enable --now "$service" 2>/dev/null || echo "     ⚠️ $service başlatılamadı (henüz yapılandırılmamış olabilir)."
    else
        echo "  -- $service bulunamadı (atlanıyor)."
    fi
done

# ------------------------------------------------------------------------------
# 2. SİSTEM SERVİSLERİ VE ZAMANLAYICILARI (SYSTEM SERVICES & TIMERS)
# ------------------------------------------------------------------------------
echo ":: Sistem servisleri (sudo) denetleniyor ve aktifleştiriliyor..."

SYSTEM_SERVICES=(
    "bluetooth.service"             # Bluetooth Servisi
    "ufw.service"                   # UFW Güvenlik Duvarı
    "avahi-daemon.service"          # Yerel Ağ Cihaz Keşif Servisi (mDNS)
    "ananicy-cpp.service"           # Otomatik Süreç Önceliklendirici (Performans/Oyun)
    "bpftune.service"               # BPF Otomatik Ağ Optimizasyon Servisi
    "warp-svc.service"              # Cloudflare WARP Daemon Servisi
    "docker.service"                # Docker Konteyner Servisi
    "tailscaled.service"            # Tailscale VPN Servisi
    "fstrim.timer"                  # SSD TRIM Otomatik Bakım Zamanlayıcısı
    "cachyos-rate-mirrors.timer"    # CachyOS Yansıma Hızı Zamanlayıcısı
    "snapper-cleanup.timer"         # Btrfs Snapper Temizlik Zamanlayıcısı
    "grub-btrfs-snapper.path"       # Btrfs GRUB Yansıma Güncelleyici
    "cachyos-iw-set-regdomain.path" # Kablosuz Ağ Bölge Ayarı Servisi
)

for service in "${SYSTEM_SERVICES[@]}"; do
    if systemctl list-unit-files "$service" &>/dev/null; then
        echo "  -> Sistem Servisi Etkinleştiriliyor: $service"
        sudo systemctl enable --now "$service" 2>/dev/null || echo "     ⚠️ $service başlatılamadı."
    else
        echo "  -- $service bulunamadı (atlanıyor)."
    fi
done

echo "------------------------------------------------------------------------------"
echo "✅ Tüm Sistem ve Kullanıcı Servisleri Başarıyla Yapılandırıldı!"
echo "------------------------------------------------------------------------------"
