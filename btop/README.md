# 📊 btop (Sistem ve Kaynak Monitörü)

C++ ile yazılmış, modern, özelleştirilebilir ve görsel olarak zengin terminal tabanlı sistem kaynak izleme aracı.

---

## 📦 Kurulum

Eğer sisteminizde kurulu değilse şu komutla kurabilirsiniz:

```bash
# Arch / CachyOS:
sudo pacman -S --needed btop
# veya AUR:
yay -S --needed btop
```

---

## 📁 Dosya Yapısı

```text
btop/
└── .config/
    └── btop/
        ├── btop.conf     # Ana yapılandırma dosyası (CPU, GPU, RAM, Disk, Ağ ayarları)
        └── themes/       # Özel renk temaları
```

---

## ⚙️ Yapılandırma Detayları

* **Grafikler:** CPU saat hızları, çekirdek yükleri ve sıcaklık sensörleri aktif.
* **GPU İzleme:** NVIDIA / AMD / Intel GPU yük ve bellek kullanım takibi.
* **Kısayollar:**
  * `m`: Bellek görünümünü değiştirir.
  * `p`: İşlem listesi sıralamasını değiştirir (CPU/RAM).
  * `q` / `Esc`: Çıkış.
