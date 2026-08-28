# 🪐 Melih's Dotfiles

Kişisel **CachyOS / Arch Linux**, **KDE Plasma & Hyprland** masaüstü yapılandırmalarım, donanım optimizasyonlarım ve geliştirme ortamım.

Tüm sistem [GNU Stow](https://www.gnu.org/software/stow/) ile modüler paketler halinde yönetilmekte ve `install.sh` betiği ile yeni sistem kurulumları otomatikleştirilmektedir.

---

## 📋 İçindekiler
- [🚀 Hızlı Kurulum](#-hızlı-kurulum)
- [🧩 Modüler Kurulum Seçenekleri](#-modüler-kurulum-seçenekleri)
- [📦 Paket Yapısı & İçerik](#-paket-yapısı--i̇çerik)
- [📱 Sunshine & Tablet 2. Ekran Yapılandırması](#-sunshine--tablet-2-ekran-yapılandırması)
  - [Ekran & Çözünürlük Otomasyonu](#ekran--çözünürlük-otomasyonu)
  - [⚡ Laptop Pil/Priz Otomasyonu (KDE Güç Yönetimi)](#-laptop-pilpriz-otomasyonu-kde-güç-yönetimi)
- [🔐 Gizlilik & Manuel Yapılacaklar (Secrets)](#-gizlilik--manuel-yapılacaklar-secrets)
- [🛠️ Donanım & Sistem Betikleri](#️-donanım--sistem-betikleri)
- [🏗️ Yeni Paket Ekleme Rehberi](#️-yeni-paket-ekleme-rehberi)

---

## 🚀 Hızlı Kurulum

Yeni formatlanmış bir sisteme geçerken:

1. **Temel Paketleri Kur:**
   ```bash
   # Arch / CachyOS:
   sudo pacman -Syu --needed git base-devel

   # Fedora:
   sudo dnf install -y git @development-tools

   # Ubuntu / Debian:
   sudo apt update && sudo apt install -y git build-essential
   ```

2. **Repoyu Klonla:**
   ```bash
   git clone https://github.com/m24ih/dotfiles.git ~/Projects/dotfiles
   ```

3. **Otomatik Kurulumu Başlat:**
   ```bash
   cd ~/Projects/dotfiles
   chmod +x install.sh
   ./install.sh
   ```

---

## 🧩 Modüler Kurulum Seçenekleri

`install.sh` betiği bağımsız modüller halinde çalışabilir:

```bash
# Sadece dotfile sembolik bağlarını (stow) oluştur
./install.sh stow

# Sadece donanım/klavye ayarlarını uygula
./install.sh hardware

# Sadece sistem ve kullanıcı servislerini aktifleştir
./install.sh services

# Sadece UFW güvenlik duvarı kurallarını ayarla
./install.sh ufw

# Sadece yazı tiplerini (Nerd Fonts) kur
./install.sh fonts
```

| Modül Argümanı | Açıklama |
| :--- | :--- |
| `base` / `packages` | Temel geliştirme araçları (`git`, `base-devel`) |
| `pm` / `package-manager` | AUR yardımcısı (`yay`) veya dağıtım paket yöneticisi |
| `all` | `packages.txt` listesindeki tüm paketleri yükler |
| `flatpak` | `flat_packages.txt` listesindeki Flatpak'leri yükler |
| `stow` / `dotfiles` | Tüm paketleri `stow` ile `~` dizinine bağlar |
| `hardware` | Keychron klavye ve F tuşları modlarını uygular |
| `network` | Ağ yapılandırmaları ve iwd optimizasyonları |
| `services` | `setup_services.sh` ile systemd kullanıcı servislerini başlatır |
| `ufw` | Güvenlik duvarı kurallarını (Sunshine, SSH vb.) uygular |
| `warp` | Cloudflare WARP split tunnel yapılandırması |
| `fonts` | JetBrains Mono Nerd Font vb. fontları yükler |

---

## 📦 Paket Yapısı & İçerik

```text
~/Projects/dotfiles/
├── alacritty/    # Alacritty terminal yapılandırması
├── btop/         # Sistem monitörü teması ve ayarları
├── fastfetch/    # Sistem bilgi aracı & otomatik dağıtım logosu
├── fish/         # Fish shell yapılandırması & alias'lar
├── ghostty/      # Ghostty GPU terminal emülatörü
├── hypr/         # Hyprland Wayland pencere yöneticisi & keybinds
├── kitty/        # Kitty terminal yapılandırması
├── mpv/          # Video oynatıcı optimizasyonları & scriptler
├── niri/         # Niri scrollable tiling compositor
├── nvim/         # Neovim IDE yapılandırması
├── sunshine/     # Sunshine game streaming & sanal ekran ayarları
├── systemd/      # Kullanıcı seviyesi systemd servisleri (sunshine.service vb.)
├── vivaldi/      # Vivaldi tarayıcı CSS/JS modları & middle click fix
└── ...
```

---

## 📱 Sunshine & Tablet 2. Ekran Yapılandırması

Sunshine ve Moonlight kullanarak Android/iPad tabletleri bağımsız bir 2. monitör olarak kullanma altyapısı entegre edilmiştir.

### Ekran & Çözünürlük Otomasyonu
* **Yakalama Yöntemi:** KWin Wayland (`capture = kwin`)
* **Sanal Monitör:** `krfb-virtualmonitor` ile dinamik çözünürlük oluşturulur ve `kscreen-doctor` ile ana ekranın sağına konumlandırılır.
* **Yayın Başlarken:** Moonlight istemcisinden gelen çözünürlük (`${SUNSHINE_CLIENT_WIDTH}x${SUNSHINE_CLIENT_HEIGHT}`) otomatik algılanır ve sanal ekran başlatılır.
* **Yayın Bitince:** `undo` komutu ile sanal ekran otomatik kapatılır.

### ⚡ Laptop Pil/Priz Otomasyonu (KDE Güç Yönetimi)
Laptop pildeyken gereksiz pil tüketimini önlemek için Sunshine servisi **sadece prize takılıyken çalışacak** şekilde yapılandırılmalıdır:

> [!IMPORTANT]
> **KDE Sistem Ayarları Üzerinden Yapılacak Ayar:**
> 1. **Sistem Ayarları** → **Güç Yönetimi (Power Management)** → **Enerji Tasarrufu (Energy Saving)** sayfasına gidin.
> 2. **"On Battery" (Pildeyken)** sekmesi:
>    * En alttaki **Run command or script** seçeneğinden koşulu seçin ve şu komutu girin:
>      ```bash
>      systemctl --user stop sunshine.service
>      ```
> 3. **"On AC Power" (Prizdeyken)** sekmesi:
>    * En alttaki **Run command or script** seçeneğinden koşulu seçin ve şu komutu girin:
>      ```bash
>      systemctl --user start sunshine.service
>      ```
> 4. **Apply (Uygula)** butonuna basarak kaydedin.

---

## 🔐 Gizlilik & Manuel Yapılacaklar (Secrets)

Kurulum sonrası **güvenlik nedeniyle depoda tutulmayan** kişisel anahtarları 1Password üzerinden manuel olarak yerine koyun:

* `~/.config/rclone/rclone.conf` (Cloud / Drive token'ları)
* `~/.config/gh/hosts.yml` (GitHub CLI oturum token'ı)
* `~/.ssh/` (SSH özel anahtarları)
* `~/.config/sunshine/credentials/` & `sunshine_state.json` (Sunshine SSL sertifikaları & cihaz eşleşmeleri)

> [!NOTE]
> `.gitignore` dosyası; SSL sertifikalarını (`.pem`, `.key`), Sunshine kimliklerini (`credentials/`, `sunshine_state.json`), logları (`*.log`) ve secret dosyalarını repoya dahil etmeyecek şekilde yapılandırılmıştır.

---

## 🛠️ Donanım & Sistem Betikleri

Dotfiles deposu, donanım uyumluluğu ve ağ optimizasyonu için özel yardımcı betikler barındırır:

* `setup_fkeys.sh`: Apple/Fn tuş davranışlarını F1-F12 standart düzenine çevirir.
* `setup_keychron.sh`: Keychron kablosuz/kablolu klavye modu ve Bluetooth optimizasyonları.
* `setup_ufw.sh`: Güvenlik duvarını (Sunshine, SSH vb. izinleri) tek komutla kurar.
* `setup_services.sh`: Dağıtıma göre systemd servislerini devreye alır.
* `vivaldi_middle_click.sh`: Wayland ortamında Vivaldi orta tık sekme açma davranışını düzeltir.

---

## 🏗️ Yeni Paket Ekleme Rehberi

Yeni bir aracın (örn: `rofi`) ayarlarını dotfiles sistemine dahil etmek için:

```bash
cd ~/Projects/dotfiles

# 1. Paket klasörünü ve taklit dizinini oluştur
mkdir -p rofi/.config

# 2. Mevcut yapılandırmayı taşı
mv ~/.config/rofi rofi/.config/

# 3. Stow ile bağla
stow -R -t "$HOME" rofi

# 4. install.sh içindeki STOW_PACKAGES dizisine "rofi" ekle ve commit yap
git add .
git commit -m "feat(rofi): add rofi configuration"
```