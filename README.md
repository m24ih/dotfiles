# 🪐 Melih's Dotfiles

Kişisel **CachyOS / Arch Linux**, **KDE Plasma & Hyprland** masaüstü yapılandırmalarım, donanım optimizasyonlarım ve geliştirme ortamım.

Tüm sistem [GNU Stow](https://www.gnu.org/software/stow/) ile modüler paketler halinde yönetilmekte ve yenilenen JaKooLit tarzı interaktif `install.sh` betiği ile yeni sistem kurulumları güvenli ve seçici biçimde otomatikleştirilmektedir.

---

## 📋 İçindekiler
- [🚀 Hızlı Kurulum](#-hızlı-kurulum)
- [🧩 Modüler Kurulum Seçenekleri](#-modüler-kurulum-seçenekleri)
  - [Komut Satırı Bayrakları (CLI Flags)](#komut-satırı-bayrakları-cli-flags)
  - [Desteklenen Modüller (22 Adet)](#desteklenen-modüller-22-adet)
- [📦 Modüler Paket Yapısı (packages/)](#-modüler-paket-yapısı-packages)
- [📂 Dotfiles Dizin Yapısı & GNU Stow](#-dotfiles-dizin-yapısı--gnu-stow)
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

> [!TIP]
> **JaKooLit Tarzı İnteraktif Sihirbaz:** `./install.sh` varsayılan olarak kullanıcı dostu, kategorize edilmiş interaktif bir sihirbaz başlatır. Her bileşen için akılcı varsayılanlarla `[Y/n]` veya `[y/N]` seçimi yapabilirsiniz. Tüm sorular tamamlandığında seçilen paket dosyaları, sembolik bağlar (`stow`) ve yapılandırma betikleri formatlı bir özet kutusunda gösterilerek onayınız istenir.

> [!NOTE]
> **Güvenli Simülasyon Modu (`--dry-run`):** Sisteme herhangi bir paket yüklemeden veya dosya değiştirmeden önce planlanan tüm adımları güvenle simüle edebilirsiniz:
> ```bash
> # İnteraktif seçimlerle simülasyon:
> ./install.sh --dry-run
>
> # Varsayılan bileşenlerle simülasyon:
> ./install.sh --dry-run --default
> ```

---

## 🧩 Modüler Kurulum Seçenekleri

`install.sh` betiği hem tam interaktif bir sihirbaz olarak hem de komut satırı bayrakları ve modül argümanlarıyla tam otomatik olarak çalıştırılabilir:

```bash
# 1. Varsayılan İnteraktif Sihirbaz (JaKooLit tarzı soru akışı)
./install.sh

# 2. Güvenli Simülasyon Modu (Hiçbir sistem değişikliği yapmaz)
./install.sh --dry-run

# 3. Hızlı Varsayılan Kurulum (Soru sormadan 12 varsayılan [Y] bileşeni kurar)
./install.sh --default

# 4. Tam Kurulum (Soru sormadan tüm 22 bileşeni kurar)
./install.sh --all

# 5. Seçici Modül Kurulumu (Yalnızca belirtilen modülleri kurar)
./install.sh hypr fish ghostty

# 6. Seçici Modül Simülasyonu
./install.sh --dry-run hypr mango

# 7. Yardım Ekranı ve Kullanım Bilgisi
./install.sh --help
```

### Komut Satırı Bayrakları (CLI Flags)

| Bayrak | Kısa | Açıklama |
| :--- | :---: | :--- |
| `--dry-run` | `-n` | **Simülasyon Modu:** Hiçbir paket kurmaz, dosya bağlamaz veya betik çalıştırmaz; 4 fazlı yürütme planını detaylı olarak ekrana yazdırır. |
| `--default` | `-d` | **Varsayılan Mod:** Soru sormadan onaylanan 12 varsayılan modülü (`ghostty`, `fish`, `nvim`, `browser`, `social`, `dev`, `productivity`, `media`, `networking`, `services`, `fonts`, `base_cli`) doğrudan kurar. |
| `--all` | `-a` | **Tam Mod:** Soru sormadan sistemdeki tüm 22 modülü eksiksiz olarak kurar. |
| `--help` | `-h` | **Yardım:** Kullanım yönergelerini, tüm bayrakları ve desteklenen modül listesini yazdırır. |
| `<modül...>` | - | **Pozisyonel Modül Argümanları:** Sihirbazı atlayarak yalnızca argüman olarak verilen modülleri kurar (`--dry-run` ile birleştirilebilir). |

### Desteklenen Modüller (22 Adet)

Kurulum motoru 5 ana kategoride toplam 22 modül destekler:

| Kategori | Modül | Varsayılan | Açıklama | Paket Listesi | Stow Paketi |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **Masaüstü & Pencere Yöneticileri** | `hypr` | `[y/N]` | Hyprland dinamik Wayland pencere yöneticisi & masaüstü araçları | `packages/hypr.txt` | `hypr` |
| | `niri` | `[y/N]` | Niri kaydırmalı (scrollable-tiling) Wayland compositor | `packages/niri.txt` | `niri` |
| | `mango` | `[y/N]` | MangoWM hafif ve akıcı Wayland pencere yöneticisi | `packages/mango.txt` | `mango` |
| **Terminal Emülatörleri** | `ghostty` | `[Y/n]` | Ghostty modern GPU hızlandırmalı terminal | `packages/ghostty.txt` | `ghostty` |
| | `kitty` | `[y/N]` | Kitty GPU hızlandırmalı terminal emülatörü | `packages/kitty.txt` | `kitty` |
| **Kabuk, Editör & CLI** | `fish` | `[Y/n]` | Fish kabuğu ve Starship çapraz komut istemi | `packages/fish.txt` | `fish`, `starship` |
| | `nvim` | `[Y/n]` | Neovim modern metin editörü (Lazy.nvim ekosistemi) | `packages/nvim.txt` | `nvim` |
| | `base_cli` | `[Y/n]` | Temel modern CLI araçları (`bat`, `zoxide`, `btop`, `fastfetch` vb.) | `packages/base_cli.txt` | `btop`, `fastfetch`, `user-dirs` |
| **Uygulamalar & Üretkenlik** | `browser` | `[Y/n]` | Vivaldi web tarayıcısı ve ortam iyileştirmeleri | `packages/browser.txt` | `vivaldi` |
| | `social` | `[Y/n]` | İletişim araçları (Vesktop, Telegram, Signal, Teams) | `packages/social.txt` | - |
| | `dev` | `[Y/n]` | Geliştirici ortamı (VS Code, Docker, DBeaver, Node.js) | `packages/dev.txt` | - |
| | `productivity` | `[Y/n]` | Üretkenlik & parola yönetimi (Obsidian, Proton Pass, KeePassXC) | `packages/productivity.txt` | - |
| | `media` | `[Y/n]` | Medya & indirme araçları (Haruna, OBS Studio, qBittorrent, Kdenlive) | `packages/media.txt` | - |
| | `networking` | `[Y/n]` | Ağ & VPN araçları (Tailscale, Cloudflare WARP, Syncthing, RustDesk) | `packages/networking.txt` | `ssh` |
| | `sunshine` | `[y/N]` | Sunshine GameStream oyun ve ekran yayını sunucusu | `packages/sunshine.txt` | `sunshine` |
| | `flatpak` | `[y/N]` | Flatpak paketleri kurulumu | `flat_packages.txt` | - |
| **Donanım, Sistem & Fontlar** | `hardware` | `[y/N]` | TLP güç yönetimi ve UFW güvenlik duvarı yapılandırması | `packages/hardware.txt` | - |
| | `keychron` | `[y/N]` | Keychron mekanik klavye Bluetooth & F-tuş optimizasyonları | - | - |
| | `fkeys` | `[y/N]` | Apple klavye Fn/F-tuş davranış modu (F1-F12 standart düzen) | - | - |
| | `iwd` | `[y/N]` | NetworkManager için iwd Wi-Fi backend geçişi (düşük jitter) | - | - |
| | `services` | `[Y/n]` | Dağıtıma özel systemd sistem ve kullanıcı servisleri | - | `systemd` |
| | `fonts` | `[Y/n]` | JetBrains Mono Nerd Font ve sistem font önbelleği | - | - |

> [!NOTE]
> Temel sistem paketlerini barındıran `packages/base.txt` (`git`, `base-devel`, `stow`, `sudo`, `curl` vb.), modül seçiminden bağımsız olarak her kurulum işleminde zorunlu temel katman olarak otomatik dahil edilir.

---

## 📦 Modüler Paket Yapısı (`packages/`)

Eski sistemdeki 1660 satırlık hantal, bakım zorluğu yaratan ve alt kütüphane bağımlılıklarıyla şişmiş monolitik `packages.txt` dosyası tamamen kaldırılarak yerine **modüler ve temiz `packages/*.txt` dizin mimarisine** geçilmiştir.

### Neden Modüler Yapı?
- **Bağımlılık Temizliği:** Dağıtım paket yöneticilerinin (`pacman` / `yay`) dinamik olarak çözebildiği yüzlerce ikincil kütüphane ve `lib*` bağımlılığı listelerden temizlenmiş, yalnızca **kullanıcı odaklı birincil uygulamalar** tutulmuştur.
- **Seçici ve Esnek Kurulum:** Tüm yazılımları zorunlu olarak kurmak yerine kullanıcı sadece ihtiyaç duyduğu kategorileri (örneğin sadece `hypr` veya `dev`) seçebilir.
- **Toplu ve Optimize Yürütme:** `install.sh`, seçilen tüm modüllerin `.txt` dosyalarını otomatik olarak birleştirir (`sort -u`) ve tek seferde `yay` çağrısı yaparak paketleri mükerrer işlem yapmadan kurar.

### `packages/` Dizinindeki Paket Dosyaları (17 Adet)

| Paket Dosyası | Temsil Ettiği Kategori / Alan | Başlıca / Örnek Paketler |
| :--- | :--- | :--- |
| [`packages/base.txt`](packages/base.txt) | **Temel Sistem Paketleri** (Zorunlu temel katman) | `git`, `base-devel`, `stow`, `which`, `curl`, `wget`, `sudo`, `xdg-user-dirs` |
| [`packages/base_cli.txt`](packages/base_cli.txt) | **Modern CLI & Terminal Araçları** | `bat`, `zoxide`, `btop`, `fastfetch`, `duf`, `ripgrep`, `jq`, `topgrade`, `7zip` |
| [`packages/browser.txt`](packages/browser.txt) | **Web Tarayıcı** | `vivaldi`, `vivaldi-ffmpeg-codecs` |
| [`packages/dev.txt`](packages/dev.txt) | **Geliştirici & Konteyner Ortamı** | `code`, `docker`, `docker-compose`, `lazydocker`, `dbeaver`, `nodejs`, `npm` |
| [`packages/fish.txt`](packages/fish.txt) | **Fish Kabuğu & Eklentiler** | `fish`, `fisher`, `starship`, `cachyos-fish-config` |
| [`packages/ghostty.txt`](packages/ghostty.txt) | **Ghostty Terminal Emülatörü** | `ghostty` |
| [`packages/hardware.txt`](packages/hardware.txt) | **Donanım & Güç Yönetimi** | `tlp`, `tlp-pd`, `tlp-rdw`, `tlpui`, `ufw` |
| [`packages/hypr.txt`](packages/hypr.txt) | **Hyprland Wayland Masaüstü** | `hyprland`, `waybar`, `hyprpaper`, `hyprlock`, `hypridle`, `wl-clipboard` |
| [`packages/kitty.txt`](packages/kitty.txt) | **Kitty Terminal Emülatörü** | `kitty` |
| [`packages/mango.txt`](packages/mango.txt) | **MangoWM Pencere Yöneticisi** | `mangowm` |
| [`packages/media.txt`](packages/media.txt) | **Medya, Kayıt & İndirme** | `haruna`, `obs-studio`, `kdenlive`, `qbittorrent`, `freedownloadmanager` |
| [`packages/networking.txt`](packages/networking.txt) | **Ağ, VPN & Uzak Erişim** | `tailscale`, `cloudflare-warp-bin`, `syncthing`, `rclone`, `rustdesk-bin` |
| [`packages/niri.txt`](packages/niri.txt) | **Niri Scrollable Compositor** | `niri`, `fuzzel`, `xdg-desktop-portal-gnome`, `polkit-gnome` |
| [`packages/nvim.txt`](packages/nvim.txt) | **Neovim Editör & Bağımlılıkları** | `neovim`, `ripgrep`, `fd`, `tree-sitter` |
| [`packages/productivity.txt`](packages/productivity.txt) | **Üretkenlik & Parola Yönetimi** | `obsidian`, `proton-pass`, `proton-pass-cli-bin`, `calibre`, `keepassxc` |
| [`packages/social.txt`](packages/social.txt) | **İletişim & Sosyal Medya** | `vesktop`, `telegram-desktop`, `signal-desktop`, `teams-for-linux` |
| [`packages/sunshine.txt`](packages/sunshine.txt) | **Sunshine GameStream Sunucusu** | `sunshine` |

---

## 📂 Dotfiles Dizin Yapısı & GNU Stow

Her paket kendi dizininde `~` (home) yapısını taklit eder. Özel notlar ve detaylı rehberler ilgili paketin kendi `README.md` dosyasında belgelenmiştir:

| Paket | Açıklama | Dokümantasyon |
| :--- | :--- | :---: |
| [`btop/`](btop/) | Sistem ve donanım izleme aracı | [📖 İncele](btop/README.md) |
| [`fastfetch/`](fastfetch/) | Sistem bilgi aracı & otomatik dağıtım logosu | [📖 İncele](fastfetch/README.md) |
| [`fish/`](fish/) | Fish shell yapılandırması, fonksiyonlar & alias'lar | [📖 İncele](fish/README.md) |
| [`ghostty/`](ghostty/) | Modern GPU terminal emülatörü | [📖 İncele](ghostty/README.md) |
| [`hypr/`](hypr/) | Hyprland Wayland pencere yöneticisi & kısayollar | [📖 İncele](hypr/README.md) |
| [`kitty/`](kitty/) | Özelleştirilebilir terminal emülatörü | [📖 İncele](kitty/README.md) |
| [`mango/`](mango/) | MangoWM hafif ve akıcı Wayland pencere yöneticisi | [📖 İncele](mango/README.md) |
| [`niri/`](niri/) | Niri scrollable tiling Wayland compositor | [📖 İncele](niri/README.md) |
| [`nvim/`](nvim/) | Neovim IDE yapılandırması (Lazy.nvim) | [📖 İncele](nvim/README.md) |
| [`ssh/`](ssh/) | SSH istemci ayarları & sunucu ağ erişim kısıtlamaları | [📖 İncele](ssh/README.md) |
| [`starship/`](starship/) | Çapraz kabuk (Cross-shell) komut istemi | [📖 İncele](starship/README.md) |
| [`sunshine/`](sunshine/) | Sunshine GameStream, tablet 2. ekran & güç yönetimi | [📖 İncele](sunshine/README.md) |
| [`systemd/`](systemd/) | Kullanıcı seviyesi systemd servisleri | [📖 İncele](systemd/README.md) |
| [`user-dirs/`](user-dirs/) | Standart XDG kullanıcı dizinleri | [📖 İncele](user-dirs/README.md) |
| [`vivaldi/`](vivaldi/) | Vivaldi CSS/JS modları & orta tık sekme onarımı | [📖 İncele](vivaldi/README.md) |
| [`zshrc.d/`](zshrc.d/) | Modüler Zsh yapılandırma betikleri | [📖 İncele](zshrc.d/README.md) |

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

* `scripts/setup_fkeys.sh`: Apple/Fn tuş davranışlarını F1-F12 standart düzenine çevirir.
* `scripts/setup_keychron.sh`: Keychron kablosuz/kablolu klavye modu ve Bluetooth optimizasyonları.
* `scripts/setup_ufw.sh`: Güvenlik duvarını (Sunshine, SSH vb. izinleri) tek komutla kurar.
* `scripts/setup_sshd.sh`: SSH sunucusuna (`sshd`) ağ erişim kısıtlamalarını (`/etc/ssh/sshd_config.d/`) kurar.
* `scripts/setup_services.sh`: Dağıtıma göre systemd servislerini devreye alır.
* `scripts/setup_fonts.sh`: Nerd Font ve sistem yazı tiplerini kurar ve font önbelleğini günceller.
* `scripts/setup_npm.sh`: Global npm dizini izinlerini ve ortam yolu yapılandırmasını ayarlar.
* `scripts/setup_1password.sh`: 1Password için özel tarayıcı izinlerini (`/etc/1password/custom_allowed_browsers`) yapılandırır.
* `scripts/setup_discord_proxy.sh`: Discord proxy ve güvenli erişim ayarlarını kurar.
* `scripts/setup_warp.sh`: Cloudflare WARP split tunnel kurallarını uygular.
* `scripts/switch_to_iwd.sh`: NetworkManager için iwd Wi-Fi backend geçişi sağlar.
* `scripts/vivaldi_middle_click.sh`: Wayland ortamında Vivaldi orta tık sekme açma davranışını düzeltir.
* `scripts/install_flatpaks.sh`: `flat_packages.txt` listesindeki Flatpak uygulamalarını yükler.

---

## 🏗️ Yeni Paket Ekleme Rehberi

Yeni bir aracın (örn: `rofi`) ayarlarını dotfiles sistemine dahil etmek için:

```bash
cd ~/Projects/dotfiles

# 1. Paket klasörünü ve taklit dizinini oluştur
mkdir -p rofi/.config

# 2. Mevcut yapılandırmayı taşı
mv ~/.config/rofi rofi/.config/

# 3. (Opsiyonel) Pakete özel README.md ekle
# Not: .stow-local-ignore sayesinde README.md dosyaları $HOME dizinine bağlanmaz.

# 4. Stow ile bağla
stow -R -t "$HOME" rofi

# 5. İlgili modülün packages/<modül>.txt listesine paket adını ekle
#    veya install.sh / stow_all.sh bileşen kaydına dahil et
git add .
git commit -m "feat(rofi): add rofi configuration"
```
