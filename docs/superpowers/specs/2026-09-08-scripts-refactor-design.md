# Tasarım Şartnamesi: Dotfiles Betiklerinin Modülerleştirilmesi ve Düzenlenmesi (Scripts Refactor)

**Tarih:** 2026-09-08  
**Durum:** Onaylandı  
**Kapsam:** Architectural  

---

## 1. Genel Bakış ve Amaç

Bu çalışmanın amacı, dotfiles deposunun kök dizininde bulunan 13'ten fazla kurulum ve sistem yapılandırma betiğini tek bir düz `scripts/` dizini altında toplamak, GNU Stow paket yapısını temiz tutmak, daha önce silinmiş/çöp haline gelmiş eski betikleri depodan kalıcı olarak temizlemek ve CachyOS/Arch, Fedora ve Ubuntu/Debian için çoklu dağıtım (multi-distro) desteğini koruyarak betikleri daha sürdürülebilir hale getirmektir.

---

## 2. Dizin Yapısı & Dosya Değişiklikleri

### 2.1 Kök Dizinde Kalacak Dosyalar
- `install.sh`: Ana orkestrasyon ve modüler kurulum giriş noktası.
- `stow_all.sh`: Dotfiles paketlerini GNU Stow ile `$HOME` dizinine bağlayan betik.
- `packages.txt`: Pacman / AUR paket listesi.
- `flat_packages.txt`: Flathub Flatpak paket listesi.
- `.stow-local-ignore`: Stow tarafından yok sayılacak kalıplar (`scripts/` kalıbı da eklenecek).
- `.gitignore`: Git tarafından izlenmeyecek dosyalar.
- `README.md`: Ana depo dokümantasyonu.
- Yapılandırma klasörleri (`btop/`, `fish/`, `ghostty/`, `hypr/`, `kitty/`, `mango/`, `niri/`, `nvim/`, `ssh/`, `starship/`, `sunshine/`, `systemd/`, `user-dirs/`, `vivaldi/`, `zshrc.d/`, `antigravity/`).

### 2.2 `scripts/` Dizinine Taşınacak Betikler
Tüm yardımcı betikler düz (flat) bir yapıda `scripts/` altına taşınacak ve çalıştırılabilir (`chmod +x`) olacaktır:
- `install_flatpaks.sh` -> `scripts/install_flatpaks.sh`
- `setup_1password.sh` -> `scripts/setup_1password.sh`
- `setup_discord_proxy.sh` -> `scripts/setup_discord_proxy.sh`
- `setup_fkeys.sh` -> `scripts/setup_fkeys.sh`
- `setup_fonts.sh` -> `scripts/setup_fonts.sh`
- `setup_keychron.sh` -> `scripts/setup_keychron.sh`
- `setup_npm.sh` -> `scripts/setup_npm.sh`
- `setup_services.sh` -> `scripts/setup_services.sh`
- `setup_sshd.sh` -> `scripts/setup_sshd.sh`
- `setup_ufw.sh` -> `scripts/setup_ufw.sh`
- `setup_warp.sh` -> `scripts/setup_warp.sh`
- `switch_to_iwd.sh` -> `scripts/switch_to_iwd.sh`
- `vivaldi_middle_click.sh` -> `scripts/vivaldi_middle_click.sh`

### 2.3 Kalıcı Olarak Silinecek Obsolete Dosyalar
- `migrate_dotfiles.sh`
- `newpackages.txt`
- `setup_internet_monitor.sh`
- `switch_to_wpa_supplicant.sh`

---

## 3. Betik Güncellemeleri & Çoklu Dağıtım Mantığı

### 3.1 Bağımsızlık & Yol Çözümleme (Self-Contained Scripts)
- Her betik ek bir kütüphaneye bağımlı kalmadan hem `install.sh` üzerinden hem de doğrudan `./scripts/<betik>.sh` şeklinde çalışabilmelidir.
- `scripts/install_flatpaks.sh`: Repo kök dizinindeki `flat_packages.txt` dosyasını bulmak için dinamik yol çözümlemesi kullanacaktır:
  ```bash
  DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." &>/dev/null && pwd)"
  ```

### 3.2 Çoklu Dağıtım Desteğinin Geri Kazandırılması
1. **`install.sh`**:
   - `/etc/os-release` dosyasından `DETECTED_OS` değişkeni okunacaktır.
   - `install_base_packages()`:
     - Arch/CachyOS/Manjaro: `sudo pacman -Syu --needed git base-devel --noconfirm`
     - Fedora/RHEL: `sudo dnf install -y git @development-tools`
     - Ubuntu/Debian: `sudo apt update && sudo apt install -y git build-essential`
   - `install_package_manager()`:
     - Arch tabanlı: `yay` kontrolü ve AUR üzerinden otomatik kurulumu.
     - Fedora/Debian: İlgili paket yöneticilerinin mevcut olduğunu bildirme.
2. **`scripts/setup_services.sh`**:
   - Dağıtım tespit edilerek `SYSTEM_SERVICES` dizisi dağıtıma göre belirlenecektir:
     - **Arch/CachyOS**: `bluetooth`, `ufw`, `avahi-daemon`, `ananicy-cpp`, `bpftune`, `warp-svc`, `docker`, `tailscaled`, `fstrim.timer`, `cachyos-rate-mirrors.timer`, `snapper-cleanup.timer`, `grub-btrfs-snapper.path`, `cachyos-iw-set-regdomain.path`.
     - **Fedora**: `bluetooth`, `firewalld`, `avahi-daemon`, `tuned`, `bpftune`, `warp-svc`, `docker`, `tailscaled`, `fstrim.timer`, `dnf-makecache.timer`, `snapper-cleanup.timer`, `grubby`.
     - **Debian/Ubuntu**: `bluetooth`, `ufw`, `avahi-daemon`, `warp-svc`, `docker`, `tailscaled`, `fstrim.timer`, `apt-daily.timer`, `apt-daily-upgrade.timer`.
   - Kullanıcı servisleri (`psd.service`, `arch-update.timer`, `warp-taskbar.service`, `syncthing.service`) ortak olarak denetlenecektir.
3. **`scripts/setup_fonts.sh`**:
   - Arch tabanlı sistemlerde: `sudo pacman -S --needed --noconfirm ttf-jetbrains-mono-nerd`
   - Diğer dağıtımlarda: GitHub release üzerinden JetBrainsMono zip arşivi indirilip `~/.local/share/fonts/` içerisine çıkarılacak ve `fc-cache -f` çalıştırılacaktır.

---

## 4. `install.sh` Entegrasyonu ve Yeni Modüller

### 4.1 Betik Çağrıları
- `install.sh` içindeki tüm `run_script` çağrıları `$DOTFILES_DIR/scripts/...` konumuna yönlendirilecektir.
- `link_dotfiles` fonksiyonu `$DOTFILES_DIR/stow_all.sh` betiğini kök dizinden çağıracaktır.

### 4.2 `1password` İsteğe Bağlı Modülü
- Varsayılan argümansız tam kurulum akışında (`if [ $# -eq 0 ]`) `setup_1password.sh` çalıştırılmayacaktır.
- CLI argümanlarında `1password` veya `onepassword` verildiğinde `scripts/setup_1password.sh` sudo ile tetiklenecektir:
  ```bash
  1password|onepassword) run_script "$DOTFILES_DIR/scripts/setup_1password.sh" sudo ;;
  ```

---

## 5. Dokümantasyon Güncellemeleri

- **`README.md`**:
  - `## 🧩 Modüler Kurulum Seçenekleri`: `1password` seçeneği tabloya eklenecektir.
  - `## 🛠️ Donanım & Sistem Betikleri`: Betik yolları `scripts/` olarak güncellenecektir.
- **`ssh/README.md`**:
  - `setup_sshd.sh` referansı `scripts/setup_sshd.sh` olarak düzeltilecektir.
- **`vivaldi/README.md`**:
  - `vivaldi_middle_click.sh` referansı `scripts/vivaldi_middle_click.sh` olarak düzeltilecektir.
- **`.stow-local-ignore`**:
  - `scripts` ve `scripts/` kalıbı eklenerek yanlışlıkla stow edilmesinin önüne geçilecektir.

---

## 6. Doğrulama ve Test Planı

1. **Sözdizimi Kontrolü (Syntax Check):**
   - `bash -n install.sh`
   - `bash -n stow_all.sh`
   - `bash -n scripts/*.sh`
2. **Yol ve Bağımlılık Doğrulaması:**
   - `scripts/install_flatpaks.sh` içindeki dosya yolu çözümlemesinin `$DOTFILES_DIR/flat_packages.txt` dosyasını bulduğu teyit edilecektir.
3. **Referans Bütünlüğü:**
   - Depo genelinde `grep` araması ile kök dizindeki eski `./setup_*.sh` referanslarının tamamen temizlendiği doğrulanacaktır.
4. **Git Durumu:**
   - Silinen 4 dosyanın depodan çıkarıldığı, yeni dosyaların `scripts/` altında izlendiği ve çalışma ağacının temiz olduğu teyit edilecektir.
