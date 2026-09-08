# Tasarım Şartnamesi: JaKooLit Tarzı İnteraktif ve Modüler Kurulum Sihirbazı (Interactive Installer)

**Tarih:** 2026-09-08  
**Durum:** Onaylandı  
**Kapsam:** Architectural  

---

## 1. Genel Bakış ve Amaç

Bu çalışmanın amacı, dotfiles kurulum deneyimini JaKooLit'in Hyprland dotfiles kurulum sihirbazına benzer şekilde interaktif, kullanıcı dostu ve modüler hale getirmektir.

Mevcut 1660 satırlık devasa ve bağımlılıklarla dolu `packages.txt` dosyası kaldırılarak; bağımlılıklarından arındırılmış, yalnızca ana programları içeren modüler `packages/*.txt` dosyaları oluşturulacaktır. Kullanıcı `install.sh` betiğini çalıştırdığında kategorik sorularla karşılaşacak; seçtiği bileşenlerin (`y/N`) durumuna göre hem ilgili paketler kurulacak hem de GNU Stow ile yalnızca seçilen bileşenlerin dotfile yapılandırmaları ev dizinine (`$HOME`) bağlanacaktır. Ayrıca `--dry-run` dahil otomasyon ve simülasyon bayrakları desteklenecektir.

---

## 2. Modüler Paket Dosyaları (`packages/`)

1660 satırlık eski `packages.txt` silinecek ve yerine `packages/` dizini altında aşağıdaki temiz listeler oluşturulacaktır:

1. **`packages/base.txt` (Zorunlu Temel Paketler):**
   - `git`, `base-devel`, `stow`, `which`, `curl`, `wget`, `bash-completion`, `sudo`, `xdg-user-dirs`
2. **`packages/hypr.txt`:**
   - `hyprland`, `hyprpaper`, `hyprlock`, `hypridle`, `xdg-desktop-portal-hyprland`, `polkit-gnome`, `nwg-displays`, `waybar`, `brightnessctl`, `wl-clipboard`
3. **`packages/niri.txt`:**
   - `niri`, `xdg-desktop-portal-gnome`, `polkit-gnome`, `fuzzel`
4. **`packages/mango.txt`:**
   - `mangowm`
5. **`packages/ghostty.txt`:**
   - `ghostty`
6. **`packages/kitty.txt`:**
   - `kitty`
7. **`packages/fish.txt`:**
   - `fish`, `fisher`, `starship`, `cachyos-fish-config`
8. **`packages/nvim.txt`:**
   - `neovim`, `ripgrep`, `fd`, `tree-sitter`
9. **`packages/base_cli.txt`:**
   - `bat`, `zoxide`, `tree`, `trash-cli`, `duf`, `jq`, `unzip`, `unrar`, `7zip`, `rsync`, `topgrade`, `multitail`, `btop`, `fastfetch`
10. **`packages/browser.txt`:**
    - `vivaldi`, `vivaldi-ffmpeg-codecs`
11. **`packages/social.txt`:**
    - `vesktop`, `telegram-desktop`, `signal-desktop`, `teams-for-linux`
12. **`packages/dev.txt`:**
    - `code`, `docker`, `docker-compose`, `docker-buildx`, `lazydocker`, `dbeaver`, `github-cli`, `nodejs`, `npm`
13. **`packages/productivity.txt`:**
    - `obsidian`, `proton-pass`, `proton-pass-cli-bin`, `calibre`, `keepassxc`
14. **`packages/media.txt`:**
    - `haruna`, `obs-studio`, `kdenlive`, `qbittorrent`, `freedownloadmanager`, `jdownloader2`, `gwenview`
15. **`packages/networking.txt`:**
    - `tailscale`, `cloudflare-warp-bin`, `cloudflare-speed-cli`, `syncthing`, `rclone`, `rustdesk-bin`, `termius`
16. **`packages/sunshine.txt`:**
    - `sunshine`
17. **`packages/hardware.txt` (Kullanıcı tarafından sınırlandırılan paketler):**
    - `tlp`, `tlp-pd`, `tlp-rdw`, `tlpui`, `ufw`

---

## 3. Bileşen Kaydı (Component Registry) & Varsayılan Değerler

Her bileşen sistemde şu özelliklerle tanımlanır:
- **Kimlik (ID)**
- **Kategori ve Açıklama**
- **Soru Metni & Varsayılan Değer (`Y` veya `N`)**
- **İlişkili Paket Dosyası (`packages/<id>.txt`)**
- **İlişkili Dotfile Paketleri (`stow` paketleri)**
- **İlişkili Sistem Betiği (`scripts/setup_*.sh`)**

### Varsayılan Soru Matrisi:

| Kategori | Bileşen | Varsayılan | İlişkili Paketler | İlişkili Stow Klasörü | İlişkili Betik |
|---|---|:---:|---|---|---|
| **Compositor** | Hyprland | `N` | `packages/hypr.txt` | `hypr` | - |
| | Niri | `N` | `packages/niri.txt` | `niri` | - |
| | MangoWM | `N` | `packages/mango.txt` | `mango` | - |
| **Terminal** | Ghostty | `Y` | `packages/ghostty.txt` | `ghostty` | - |
| | Kitty | `N` | `packages/kitty.txt` | `kitty` | - |
| **Shell & Editör** | Fish & Starship | `Y` | `packages/fish.txt` | `fish`, `starship` | - |
| | Neovim | `Y` | `packages/nvim.txt` | `nvim` | - |
| | Temel CLI Araçları | `Y` | `packages/base_cli.txt` | `btop`, `fastfetch`, `user-dirs` | - |
| **Uygulamalar** | Vivaldi Tarayıcı | `Y` | `packages/browser.txt` | `vivaldi` | `scripts/vivaldi_middle_click.sh` |
| | İletişim (Discord/Vesktop vb.) | `Y` | `packages/social.txt` | - | `scripts/setup_discord_proxy.sh` |
| | Geliştirici Araçları (VS Code, Docker) | `Y` | `packages/dev.txt` | - | `scripts/setup_npm.sh` |
| | Üretkenlik (Obsidian, Proton Pass) | `Y` | `packages/productivity.txt` | - | `scripts/setup_1password.sh` |
| | Medya (Haruna, OBS, Torrent) | `Y` | `packages/media.txt` | - | - |
| | Ağ & VPN (Tailscale, WARP vb.) | `Y` | `packages/networking.txt` | `ssh` | `scripts/setup_warp.sh`, `scripts/setup_sshd.sh` |
| | Sunshine GameStream | `N` | `packages/sunshine.txt` | `sunshine` | `scripts/setup_ufw.sh` |
| | Flatpak Paketleri | `N` | `flat_packages.txt` | - | `scripts/install_flatpaks.sh` |
| **Donanım & Sistem** | Güç & Güvenlik Duvarı (TLP, UFW) | `N` | `packages/hardware.txt` | - | `scripts/setup_ufw.sh` |
| | Keychron Klavye Modu | `N` | - | - | `scripts/setup_keychron.sh` |
| | Apple F-Tuşları Düzeltmesi | `N` | - | - | `scripts/setup_fkeys.sh` |
| | Wi-Fi iwd Optimizasyonu | `N` | - | - | `scripts/switch_to_iwd.sh` |
| | Sistem & Kullanıcı Servisleri | `Y` | - | `systemd` | `scripts/setup_services.sh` |
| | Nerd Fontlar | `Y` | - | - | `scripts/setup_fonts.sh` |

---

## 4. `stow_all.sh` Dinamik Paket Bağlama

`stow_all.sh` betiği hem argümansız hem de argümanlı çalışacak şekilde güncellenecektir:
- `stow_all.sh hypr fish ghostty` ➔ Sadece argüman olarak verilen paketleri bağlar.
- `stow_all.sh` ➔ Depodaki tüm dotfiles paketlerini bağlar (geriye dönük tam uyumluluk).

---

## 5. Kurulum Sihirbazı Akışı ve Yürütme Motoru

### 5.1 Adım 1: Soru Toplama (`ask_yn`)
Kullanıcıya her soru tek tek gösterilir. Enter tuşuna basıldığında büyük harfle gösterilen varsayılan (`Y` veya `N`) seçilir.

### 5.2 Adım 2: Onay Özeti (Summary Box)
Tüm seçimler listelenir:
- Kurulacak Paket Listeleri
- Bağlanacak Dotfiles Paketleri
- Yürütülecek Sistem / Donanım Betikleri
Kullanıcıdan "Kuruluma başlansın mı? [Y/n]" onayı istenir.

### 5.3 Adım 3: Sıralı Yürütme Fazları
1. **Faz 1 (Temel Bootstrap):** Dağıtım tespiti, `base-devel`, `yay`, `stow` kontrolü ve `packages/base.txt` kurulumu.
2. **Faz 2 (Toplu Paket Kurulumu):** Seçilen modüllerin paket dosyaları birleştirilir (`sort -u`) ve tek seferde `yay -Syu --needed` ile kurulur.
3. **Faz 3 (Dotfiles Bağlama):** Seçilen paketler `stow_all.sh` üzerinden bağlanır.
4. **Faz 4 (Ayar Betikleri):** Seçilen betikler sırayla güvenli şekilde (`run_script`) tetiklenir.

---

## 6. Komut Satırı Bayrakları ve CLI Desteği

`install.sh` betiği şu bayrakları ve modları destekleyecektir:

- `./install.sh` ➔ Varsayılan interaktif sihirbazı başlatır.
- `./install.sh --dry-run` / `-n` ➔ Seçimleri alır (veya argümanları kullanır), yapılacak tüm işlemleri, kurulacak paketleri ve bağlanacak dotfile'ları ekrana yazdırır; **hiçbir sistem değişikliği yapmaz**.
- `./install.sh --default` / `-d` ➔ Soru sormadan tüm varsayılan `[Y]` seçeneklerini kurar.
- `./install.sh --all` / `-a` ➔ Soru sormadan tüm bileşenleri kurar.
- `./install.sh <modul1> <modul2>` ➔ Belirtilen modülleri doğrudan kurar (örn: `./install.sh hypr fish ghostty`).
- `./install.sh --help` / `-h` ➔ Kullanım kılavuzunu ve modül listesini gösterir.

---

## 7. Doğrulama ve Test Planı

1. **Sözdizimi Kontrolleri:**
   - `bash -n install.sh`
   - `bash -n stow_all.sh`
2. **Dry-Run Testleri:**
   - `./install.sh --dry-run --default`: Varsayılan seçimlerin simülasyon çıktısı doğrulanır.
   - `./install.sh --dry-run hypr fish`: Yalnızca hypr ve fish modüllerinin simülasyon çıktısı doğrulanır.
3. **Paket Dosyaları Bütünlüğü:**
   - `packages/*.txt` dosyalarının her birinin geçerli ve boşluksuz olduğu teyit edilir.
4. **Stow Uyumluluk Testi:**
   - `stow_all.sh`'ın argümanla sadece seçilen paketleri bağladığı test edilir.
