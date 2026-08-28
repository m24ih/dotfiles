# 🥭 MangoWM (Hafif ve Akıcı Wayland Pencere Yöneticisi)

wlroots tabanlı, akıcı animasyonlara ve modüler yapılandırma desteğine sahip hafif Wayland pencere yöneticisi (compositor).

---

## 📦 Kurulum

Eğer sisteminizde kurulu değilse şu komutla kurabilirsiniz:

```bash
# CachyOS / Arch:
sudo pacman -S --needed mangowm
# veya AUR:
yay -S --needed mangowm-git
```

---

## 📁 Dosya Yapısı

```text
mango/
└── .config/
    ├── mango/
    │   ├── config.conf      # Ana MangoWM giriş yapılandırması
    │   └── cfg/             # Modüler ayarlar (Monitörler, kısayollar, girdi, düzen, kurallar)
    ├── xdg-desktop-portal/  # Mango portal yapılandırması
    └── xdg-desktop-portal-wlr/ # Ekran paylaşımı ve pencere yakalama portalı
```

---

## ⚙️ Yapılandırma Modülleri (`cfg/`)

* `monitors.conf`: Ekran çözünürlükleri, yenileme hızı ve VRR (G-Sync/FreeSync) ayarları.
* `keybinds.conf`: Pencere yönetimi ve uygulama başlatma kısayolları.
* `layout.conf`: Tiling ve kayan pencere (floating) yerleşim kuralları.
* `rules.conf`: Belirli uygulamalar için otomatik çalışma alanı ve boyut kuralları.
