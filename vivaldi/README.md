# 🌐 Vivaldi (Gelişmiş Tarayıcı Özelleştirmeleri ve Modlar)

Güçlü kullanıcılar için tasarlanmış Vivaldi tarayıcısına yönelik özel CSS/JS arayüz modları ve Wayland başlatma bayrakları.

---

## 📦 Kurulum

Eğer sisteminizde kurulu değilse şu komutla kurabilirsiniz:

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
    ├── vivaldi-stable.conf      # Wayland yerel başlatma bayrakları (Ozone platformu)
    └── vivaldi-custom/
        └── userChrome/          # Özel CSS/JS UI arayüz modifikasyonları
```

---

## 🛠️ Orta Tık (Middle Click) Onarımı

Wayland ortamında Vivaldi'de orta tıkla yeni sekme açma davranışında sorun yaşanıyorsa ana dizindeki onarım betiğini çalıştırabilirsiniz:

```bash
./vivaldi_middle_click.sh
```
