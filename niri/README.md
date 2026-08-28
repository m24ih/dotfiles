# 📜 Niri (Kaydırılabilir Tiling Wayland Pencere Yöneticisi)

Pencereleri sonsuz yatay bir şerit üzerinde kaydırarak yönetmenize olanak tanıyan, VRR (G-Sync/FreeSync) oyun kuralları ve ekran kaydı gizlilik koruması barındıran modern Wayland pencere yöneticisi.

---

## 📦 Kurulum ve Portal Bileşenleri

Eğer sisteminizde Niri eksikse:

```bash
# Arch / CachyOS:
sudo pacman -S --needed niri xdg-desktop-portal-gnome polkit-gnome
# veya AUR:
yay -S --needed niri xdg-desktop-portal-gnome polkit-gnome
```

---

## 📁 Dosya Yapısı

```text
niri/
└── .config/
    └── niri/
        ├── config.kdl        # Ana KDL başlatıcı
        └── cfg/              # Modüler yapılandırma dosyaları
            ├── rules.kdl     # Pencere kuralları, VRR ve gizlilik ayarları
            ├── keybinds.kdl  # Kısayol atamaları
            ├── layout.kdl    # Şerit ve sütun yerleşim parametreleri
            ├── display.kdl   # Monitör çözünürlük ve ölçek ayarları
            ├── input.kdl     # Klavye düzeni ve touchpad ayarları
            ├── animation.kdl # Pencere kaydırma ve açılış animasyonları
            └── autostart.kdl # Başlangıçta çalışan arka plan servisleri
```

---

## ⚙️ Yapılandırma ve Özel Kurallar (`cfg/rules.kdl`)

### 1. 🛡️ Güvenlik ve Gizlilik (Screen-Capture Koruması)
* **Proton Pass Koruması:** `block-out-from "screen-capture"` kuralı ile Proton Pass şifre yöneticisi ekran paylaşımı yapılırken veya video kaydı alınırken otomatik olarak gizlenir/karartılır.

### 2. 🎮 Oyun & Yüksek Yenileme Hızı (VRR & 144Hz)
* **Otomatik VRR:** `cs2`, `gamescope` ve `steam_app_*` uygulamaları açıldığında otomatik tam ekran ve Değişken Yenileme Hızı (`variable-refresh-rate true`) devreye girer.

### 3. ✨ Görsel ve Estetik (Blur & Geometry)
* **Rounded Corners:** 16 piksel yuvarlatılmış pencere köşeleri (`geometry-corner-radius 16`).
* **Bulanıklık Efekti (Blur):** Ghostty, Kitty, Nautilus ve Obsidian için arka plan blur efektleri aktiftir.

---

## ⌨️ Temel Kısayollar

* `Super + Sol / Sağ`: Yatay şeritte pencereler arasında gezinme.
* `Super + Shift + Sol / Sağ`: Aktif pencereyi şeritte sağa/sola taşıma.
* `Super + R`: Sütun genişliğini yeniden boyutlandırma.
* `Super + F`: Tam ekran (Fullscreen) modu.
