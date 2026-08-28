# 🚀 Fastfetch (Sistem Bilgi Aracı)

Neofetch benzeri ancak C ile yazılmış, ultra hızlı ve detaylı sistem bilgisi gösterme aracı.

---

## 📦 Kurulum

Eğer sisteminizde kurulu değilse şu komutla kurabilirsiniz:

```bash
# Arch / CachyOS:
sudo pacman -S --needed fastfetch
# veya AUR:
yay -S --needed fastfetch
```

---

## 📁 Dosya Yapısı

```text
fastfetch/
└── .config/
    └── fastfetch/
        ├── config.jsonc     # Ana fastfetch JSON şablonu (Donanım, OS, Bellek modülleri)
        ├── hyde.jsonc       # Hyde teması yapılandırması
        ├── update-logo.sh   # Çalışan dağıtıma göre uygun ASCII/Resim logosunu seçen script
        └── logo/            # Dağıtım logoları
```

---

## ⚙️ Özellikler

* **Otomatik Dağıtım Logosu:** `update-logo.sh` betiği `/etc/os-release` dosyasını okuyarak CachyOS, Arch, Fedora veya Ubuntu logosunu dinamik olarak atar.
* **Donanım Bilgileri:** Kernel, CPU, GPU, Bellek kullanımı, Pil durumu ve Uptime bilgisi.
