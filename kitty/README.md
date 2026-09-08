# 🐱 Kitty (GPU Tabanlı Hızlı Terminal Emülatörü)

OpenGL donanım hızlandırmalı, imleç izi (cursor trail) animasyonlu, pürüzsüz saydamlık ve blur efektli, otomatik açık/koyu tema destekli Kitty terminal yapılandırması.

---

## 📦 Kurulum ve Yazı Tipi

Kitty ve gerekli Nerd Font yazı tipini kurmak için:

```bash
# Arch Linux / CachyOS:
sudo pacman -S --needed kitty ttf-jetbrains-mono-nerd
# veya AUR:
yay -S --needed kitty ttf-jetbrains-mono-nerd
```

---

## 📁 Dizin ve Dosya Yapısı

```text
kitty/
└── .config/
    └── kitty/
        ├── kitty.conf                 # Ana terminal yapılandırması (Görünüm, imleç, performans, kısayollar)
        ├── Tokyo Night.conf           # Tokyo Night koyu renk teması
        ├── Tokyo Night Day.conf       # Tokyo Night açık renk teması
        ├── Material Dark.conf         # Material Dark renk paleti
        ├── Material.conf              # Material renk paleti
        ├── Broadcast.conf             # Canlı yayın / yüksek kontrast renk teması
        ├── dark-theme.auto.conf       # Sistem koyu moda geçtiğinde otomatik yüklenen tema
        └── light-theme.auto.conf      # Sistem açık moda geçtiğinde otomatik yüklenen tema
```

---

## ⚙️ Yapılandırma ve Öne Çıkan Özellikler (`kitty.conf`)

### 1. ✨ Animasyonlu İmleç İzi (Cursor Trail) ve Blur
* **İmleç İzi (`cursor_trail 1`):** İmleç terminalde hızla hareket ettiğinde veya zıpladığında arkasında akıcı, modern bir ışık izi bırakır (`cursor_trail_decay 0.01 0.5`).
* **İmleç Tipi:** İnce dikey çizgi imleç (`cursor_shape beam`, `cursor_beam_thickness 1.5`).
* **Saydamlık & Bulanıklık:** `%85` opaklık (`background_opacity 0.85`) ve 5 seviyeli Wayland arka plan bulanıklaştırma (`background_blur 5`).

### 2. ⚡ Düşük Gecikme ve Wayland Performansı
* **Giriş ve Çizim Gecikmesi:** `input_delay 3` ms ve `repaint_delay 10` ms ile klavye girdilerine anında tepki verir. Monitör yenileme hızına kilitlenir (`sync_to_monitor yes`).
* **Wayland Yerel Pencere:** `linux_display_server wayland` ve `hide_window_decorations yes` ile pencere kenar süslemeleri gizlenerek minimalist ve temiz bir görünüm elde edilir.
* **Uzak Kontrol:** `allow_remote_control yes` sayesinde harici betikler terminal ile haberleşebilir.

### 3. 🎨 Otomatik Tema Geçişi
* Sistem genelinde koyu/açık mod değiştiğinde `dark-theme.auto.conf` veya `light-theme.auto.conf` şemaları dinamik olarak devreye girer.
* Özel temalar arasında geçiş yapmak için `include <tema_adi>.conf` satırı kullanılabilir veya `kitty +kitten themes` arayüzü çağrılabilir.

### 4. ⌨️ Kısayollar ve Pano Entegrasyonu
* `Ctrl + Shift + C` / `Ctrl + Shift + V`: Sistem panosuna kopyalama ve yapıştırma.
* `Ctrl + Shift + +` / `-`: Yazı boyutunu dinamik büyütme ve küçültme.
* `Ctrl + Shift + Backspace`: Yazı boyutunu varsayılana sıfırlama.
* `copy_on_select yes`: Fareyle seçilen herhangi bir metin anında panoya aktarılır.
* `scrollback_lines 10000`: 10.000 satırlık geniş terminal çıktı geçmişi.
* `confirm_os_window_close 0`: Arka planda aktif bir işlem yokken terminali kapatırken gereksiz uyarı penceresi çıkarmaz.
