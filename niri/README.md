# 📜 Niri (Kaydırılabilir Tiling Wayland Pencere Yöneticisi)

Pencereleri sonsuz yatay bir şerit üzerinde kaydırarak yönetmenize olanak tanıyan, modern ve yenilikçi scrollable-tiling Wayland pencere yöneticisi.

---

## 📦 Kurulum

Eğer sisteminizde kurulu değilse şu komutla kurabilirsiniz:

```bash
# Arch / CachyOS:
sudo pacman -S --needed niri xdg-desktop-portal-gnome
# veya AUR:
yay -S --needed niri
```

---

## 📁 Dosya Yapısı

```text
niri/
└── .config/
    └── niri/
        ├── config.kdl        # Ana KDL yapılandırma dosyası
        └── cfg/              # Modüler pencere kuralları, kısayollar ve girdi ayarları
```

---

## ⚙️ Önemli Özellikler & Kısayollar

* **Scrollable Layout:** Pencereler yan yana dizilir ve `Super + Sol/Sağ Ok` (veya `Super + Mouse Tekerleği`) ile yatay şeritte gezilir.
* **Akıcı Animasyonlar:** Dahili donanım hızlandırmalı geçiş efektleri.
* **Kolay Yeniden Boyutlandırma:** `Super + R` ile sütun genişliği ayarlama.
