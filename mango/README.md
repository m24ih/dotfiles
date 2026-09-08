# 🥭 MangoWM (Hafif ve Akıcı Wayland Pencere Yöneticisi)

wlroots tabanlı, akıcı animasyonlara, donanım hızlandırmalı görsel efektlere (blur, shadow) ve modüler yapılandırma mimarisine sahip hafif Wayland pencere yöneticisi (compositor).

---

## 📦 Kurulum ve Bağımlılıklar

MangoWM ve eşlik eden masaüstü kabuğu (Noctalia) için kurulum:

```bash
# CachyOS / Arch Linux:
sudo pacman -S --needed mangowm
# veya AUR:
yay -S --needed mangowm-git noctalia-shell
```

---

## 📁 Dizin ve Dosya Yapısı

```text
mango/
└── .config/
    ├── mango/
    │   ├── config.conf               # Ana giriş dosyası (Tüm cfg/*.conf modüllerini source eder)
    │   └── cfg/
    │       ├── appearance.conf       # Kenarlıklar, boşluklar (gaps), blur ve animasyon eğrileri
    │       ├── autostart.conf        # Başlangıçta çalışan servis ve uygulamalar (Noctalia, FDM, Steam)
    │       ├── env.conf              # Wayland ve grafik ortam değişkenleri (QT, GTK, XDG)
    │       ├── input.conf            # Klavye düzeni, fare ivmesi ve touchpad jestleri
    │       ├── keybinds.conf         # Sistem kısayolları ve Noctalia kabuk entegrasyonu
    │       ├── layout.conf           # Tiling motoru, master/stack ve kayan pencere (floating) düzeni
    │       ├── misc.conf             # Çeşitli compositor davranışları ve zamanlayıcılar
    │       ├── monitors.conf         # Ekran çözünürlükleri, ölçekleme ve VRR (G-Sync/FreeSync)
    │       └── rules.conf            # Pencere kuralları, otomatik etiketleme (tags) ve boyutlandırma
    ├── xdg-desktop-portal/
    │   └── mango-portals.conf        # XDG masaüstü portal yönlendirmesi
    └── xdg-desktop-portal-wlr/
        └── mango                     # Ekran paylaşımı ve pencere yakalama yapılandırması
```

---

## ⚙️ Modül Detayları (`cfg/`)

### 1. ⌨️ Kısayollar ve Noctalia Kabuk Entegrasyonu (`keybinds.conf`)
* **Uygulamalar:**
  * `Super + Enter`: Ghostty GPU terminalini açar.
  * `Super + E`: Dolphin dosya yöneticisini açar.
  * `Super + B`: Vivaldi web tarayıcısını açar.
  * `Super + Q`: Aktif pencereyi kapatır (`killclient`).
* **Noctalia Masaüstü Bileşenleri:**
  * `Super + Space`: Uygulama başlatıcı (Launcher / Rofi alternatifi).
  * `Super + .`: Emoji seçici.
  * `Super + S`: Kontrol merkezi (Hızlı ayarlar, ses, parlaklık).
  * `Super + Ctrl + S`: Noctalia ayarlar paneli.
  * `Super + V`: Pano (Clipboard) geçmişi.
  * `Super + W`: Wallhaven duvar kağıdı tarayıcısı.
  * `Super + L`: Ekranı kilitleme (`session lock`).
  * `Super + Shift + P` / `Super + Shift + Q`: Güç menüsü (Oturumu kapat, yeniden başlat, kapat).
* **Ekran Görüntüsü:**
  * `Print` / `Super + Shift + S` / `Super + P`: Bölgesel ekran görüntüsü alma aracı (`screenshot-region`).
  * `Super + Alt + P`: Tüm monitörleri kapsayan tam ekran görüntüsü (`screenshot-fullscreen all`).

### 2. 🎨 Görünüm, Blur ve Akıcı Animasyonlar (`appearance.conf`)
* **Boşluklar ve Kenarlıklar:** 10px iç ve dış pencere boşlukları (`gappih`, `gappoh`), 10px yuvarlatılmış köşeler (`border_radius = 10`), 4px odak kenarlığı (`borderpx = 4`).
* **Çift Geçişli Blur (Dual-pass Blur):** Optimize edilmiş blur motoru (`blur = 1`, `blur_optimized = 1`, `num_passes = 2`, `radius = 4`, `saturation = 1.2`).
* **Özel Bezier Animasyon Eğrileri:** Pencerelerin açılma, kapanma ve etiket geçişleri için optimize edilmiş yumuşak eğriler (`0.87, 0, 0.13, 1` ve `0.46, 1.0, 0.29, 1`).
* **İmleç:** `capitaine-cursors` teması (24px).

### 3. 🚀 Otomatik Başlatma (`autostart.conf`)
Oturum açıldığında arka planda otomatik devreye giren servisler:
* `noctalia`: Masaüstü durum çubuğu ve widget sistemi.
* `fdm --hidden`: Free Download Manager arka plan servisi.
* `steam -silent`: Steam istemcisi sessiz modda.
* `windscribe --autostart`: VPN istemcisi.
* `cachyos-hello`: Karşılama ekranı.

### 4. 🖥️ Ekran & Portal Köprüleri
* `monitors.conf`: Çoklu monitör düzeni ve yenileme hızları.
* `xdg-desktop-portal/mango-portals.conf` ve `xdg-desktop-portal-wlr/mango`: OBS Studio, Discord ve web tarayıcılarında sorunsuz Wayland ekran kaydı/paylaşımı desteği sağlar.
