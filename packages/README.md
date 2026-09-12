# 📦 Modüler Paket Listeleri (`packages/`)

Bu dizin, sistem kurulumunu kategorik, temiz ve sürdürülebilir kılmak amacıyla oluşturulmuş modüler paket listelerini barındırır.

---

## 🎯 Tasarım Felsefesi ve Mimari

Eski 1660 satırlık devasa ve monolitik `packages.txt` dosyasında bulunan alt kütüphaneler (`lib32-*`, ses codec'leri, Python derleme bağımlılıkları vb.) tamamen ayıklanmıştır. Dağıtımın paket yöneticisi (`pacman` / `yay`) birincil uygulamalar kurulurken gereken tüm bağımlılıkları otomatik ve güncel olarak zaten çözmektedir.

Bu sayede:
1. **Temiz ve Bağımsız Modüller:** Her dosya yalnızca ilgili çalışma ortamının doğrudan ihtiyaç duyduğu birincil uygulamaları içerir.
2. **Toplu ve Optimize Kurulum:** `install.sh` sihirbazında seçilen modüllerin dosyaları tek bir havuzda toplanır, `sort -u` ile tekilleştirilir ve tek seferde (`yay -Syu --needed`) kurulur.
3. **Seçici ve Esnek:** Kullanıcı örneğin sadece Hyprland ve Fish kurmak istediğinde yalnızca `packages/base.txt`, `packages/hypr.txt` ve `packages/fish.txt` devreye girer; sisteme gereksiz yüzlerce paket yüklenmez.

---

## 📁 Paket Dosyaları ve İçerikleri (18 Adet)

| Dosya | Kategori / Açıklama | Başlıca Paketler |
| :--- | :--- | :--- |
| [`base.txt`](base.txt) | **Zorunlu Temel Sistem:** Derleme araçları, dosya yönetim ve temel komutlar | `git`, `base-devel`, `stow`, `which`, `curl`, `wget`, `bash-completion`, `sudo`, `xdg-user-dirs` |
| [`niri.txt`](niri.txt) | **Niri Compositor:** Scrollable-tiling Wayland ortamı | `niri`, `xwayland-satellite`, `fuzzel`, `swaybg` |
| [`mango.txt`](mango.txt) | **MangoWM:** Hafif ve akıcı Wayland pencere yöneticisi | `mangowm` |
| [`ghostty.txt`](ghostty.txt) | **Ghostty Terminal:** Modern GPU hızlandırmalı terminal | `ghostty` |
| [`kitty.txt`](kitty.txt) | **Kitty Terminal:** Özelleştirilebilir terminal emülatörü | `kitty` |
| [`fish.txt`](fish.txt) | **Fish Shell:** Akıllı interaktif kabuk ve komut istemi | `fish`, `starship`, `fisher` |
| [`zsh.txt`](zsh.txt) | **Zsh Shell:** Zsh kabuğu, fzf ve popüler eklentiler | `zsh`, `fzf`, `zsh-completions`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `eza` |
| [`nvim.txt`](nvim.txt) | **Neovim IDE:** Modern metin editörü ve arama/derleme araçları | `neovim`, `tree-sitter`, `ripgrep`, `fd` |
| [`base_cli.txt`](base_cli.txt) | **Temel CLI Araçları:** Sistem izleme, hızlı navigasyon ve arşiv araçları | `btop`, `fastfetch`, `zoxide`, `bat`, `duf`, `tree`, `jq`, `unzip`, `7zip`, `unrar`, `trash-cli`, `multitail`, `topgrade`, `eza`, `fzf`, `ripgrep`, `fd` |
| [`browser.txt`](browser.txt) | **Web Tarayıcı:** Birincil internet tarayıcısı ve multimedya eklentileri | `vivaldi`, `vivaldi-ffmpeg-codecs` |
| [`social.txt`](social.txt) | **İletişim & Sosyal:** Mesajlaşma ve ekip iletişim araçları | `vesktop`, `telegram-desktop`, `signal-desktop`, `teams-for-linux` |
| [`dev.txt`](dev.txt) | **Geliştirici Araçları:** Kod editörleri, konteynerleştirme ve veritabanı | `code`, `docker`, `docker-compose`, `docker-buildx`, `lazydocker`, `dbeaver`, `nodejs`, `npm`, `github-cli` |
| [`productivity.txt`](productivity.txt) | **Üretkenlik & Not:** Not alma, şifre yöneticisi ve bulut erişimi | `obsidian`, `proton-pass`, `keepassxc`, `termius` |
| [`media.txt`](media.txt) | **Medya & İndirme:** Video/ses oynatıcılar, ekran kaydı ve indirme yöneticileri | `haruna`, `obs-studio`, `kdenlive`, `gwenview`, `calibre`, `qbittorrent`, `freedownloadmanager` |
| [`networking.txt`](networking.txt) | **Ağ & VPN:** Mesh VPN, senkronizasyon ve uzaktan erişim | `tailscale`, `cloudflare-warp-bin`, `syncthing`, `rclone`, `rustdesk-bin`, `rsync`, `cloudflare-speed-cli` |
| [`sunshine.txt`](sunshine.txt) | **Sunshine Sunucusu:** Düşük gecikmeli oyun ve masaüstü yayın akışı | `sunshine` |
| [`flatpak.txt`](flatpak.txt) | **Flatpak Paketleri:** Sandbox masaüstü uygulamaları | `com.github.tchx84.Flatseal` |
| [`hardware.txt`](hardware.txt) | **Donanım & Güvenlik:** Güç tasarrufu ve güvenlik duvarı | `tlp`, `tlp-pd`, `tlp-rdw`, `tlpui`, `ufw` |

---

## 🛠️ Yeni Paket Ekleme veya Düzenleme Kuralları

1. Her satıra yalnızca bir paket adı yazılır.
2. Satır başındaki `#` işaretleri yorum olarak algılanır ve kurulum motoru tarafından yoksayılır.
3. Boş satırlar kurulum motoru tarafından otomatik olarak elenir.
4. Paket eklerken alt kütüphaneler yerine yalnızca ana binary paketleri tercih edilmelidir.
