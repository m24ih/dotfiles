# 🐱 Kitty (GPU Tabanlı Hızlı Terminal Emülatörü)

OpenGL hızlandırmalı, imleç izi (cursor trail) animasyonlu, saydamlık/blur efektli ve Wayland yerel optimizasyonlu Kitty yapılandırması.

---

## 📦 Kurulum ve Yazı Tipi

Eğer sisteminizde Kitty veya Nerd Font eksikse:

```bash
# Arch / CachyOS:
sudo pacman -S --needed kitty ttf-jetbrains-mono-nerd
# veya AUR:
yay -S --needed kitty ttf-jetbrains-mono-nerd
```

---

## 📁 Dosya Yapısı

```text
kitty/
└── .config/
    └── kitty/
        ├── kitty.conf            # Ana terminal yapılandırması (Görünüm, imleç, performans)
        ├── Tokyo Night.conf      # Tokyo Night renk teması
        ├── Material Dark.conf    # Material Dark renk teması
        └── Broadcast.conf        # Alternatif tema tanımları
```

---

## ⚙️ Yapılandırma ve Özel Efektler (`kitty.conf`)

### 1. ✨ İmleç İzi ve Görsel Efektler (Cursor Trail & Blur)
* **İmleç İzi Animasyonu (`cursor_trail 1`):** İmleç hızlı hareket ettiğinde arkasında akıcı bir ışık/iz efekti bırakır (`decay: 0.01 0.5`).
* **Saydamlık & Bulanıklık (`background_opacity 0.85`, `background_blur 5`):** Wayland üzerinde pencere arkasını %85 opaklık ve 5 seviye blur ile bulanıklaştırır.
* **İmleç Tipi:** Dikey çizgi imleç (`cursor_shape beam`, `cursor_beam_thickness 1.5`).

### 2. ⚡ Wayland & Performans Optimizasyonu
* **Wayland Motoru:** `linux_display_server wayland`
* **Giriş Gecikmesi:** `input_delay 3` ms ve `repaint_delay 10` ms ile anında tepki süresi.
* **Pencere Süslemeleri:** `hide_window_decorations yes` ve `window_padding_width 0` ile pikselsiz temiz çerçeve.

### 3. ⌨️ Kısayollar ve Pano
* `Ctrl + Shift + C` / `V`: Panoya kopyala / yapıştır.
* `Ctrl + Shift + Plus / Minus`: Yazı boyutu büyütme / küçültme.
* `copy_on_select yes`: Fareyle seçilen metni otomatik panoya kopyalar.
* `scrollback_lines 10000`: 10.000 satırlık geniş terminal geçmişi belleği.
