#!/bin/bash
# ==============================================================================
# DİNAMİK GÜÇ YÖNETİMİ VE KDE POWERDEVIL YAPILANDIRMA BETİĞİ
# ==============================================================================
# Bu betik, KDE Plasma PowerDevil güç yönetimine priz ve batarya geçişlerinde
# otomatik çalışacak güç optimizasyon betiklerini (Sunshine ve Baloo yönetimi) kaydeder.

set -e

echo ":: Dinamik Güç Yönetimi (KDE PowerDevil) Yapılandırılıyor..."

BATTERY_SCRIPT="$HOME/.local/bin/power-on-battery.sh"
AC_SCRIPT="$HOME/.local/bin/power-on-ac.sh"

# 1. Betiklerin çalıştırılabilirlik izinlerini kontrol et ve ver
if [ -f "$BATTERY_SCRIPT" ]; then
    chmod +x "$BATTERY_SCRIPT"
fi

if [ -f "$AC_SCRIPT" ]; then
    chmod +x "$AC_SCRIPT"
fi

# 2. KDE Plasma PowerDevil yapılandırma dosyasını güncelle (~/.config/powerdevilrc)
if command -v kwriteconfig6 &>/dev/null; then
    kwriteconfig6 --file powerdevilrc --group "AC" --group "RunScript" --key "ProfileLoadCommand" "$AC_SCRIPT" --notify
    kwriteconfig6 --file powerdevilrc --group "Battery" --group "RunScript" --key "ProfileLoadCommand" "$BATTERY_SCRIPT" --notify
    echo "  -> kwriteconfig6 ile powerdevilrc başarıyla güncellendi."
elif command -v kwriteconfig5 &>/dev/null; then
    kwriteconfig5 --file powerdevilrc --group "AC" --group "RunScript" --key "ProfileLoadCommand" "$AC_SCRIPT" --notify
    kwriteconfig5 --file powerdevilrc --group "Battery" --group "RunScript" --key "ProfileLoadCommand" "$BATTERY_SCRIPT" --notify
    echo "  -> kwriteconfig5 ile powerdevilrc başarıyla güncellendi."
else
    # Gerekirse doğrudan dosya yazımı
    cat << INI > "$HOME/.config/powerdevilrc"
[AC][RunScript]
ProfileLoadCommand=$AC_SCRIPT

[AC][SuspendAndShutdown]
AutoSuspendAction=0

[Battery][RunScript]
ProfileLoadCommand=$BATTERY_SCRIPT
INI
    echo "  -> powerdevilrc doğrudan güncellendi."
fi

# 3. PowerDevil servisine yapılandırmayı yenilemesini bildir
if command -v qdbus6 &>/dev/null; then
    qdbus6 org.kde.Solid.PowerManagement /org/kde/Solid/PowerManagement refreshStatus 2>/dev/null || true
elif command -v qdbus &>/dev/null; then
    qdbus org.kde.Solid.PowerManagement /org/kde/Solid/PowerManagement refreshStatus 2>/dev/null || true
fi

echo "✅ Dinamik Güç Yönetimi başarıyla yapılandırıldı."
echo "   - Batarya Betiği : $BATTERY_SCRIPT"
echo "   - Priz (AC) Betiği: $AC_SCRIPT"
