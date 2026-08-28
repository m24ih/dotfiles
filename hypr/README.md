# 🪟 Hyprland (Dinamik Tiling Wayland Pencere Yöneticisi)

Akıcı animasyonlar, rounded corner'lar, blur efektleri ve gelişmiş kısayol yönetimi sunan modern Wayland pencere yöneticisi.

---

## 📦 Kurulum

Eğer sisteminizde kurulu değilse ana ve yardımcı bileşenleri şu komutla kurabilirsiniz:

```bash
# Arch / CachyOS:
sudo pacman -S --needed hyprland hyprpaper hyprlock hypridle xdg-desktop-portal-hyprland
# veya AUR:
yay -S --needed hyprland hyprpaper hyprlock hypridle xdg-desktop-portal-hyprland
```

---

## 📁 Dosya Yapısı

```text
hypr/
└── .config/
    └── hypr/
        ├── hyprland.conf     # Ana Hyprland giriş yapılandırması
        ├── monitors.conf     # Ekran çözünürlük, yenileme hızı ve konum ayarları
        ├── workspaces.conf   # Çalışma alanı (Workspace) kuralları
        ├── hypridle.conf     # Boşta kalma ve güç tasarrufu zamanlayıcısı
        ├── hyprlock.conf     # Modern kilit ekranı yapılandırması
        ├── custom/           # Özel tuş atamaları ve kullanıcı modülleri
        └── hyprland/         # Modüler Hyprland alt yapılandırmaları
```

---

## ⚙️ Önemli Kısayollar

* `Super + Q`: Terminali aç
* `Super + C`: Aktif pencereyi kapat
* `Super + E`: Dosya yöneticisini aç (Dolphin)
* `Super + V`: Kayan pencere (Floating) moduna geç
* `Super + 1..9`: Çalışma alanları arasında geçiş yap
