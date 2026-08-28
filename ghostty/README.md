# 👻 Ghostty (Modern GPU Terminal Emülatörü)

Zig ile yazılmış, donanım hızlandırmalı, düşük gecikmeli ve yerel Wayland/X11 desteğine sahip yeni nesil terminal emülatörü.

---

## 📦 Kurulum

Eğer sisteminizde kurulu değilse şu komutla kurabilirsiniz:

```bash
# Arch / CachyOS:
sudo pacman -S --needed ghostty
# veya AUR:
yay -S --needed ghostty
```

---

## 📁 Dosya Yapısı

```text
ghostty/
└── .config/
    └── ghostty/
        ├── config.ghostty    # Ana terminal yapılandırması (Font, saydamlık, kısayollar)
        ├── themes/           # Renk temaları
        └── auto/             # Otomatik tema/ayarlar
```

---

## ⚙️ Yapılandırma Detayları

* **Yazı Tipi:** JetBrains Mono Nerd Font desteği ve ligatürler aktif.
* **Görünüm:** Saydam arka plan ve modern pencere kenar boşlukları (padding).
* **GPU Render:** Metal/Vulkan tabanlı akıcı render performansı.
