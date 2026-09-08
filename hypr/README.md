# 🪟 Hyprland (Dinamik Tiling Wayland Pencere Yöneticisi)

Akıcı animasyonlar, yuvarlatılmış köşeler, dinamik blur efektleri, yerel yapay zeka (Ollama) entegrasyonu, görsel arama ve akıllı uygulama başlatıcı betikleri barındıran Hyprland yapılandırması.

---

## 📦 Kurulum ve Temel Bileşenler

Hyprland ortamının eksiksiz çalışması için gerekli sistem paketleri:

```bash
# Ana Paketler (Arch / CachyOS):
sudo pacman -S --needed hyprland hyprpaper hyprlock hypridle xdg-desktop-portal-hyprland polkit-gnome

# Ekran ve Monitör Yönetimi İçin (İsteğe Bağlı GUI):
sudo pacman -S --needed nwg-displays
```

---

## 📁 Dizin ve Dosya Yapısı

```text
hypr/
└── .config/
    └── hypr/
        ├── hyprland.conf                 # Ana Hyprland başlatıcı ve modül yöneticisi
        ├── monitors.conf                 # Monitör çözünürlükleri ve konumlandırma (nwg-displays uyumlu)
        ├── workspaces.conf               # Çalışma alanı kuralları ve monitör eşlemeleri
        ├── hypridle.conf                 # Boşta kalma, ekran karartma ve otomatik kilit zamanlayıcıları
        ├── hyprlock.conf                 # Modern kilit ekranı arayüzü
        ├── hyprlock/
        │   ├── status.sh                 # Kilit ekranı pil ve ağ durum göstergesi
        │   └── check-capslock.sh         # Caps Lock uyarısı
        ├── custom/
        │   ├── keybinds.conf             # Kullanıcıya özel kısayol tuşları
        │   ├── env.conf                  # Özel ortam değişkenleri
        │   ├── execs.conf                # Özel başlangıç servisleri
        │   └── rules.conf                # Pencere kuralları ve istisnalar
        └── hyprland/
            ├── colors.conf               # Dinamik renk şemaları
            └── scripts/
                ├── launch_first_available.sh  # Sistemde mevcut ilk uygulamayı seçip başlatan fallback motoru
                ├── snip_to_search.sh          # Seçilen ekran alanını görsel arama motoruna gönderen araç
                ├── fuzzel-emoji.sh            # Fuzzel arayüzü ile emoji seçici
                ├── zoom.sh                    # Wayland ekran büyüteci (magnifier)
                └── ai/
                    ├── primary-buffer-query.sh    # Seçilen metni yerel Ollama modeline sorgulayan betik
                    └── show-loaded-ollama-models.sh # Yüklü yerel AI modellerini bildirim olarak gösterici
```

---

## ⚙️ Özel Kısayollar (`custom/keybinds.conf`)

* **`Ctrl + Shift + Esc`:** Ghostty içinde doğrudan **`btop`** kaynak izleyicisini açar (Hızlı Görev Yöneticisi).
* **`Super + W`:** Vivaldi tarayıcısını orta tık otomatik kaydırma desteğiyle (`--enable-features=MiddleClickAutoscroll`) başlatır.
* **`Super + X`:** **Obsidian** not uygulamasını açar.
* **`Ctrl + Super + /`:** Shell yapılandırmasını Ghostty + Neovim ile düzenler.
* **`Ctrl + Super + Alt + /`:** Hyprland kısayol dosyasını hızlıca açar.
* **`Ctrl + Super + Shift + Alt + W`:** Mevcut ofis paketini (WPS / OnlyOffice / LibreOffice) başlatır.
* **`XF86Calculator`:** Hesap makinesini açar.

---

## 🧠 Akıllı Yardımcı Betikler (`hyprland/scripts/`)

1. **`launch_first_available.sh` (Esnek Başlatıcı):**
   - Belirtilen uygulama listesi arasından sistemde kurulu olan ilk alternatifi otomatik tespit eder. Örneğin bir metin editörü çağrıldığında sırasıyla `obsidian -> kate -> gnome-text-editor -> emacs` dener.
2. **`ai/primary-buffer-query.sh` (Yerel AI Sorgulama):**
   - Fare ile seçtiğiniz herhangi bir metni doğrudan yerel **Ollama** LLM modeline yönlendirip hızlı yanıt almanızı sağlar.
3. **`snip_to_search.sh` (Görsel Arama):**
   - `slurp` ve `grim` ile ekrandan kırpılan görseli Google Lens veya görsel arama motoruna aktarır.
4. **`zoom.sh` (Ekran Büyüteci):**
   - İnce detayları incelemek veya sunum yapmak için pürüzsüz yakınlaştırma sağlar.

---

## 🔒 Ekran Kilidi ve Güç Yönetimi (`hyprlock` & `hypridle`)

* **`hypridle.conf`:**
  * 2.5 dakika boşta kalınca ekran parlaklığını kısar.
  * 5 dakika boşta kalınca `hyprlock` ile ekranı kilitler.
  * 5.5 dakika boşta kalınca ekranı kapatır (`dpms off`).
  * Laptop kapağı kapandığında anında ekranı kilitler.
* **`hyprlock.conf`:**
  * `hyprlock/check-capslock.sh` ile büyük harf kilidini denetler.
  * `hyprlock/status.sh` ile pil durumunu ve ağ bağlantısını şık bir formatta sunar.
