# 🪟 Hyprland (Dinamik Tiling Wayland Pencere Yöneticisi)

Akıcı animasyonlar, rounded corner'lar, blur efektleri, akıllı uygulama başlatıcı betikleri ve özelleştirilmiş kısayollar barındıran Hyprland yapılandırması.

---

## 📦 Kurulum ve Temel Bileşenler

Eğer sisteminizde Hyprland ve masaüstü bileşenleri eksikse:

```bash
# Ana Paketler (Arch / CachyOS):
sudo pacman -S --needed hyprland hyprpaper hyprlock hypridle xdg-desktop-portal-hyprland polkit-gnome

# Ekran ve Monitör Yönetimi İçin (İsteğe Bağlı GUI):
sudo pacman -S --needed nwg-displays
```

---

## 📁 Dosya Yapısı

```text
hypr/
└── .config/
    └── hypr/
        ├── hyprland.conf     # Ana Hyprland başlatıcı ve modül bağlayıcı
        ├── monitors.conf     # Monitör çözünürlükleri (nwg-displays uyumlu)
        ├── workspaces.conf   # Çalışma alanı kuralları ve monitör eşlemeleri
        ├── hypridle.conf     # Boşta kalma, ekran karartma ve kilit zamanlayıcıları
        ├── hyprlock.conf     # Modern kilit ekranı tasarımı
        ├── custom/           # Özel tuş atamaları (keybinds.conf) ve genel kurallar
        └── hyprland/         # HyDE / sistem alt betikleri ve kural setleri
```

---

## ⚙️ Özel Yapılandırma ve Kısayollar (`custom/keybinds.conf`)

* **`Ctrl + Shift + Esc`:** Ghostty içinde doğrudan **`btop`** kaynak izleyicisini açar (Görev Yöneticisi).
* **`Super + W`:** Vivaldi tarayıcısını orta tık otomatik kaydırma desteğiyle (`--enable-features=MiddleClickAutoscroll`) başlatır.
* **`Super + X`:** **Obsidian** not uygulamasını açar.
* **`Ctrl + Super + /`:** Shell yapılandırmasını Ghostty + Neovim ile hızlıca düzenler.
* **`Ctrl + Super + Alt + /`:** Hyprland kısayol dosyasını düzenler.
* **`nwg-displays` Uyumu:** `monitors.conf` dosyası nwg-displays arayüzü ile ekran konumlandırmaya hazır formatta tutulur.
