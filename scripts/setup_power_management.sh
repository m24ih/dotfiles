#!/bin/bash
# ==============================================================================
# GÜÇ YÖNETİMİ YAPILANDIRMA BETİĞİ (TLP + KDE POWERDEVIL)
# ==============================================================================
# Bu betik iki katmanlı güç yönetimini yapılandırır:
# 1. Donanım Katmanı (TLP):
#    - power-profiles-daemon (ppd) ve tuned servislerini maskeler (çakışma önleyici).
#    - Dotfiles içerisindeki drop-in TLP ayarlarını (/etc/tlp.d/01-power-save.conf) uygular.
#    - tlp.service servisini etkinleştirir ve tlp start komutunu çalıştırır.
# 2. Masaüstü/Kullanıcı Katmanı (KDE Plasma PowerDevil):
#    - Priz ve batarya geçişlerinde tetiklenecek optimizasyon betiklerini (Sunshine, Baloo)
#      KDE PowerDevil profillerine kaydeder.

set -e

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

echo ":: Güç Yönetimi (TLP ve KDE PowerDevil) Yapılandırılıyor..."

# ------------------------------------------------------------------------------
# 1. DONANIM KATMANI: TLP VE ÇAKIŞMA ÖNLEYİCİ MASKELER
# ------------------------------------------------------------------------------
echo "-> [Katman 1/2] Donanım Güç Yönetimi (TLP) yapılandırılıyor..."

# TLP, power-profiles-daemon ve tuned ile çakışır. Çakışan servisleri durdur ve maskele.
for conflict_svc in power-profiles-daemon.service tuned.service; do
    if systemctl list-unit-files "$conflict_svc" &>/dev/null || systemctl is-active --quiet "$conflict_svc" 2>/dev/null; then
        echo "  -> Çakışma önleyici: $conflict_svc durduruluyor ve maskeleniyor..."
        sudo systemctl stop "$conflict_svc" 2>/dev/null || true
        sudo systemctl mask "$conflict_svc" 2>/dev/null || true
    fi
done

# TLP Yapılandırmasını Kur
TLP_SOURCE_CONF="$DOTFILES_DIR/power-management/etc/tlp.d/01-power-save.conf"
if [ -f "$TLP_SOURCE_CONF" ]; then
    echo "  -> TLP drop-in yapılandırması kuruluyor: /etc/tlp.d/01-power-save.conf"
    sudo mkdir -p /etc/tlp.d
    sudo install -Dm644 "$TLP_SOURCE_CONF" /etc/tlp.d/01-power-save.conf
fi

# TLP Servisini Etkinleştir ve Başlat
if command -v tlp &>/dev/null || systemctl list-unit-files tlp.service &>/dev/null; then
    echo "  -> tlp.service etkinleştiriliyor ve başlatılıyor..."
    sudo systemctl enable --now tlp.service 2>/dev/null || true
    if command -v tlp &>/dev/null; then
        sudo tlp start 2>/dev/null || true
    fi
    echo "  -> TLP başarıyla devreye alındı."
else
    echo "  ⚠️ 'tlp' komutu veya servisi bulunamadı. Paket kurulum adımı atlanmış olabilir."
fi

# ------------------------------------------------------------------------------
# 2. MASAÜSTÜ KATMANI: KDE PLASMA POWERDEVIL BETİKLERİ
# ------------------------------------------------------------------------------
echo "-> [Katman 2/2] KDE Plasma PowerDevil betikleri yapılandırılıyor..."

BATTERY_SCRIPT="$HOME/.local/bin/power-on-battery.sh"
AC_SCRIPT="$HOME/.local/bin/power-on-ac.sh"

# Betiklerin çalıştırılabilirlik izinlerini kontrol et ve ver
if [ -f "$BATTERY_SCRIPT" ]; then
    chmod +x "$BATTERY_SCRIPT"
fi

if [ -f "$AC_SCRIPT" ]; then
    chmod +x "$AC_SCRIPT"
fi

# KDE Plasma PowerDevil yapılandırma dosyasını güncelle (~/.config/powerdevilrc)
if command -v kwriteconfig6 &>/dev/null; then
    kwriteconfig6 --file powerdevilrc --group "AC" --group "RunScript" --key "ProfileLoadCommand" "$AC_SCRIPT" --notify
    kwriteconfig6 --file powerdevilrc --group "Battery" --group "RunScript" --key "ProfileLoadCommand" "$BATTERY_SCRIPT" --notify
    echo "  -> kwriteconfig6 ile powerdevilrc başarıyla güncellendi."
elif command -v kwriteconfig5 &>/dev/null; then
    kwriteconfig5 --file powerdevilrc --group "AC" --group "RunScript" --key "ProfileLoadCommand" "$AC_SCRIPT" --notify
    kwriteconfig5 --file powerdevilrc --group "Battery" --group "RunScript" --key "ProfileLoadCommand" "$BATTERY_SCRIPT" --notify
    echo "  -> kwriteconfig5 ile powerdevilrc başarıyla güncellendi."
else
    local pd_file="$HOME/.config/powerdevilrc"
    if [ ! -f "$pd_file" ]; then
        mkdir -p "$(dirname "$pd_file")"
        cat << INI > "$pd_file"
[AC][RunScript]
ProfileLoadCommand=$AC_SCRIPT

[AC][SuspendAndShutdown]
AutoSuspendAction=0

[Battery][RunScript]
ProfileLoadCommand=$BATTERY_SCRIPT
INI
        echo "  -> powerdevilrc dosyası oluşturuldu."
    else
        echo "  ⚠️ 'kwriteconfig' bulunamadı. Mevcut powerdevilrc ayarlarını korumak için dosya üzerine yazılmadı."
        echo "     Manuel entegrasyon için: [AC][RunScript] ProfileLoadCommand=$AC_SCRIPT"
    fi
fi

# PowerDevil servisine yapılandırmayı yenilemesini bildir
if command -v qdbus6 &>/dev/null; then
    qdbus6 org.kde.Solid.PowerManagement /org/kde/Solid/PowerManagement refreshStatus 2>/dev/null || true
elif command -v qdbus &>/dev/null; then
    qdbus org.kde.Solid.PowerManagement /org/kde/Solid/PowerManagement refreshStatus 2>/dev/null || true
fi

echo "✅ Güç Yönetimi mimarisi başarıyla yapılandırıldı."
echo "   - Donanım Katmanı : TLP (/etc/tlp.d/01-power-save.conf)"
echo "   - Çakışma Durumu  : power-profiles-daemon ve tuned maskelendi"
echo "   - Batarya Betiği  : $BATTERY_SCRIPT"
echo "   - Priz (AC) Betiği: $AC_SCRIPT"
