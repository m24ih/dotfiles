# 🛠️ Yardımcı ve Sistem Betikleri (`scripts/`)

Bu dizin, donanım optimizasyonları, ağ yapılandırmaları, güvenlik ayarları ve harici ekosistem kurulumlarını otomatikleştiren bağımsız kabuk betiklerini (`*.sh`) barındırır.

---

## 📋 Betik Kataloğu (15 Adet)

| Betik | Yetki | Açıklama |
| :--- | :---: | :--- |
| [`setup_zsh.sh`](setup_zsh.sh) | Kullanıcı | Oh My Zsh ortamını sessiz (`--unattended`) kurar ve 5 özel eklentiyi (`autosuggestions`, `syntax-highlighting` vb.) indirir. |
| [`setup_fonts.sh`](setup_fonts.sh) | Kullanıcı | JetBrains Mono Nerd Font ve sistem yazı tiplerini indirip `~/.local/share/fonts/` altına kurar, font önbelleğini yeniler. |
| [`setup_npm.sh`](setup_npm.sh) | Kullanıcı | NPM global paket dizinini `~/.npm-global` konumuna yönlendirir; küresel paket kurulumlarında `sudo` ihtiyacını ortadan kaldırır. |
| [`setup_services.sh`](setup_services.sh) | Kullanıcı / Sudo | Dağıtıma göre sistem ve kullanıcı seviyesi systemd servislerini (`tailscaled`, `syncthing`, `bluetooth`, vb.) otomatik etkinleştirir. |
| [`setup_power_management.sh`](setup_power_management.sh) | Kullanıcı | KDE Plasma PowerDevil güç yönetimine priz ve batarya geçişlerinde otomatik çalışacak güç tasarruf betiklerini (Sunshine ve Baloo) kaydeder. |
| [`setup_ufw.sh`](setup_ufw.sh) | `sudo` | UFW güvenlik duvarını devreye alır; Sunshine, SSH, KDE Connect ve yerel ağ izinlerini yapılandırır. |
| [`setup_sshd.sh`](setup_sshd.sh) | `sudo` | SSH sunucusuna (`sshd`) yerel ağ dışından parola ile girişi engelleyen güvenlik kurallarını kurar. |
| [`setup_1password.sh`](setup_1password.sh) | `sudo` | 1Password için özel tarayıcı izinlerini (`/etc/1password/custom_allowed_browsers`) yapılandırır. |
| [`setup_keychron.sh`](setup_keychron.sh) | `sudo` | Keychron kablosuz/kablolu mekanik klavye modunu ve Bluetooth bağlantı parametrelerini optimize eder. |
| [`setup_fkeys.sh`](setup_fkeys.sh) | `sudo` | Apple / Mac düzenli klavyelerde Fn tuşlarının varsayılan olarak F1-F12 gibi davranmasını sağlar. |
| [`switch_to_iwd.sh`](switch_to_iwd.sh) | `sudo` | NetworkManager için wpa_supplicant yerine daha düşük gecikmeli ve kararlı `iwd` Wi-Fi motoruna geçiş sağlar. |
| [`setup_warp.sh`](setup_warp.sh) | Kullanıcı | Cloudflare WARP istemcisi için split-tunneling ve yerel ağ rotalama ayarlarını yapar. |
| [`setup_discord_proxy.sh`](setup_discord_proxy.sh) | Kullanıcı | Discord için güvenli proxy ve bağlantı tünelini yapılandırır. |
| [`vivaldi_middle_click.sh`](vivaldi_middle_click.sh) | Kullanıcı | Wayland oturumunda Vivaldi tarayıcısında fare orta tuşu ile kaydırma (auto-scroll) desteğini etkinleştirir. |
| [`install_flatpaks.sh`](install_flatpaks.sh) | Kullanıcı | Kök dizindeki `flat_packages.txt` dosyasında listelenen tüm Flatpak uygulamalarını Flathub üzerinden kurar. |

---

## ⚙️ Kurulum Sihirbazı Entegrasyonu

Bu betiklerin tamamı ana [`install.sh`](../install.sh) sihirbazı içerisindeki bileşen kaydına (registry) bağlıdır.
- Kullanıcı sihirbaz üzerinden ilgili modülü seçtiğinde veya komut satırından parametre verdiğinde (örn: `./install.sh hardware` veya `./install.sh zsh`), ilgili betik `run_script` yardımcısı üzerinden yetki durumuna (`sudo` / kullanıcı) dikkat edilerek güvenle çalıştırılır.
- Dilerseniz herhangi bir betiği bu dizinden bağımsız olarak tek başına da çalıştırabilirsiniz:
  ```bash
  ./scripts/setup_ufw.sh
  ./scripts/setup_zsh.sh
  ```
