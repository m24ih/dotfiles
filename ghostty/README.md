# 👻 Ghostty (Modern GPU Terminal Emülatörü)

Donanım hızlandırmalı, düşük gecikmeli, otomatik tema geçişi ve uzun süren komut bildirimleri içeren Ghostty terminal yapılandırması.

---

## 📦 Kurulum ve Yazı Tipi

Eğer sisteminizde kurulu değilse şu komutla kurabilirsiniz:

```bash
# Arch / CachyOS:
sudo pacman -S --needed ghostty ttf-jetbrains-mono-nerd
# veya AUR:
yay -S --needed ghostty ttf-jetbrains-mono-nerd
```

---

## 📁 Dosya Yapısı

```text
ghostty/
└── .config/
    └── ghostty/
        ├── config.ghostty    # Ana Ghostty yapılandırması (Görünüm, pano, bildirimler)
        ├── themes/           # Renk temaları
        └── auto/             # Otomatik tema değişkenleri
```

---

## ⚙️ Yapılandırma Detayları (`config.ghostty`)

### 1. 🎨 Dinamik Tema ve Görsel Ayarlar
* **Açık/Koyu Mod Adaptasyonu:** `theme = dark:TokyoNight Night,light:TokyoNight Day` ile sistem temasına göre otomatik koyu/açık Tokyo Night teması.
* **Saydamlık:** `%90` opaklık (`background-opacity = 0.9`).
* **Yazı Tipi:** `JetBrains Mono` (11 pt).

### 2. 🔔 Uzun Süren Komut Bildirimleri (Notification on Finish)
* **Otomatik Masaüstü Bildirimi:** `notify-on-command-finish-after = 20s`
* 20 saniyeden uzun süren bir derleme veya indirme komutu tamamlandığında Ghostty arka plandayken dahi masaüstünüze bildirim gönderir.

### 3. 📋 Akıllı Pano ve Fare Davranışı
* **Seçimde Otomatik Kopyalama:** `copy-on-select = clipboard` ile fareyle seçtiğiniz metin doğrudan panoya kopyalanır.
* **Orta Tuş Yapıştırma Uyumu:** `mouse-shift-capture = never` sayesinde Shift+Orta tuş ile terminal içindeki uygulamalara (Neovim vb.) takılmadan doğrudan pano içeriği yapıştırılabilir.
