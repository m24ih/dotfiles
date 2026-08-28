# 🚀 Fastfetch (Sistem Bilgi Aracı)

Neofetch benzeri ancak C ile yazılmış, donanım ve işletim sistemi ayrıntılarını milisaniyeler içinde gösteren yüksek performanslı sistem bilgi aracı.

---

## 📦 Kurulum ve Bağımlılıklar

Eğer sisteminizde `fastfetch` veya alt modülleri eksikse:

```bash
# Ana Paket (Arch / CachyOS):
sudo pacman -S --needed fastfetch
# veya AUR:
yay -S --needed fastfetch

# İsteğe Bağlı (Alt alıntı sözleri için):
sudo pacman -S --needed fortune-mod
```

---

## 📁 Dosya Yapısı

```text
fastfetch/
└── .config/
    └── fastfetch/
        ├── config.jsonc     # Ana fastfetch modül ve görsel şablonu
        ├── hyde.jsonc       # HyDE tema varyantı
        ├── update-logo.sh   # Dağıtıma göre uygun resmi/logoyu seçen betik
        └── logo/            # Dağıtım logoları (CachyOS, Arch, Fedora vb.)
```

---

## ⚙️ Yapılandırma ve Özel Modüller (`config.jsonc`)

Bu yapılandırma, sisteminize özel olarak tasarlanmış şu modülleri içerir:

### 1. 🖼️ Kitty Görsel Protokolü ile Dinamik Logo
* **Görsel Render:** `logo.type = "kitty"` kullanılarak terminal içinde yüksek kaliteli resim render edilir (`height: 18`).
* **Otomatik Dağıtım Tespiti (`update-logo.sh`):** `/etc/os-release` dosyasındaki `ID` ve `LOGO` parametrelerine bakılarak sistemin CachyOS, Arch, Fedora veya Ubuntu olmasına göre `os-logo.png` sembolik bağı otomatik yenilenir.

### 2. 📊 Donanım ve Sistem Modülleri
* **Ekran & Yenileme Hızı:** `󰍹 Display`: Çözünürlük, yenileme hızı ve ölçek bilgisi (`{1}x{2} @ {3}Hz [{7}]`).
* **GPU & Sürücü Ayrımı:** `󰊴 GPU` modeli ve hemen altında ` GPU Driver` sürümü ayrı satırlarda gösterilir.
* **Sistem Yaşı (`󱦟 OS Age`):** Kök dizinin (`/`) oluşturulma tarihinden bu yana geçen gün sayısı (`{days} days`).
* **Akıllı Alt Bilgi:** En alt satırda Hyprland açıksa `hyprctl splash`, değilse rastgele bir `fortune` sözü yazdırılır.
