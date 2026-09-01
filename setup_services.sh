#!/bin/bash
# ==============================================================================
# SİSTEM VE KULLANICI SERVİSLERİNİ OTOMATİK ETKİNLEŞTİRME BETİĞİ
# ==============================================================================
# Bu betik, dotfiles kurulumu sonrasında gerekli tüm sistem (sudo) ve kullanıcı
# (--user) systemd servislerini güvenli bir şekilde kontrol eder ve aktifleşir.
# Çeşitli Linux dağıtımlarını destekler.

set -e

# Başlangıç mesajı
echo ":: Sistem ve Kullanıcı Servisleri Yapılandırılıyor..."

# OS Tespiti
DETECTED_OS=""
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DETECTED_OS="$ID"
fi

# Systemd komutu seçici (bazı sistemlerde farklı olabilir)
SYSTEMCTL="systemctl"
if ! command -v $SYSTEMCTL &>/dev/null; then
    echo "Hata: systemctl bulunamadı. Bu script systemd gerektirir."
    exit 1
fi

# ------------------------------------------------------------------------------
# 1. KULLANICI SERVİSLERİ (USER SERVICES)
# ------------------------------------------------------------------------------
echo "-> Kullanıcı servisleri denetleniyor ve aktifleştiriliyor..."

# OS'e özel kullanıcı servisleri
case "$DETECTED_OS" in
    arch|manjaro|endeavouros|artix|cachyos)
        USER_SERVICES=(
            "psd.service"                   # Profile Sync Daemon (Tarayıcı Profil RAM Senkronu)
            "arch-update.timer"             # Arch Güncelleme Kontrol Zamanlayıcısı
            "warp-taskbar.service"          # Cloudflare WARP Sistem Tepsi Servisi
            "syncthing.service"             # Syncthing Kullanıcı Servisi
        )
        ;;
    fedora|rhel|centos|rocky|almalinux)
        USER_SERVICES=(
            "psd.service"                   # Profile Sync Daemon
            "fedora-upgrade.timer"          # Fedora Güncelleme Kontrol Zamanlayıcısı
            "syncthing.service"             # Syncthing Kullanıcı Servisi
        )
        ;;
    ubuntu|debian|linuxmint|pop|elementary)
        USER_SERVICES=(
            "psd.service"                   # Profile Sync Daemon
            "apt-update.timer"              # APT Güncelleme Kontrol Zamanlayıcısı
            "syncthing.service"             # Syncthing Kullanıcı Servisi
        )
        ;;
    *)
        # Varsayılan servis listesi (Arch-based)
        USER_SERVICES=(
            "psd.service"                   # Profile Sync Daemon
            "arch-update.timer"             # Güncelleme Kontrol Zamanlayıcısı
            "syncthing.service"             # Syncthing Kullanıcı Servisi
        )
        ;;
esac

# Systemd daemon yenile
$SYSTEMCTL --user daemon-reload

for service in "${USER_SERVICES[@]}"; do
    if $SYSTEMCTL --user list-unit-files "$service" &>/dev/null; then
        echo "  -> Kullanıcı Servisi Etkinleştiriliyor: $service"
        $SYSTEMCTL --user enable --now "$service" 2>/dev/null || echo "     ⚠️ $service başlatılamadı (henüz yapılandırılmamış olabilir)."
    else
        echo "  -- $service bulunamadı (atlanıyor)."
    fi
done

# ------------------------------------------------------------------------------
# 2. SİSTEM SERVİSLERİ VE ZAMANLAYICILARI (SYSTEM SERVICES & TIMERS)
# ------------------------------------------------------------------------------
echo "-> Sistem servisleri (sudo) denetleniyor ve aktifleştiriliyor..."

# OS'e özel sistem servisleri
case "$DETECTED_OS" in
    arch|manjaro|endeavouros|artix|cachyos)
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
        ;;
    fedora|rhel|centos|rocky|almalinux)
        SYSTEM_SERVICES=(
            "bluetooth.service"             # Bluetooth Servisi
            "firewalld.service"             # Firewall Servisi (Fedora farklı firewall kullanır)
            "avahi-daemon.service"          # Yerel Ağ Cihaz Keşif Servisi (mDNS)
            " tuned.service"                # Sistem Performans Tuning Servisi
            "bpftune.service"               # BPF Otomatik Ağ Optimizasyon Servisi
            "warp-svc.service"              # Cloudflare WARP Daemon Servisi
            "docker.service"                # Docker Konteyner Servisi
            "tailscaled.service"            # Tailscale VPN Servisi
            "fstrim.timer"                  # SSD TRIM Otomatik Bakım Zamanlayıcısı
            "dnf-makecache.timer"           # DNF Önbellek Güncelleme Zamanlayıcısı
            "snapper-cleanup.timer"         # Btrfs Snapper Temizlik Zamanlayıcısı (eğer Btrfs kullanılıyorsa)
            "grubby.service"                # GRUB Yapılandırma Aracı
            " ModemManager.service"         # Modem Yönetimi Servisi
        )
        ;;
    ubuntu|debian|linuxmint|pop|elementary)
        SYSTEM_SERVICES=(
            "bluetooth.service"             # Bluetooth Servisi
            "ufw.service"                   # UFW Güvenlik Duvarı (Varsayılan)
            "avahi-daemon.service"          # Yerel Ağ Cihaz Keşif Servisi (mDNS)
            "timered.service"               # Sistem Saati Servisi
            "bolt.service"                  # Thunderbolt Güvenlik Servisi
            "warp-svc.service"              # Cloudflare WARP Daemon Servisi
            "docker.service"                # Docker Konteyner Servisi
            "tailscaled.service"            # Tailscale VPN Servisi
            "fstrim.timer"                  # SSD TRIM Otomatik Bakım Zamanlayıcısı
            "apt-daily.timer"               # Günlük APT Güncelleme Zamanlayıcısı
            "apt-daily-upgrade.timer"       # Günlük APT Yükseltme Zamanlayıcısı
            "snapd.service"                 # Snap Daemon
            " ModemManager.service"         # Modem Yönetimi Servisi
        )
        ;;
    *)
        # Varsayılan sistem servis listesi (Arch-based olarak kalacak)
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
            "snapper-cleanup.timer"         # Btrfs Snapper Temizlik Zamanlayıcısı
            "grub-btrfs-snapper.path"       # Btrfs GRUB Yansıma Güncelleyici
            "cachyos-iw-set-regdomain.path" # Kablosuz Ağ Bölge Ayarı Servisi
        )
        ;;
esac

for service in "${SYSTEM_SERVICES[@]}"; do
    if $SYSTEMCTL list-unit-files "$service" &>/dev/null; then
        echo "  -> Sistem Servisi Etkinleştiriliyor: $service"
        sudo $SYSTEMCTL enable --now "$service" 2>/dev/null || echo "     ⚠️ $service başlatılamadı."
    else
        echo "  -- $service bulunamadı (atlanıyor)."
    fi
done

echo "------------------------------------------------------------------------------"
echo "✅ Tüm Sistem ve Kullanıcı Servisleri Başarıyla Yapılandırıldı!"
echo "------------------------------------------------------------------------------"
