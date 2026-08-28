# 🌐 Vivaldi (Gelişmiş Tarayıcı Modları ve Kaydırma Ayarları)

Vivaldi web tarayıcısına yönelik Windows tarzı orta tık otomatik kaydırma (Middle Click Autoscroll) desteği ve sekme favicon'larını temizleyen özel CSS modları.

---

## 📦 Kurulum ve Medya Kodekleri

Eğer sisteminizde Vivaldi ve tescilli video kodekleri (H.264/AAC vb.) eksikse:

```bash
# Arch / CachyOS:
sudo pacman -S --needed vivaldi vivaldi-ffmpeg-codecs
# veya AUR:
yay -S --needed vivaldi vivaldi-ffmpeg-codecs
```

---

## 📁 Dosya Yapısı

```text
vivaldi/
└── .config/
    ├── vivaldi-stable.conf      # Chromium/Blink bayrakları (MiddleClickAutoscroll)
    └── vivaldi-custom/
        └── userChrome/
            └── custom.css       # Sekme favicon efektlerini sıfırlayan temizlik CSS'i
```

---

## ⚙️ Yapılandırma Detayları

### 1. 🖱️ Orta Tık Otomatik Kaydırma (Middle Click Autoscroll)
* `vivaldi-stable.conf` içerisindeki `--enable-blink-features=MiddleClickAutoscroll` ve `--enable-features=MiddleClickAutoscroll` bayrakları sayesinde farenin tekerlek (orta) tuşuna basıldığında sayfa fare hareket yönüne göre otomatik kaydırılır.
* İlgili ayarı sisteme uygulamak için ana dizindeki `./vivaldi_middle_click.sh` betiği de kullanılabilir.

### 2. 🎨 Favicon Arayüz Temizliği (`custom.css`)
* Vivaldi temalarındaki sekme ikonlarının (favicon) etrafında oluşan istenmeyen gölge, kenarlık (border) ve arka plan kutucuklarını kaldırarak pürüzsüz ve modern bir görünüm sağlar.
