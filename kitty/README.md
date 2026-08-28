# 🐱 Kitty (GPU Tabanlı Hızlı Terminal Emülatörü)

OpenGL hızlandırmalı, zengin görsel destekli ve sekme/bölme (split) yeteneklerine sahip popüler terminal emülatörü.

---

## 📦 Kurulum

Eğer sisteminizde kurulu değilse şu komutla kurabilirsiniz:

```bash
# Arch / CachyOS:
sudo pacman -S --needed kitty
# veya AUR:
yay -S --needed kitty
```

---

## 📁 Dosya Yapısı

```text
kitty/
└── .config/
    └── kitty/
        ├── kitty.conf            # Ana terminal yapılandırması (Kısayollar, pencere düzeni, font)
        ├── Tokyo Night.conf      # Tokyo Night renk teması
        ├── Material Dark.conf    # Material renk teması
        ├── dark-theme.auto.conf  # Otomatik koyu tema entegrasyonu
        └── light-theme.auto.conf # Otomatik açık tema entegrasyonu
```

---

## ⚙️ Özellikler

* **GPU Render:** OpenGL render motoru sayesinde düşük gecikme ve yüksek FPS.
* **Görsel/Medya Desteği:** Terminal içinde doğrudan resim görüntüleme (icat desteği).
* **Sekme & Bölme:** `Ctrl+Shift+Enter` ile pencere bölme, `Ctrl+Shift+T` ile yeni sekme.
