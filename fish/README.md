# 🐟 Fish Shell (Gelişmiş Etkileşimli Kabuk Yapılandırması)

Zengin kısayollar, geliştirici ortam değişkenleri (Android/Flutter/Java/Conda), akıllı paket arama ve Proton Pass SSH entegrasyonu barındıran Fish kabuğu yapılandırması.

---

## 📦 Kurulum ve Yardımcı CLI Araçları

Fish ve yapılandırmadaki fonksiyonların tam verimle çalışması için önerilen paketler:

```bash
# Ana Kabuk (Arch / CachyOS):
sudo pacman -S --needed fish starship zoxide fzf eza bat ripgrep trash-cli jq
# veya AUR:
yay -S --needed fish starship zoxide fzf eza bat ripgrep trash-cli jq
```

Varsayılan kabuk yapmak için:
```bash
chsh -s $(which fish)
```

---

## 📁 Dosya Yapısı

```text
fish/
└── .config/
    └── fish/
        ├── config.fish       # Ana kabuk yapılandırması, alias'lar ve fonksiyonlar
        ├── conf.d/           # Eklenti ve modüler scriptler
        ├── completions/      # CLI araçları için özel tamamlama tanımları
        └── fish_variables    # Kalıcı kabuk değişkenleri ve renk paleti
```

---

## ⚙️ Yapılandırma ve Özel Yetenekler (`config.fish`)

### 1. 🛠️ Geliştirici Ortam Değişkenleri (SDK & Tools)
* **Android & Flutter:** `ANDROID_HOME=/opt/android-sdk`, `FLUTTER_HOME=/opt/flutter`, `PUB_CACHE=~/.pub-cache`.
* **Java:** `JAVA_HOME=/usr/lib/jvm/java-25-openjdk`.
* **Editor:** `EDITOR=nvim`, `VISUAL=nvim`, `MANPAGER` (Bat ile syntax renklendirmeli man sayfaları).
* **Proton Pass SSH Agent:** `SSH_AUTH_SOCK=~/.ssh/proton-pass-ssh-agent.sock` ve `dbus-update-activation-environment` ile Wayland oturumuna otomatik yetki aktarımı.

### 2. ⚡ Tembel Yükleme (Lazy Load Conda)
* `conda` komutu başlangıçta yüklenmez; kabuk anında açılır. İlk kez `conda` yazdığınızda arka plandaki `__conda_setup` tetiklenerek Anaconda ortamı devreye girer.

### 3. 🔍 FZF Destekli Paket Yöneticisi Kısayolları
* **`yayf` / `paruf`:** FZF ile interaktif paket arama ve önizlemeli (`yay -Sii`) kurulum.
* **`yayr` / `parur`:** FZF ile kurulu paketleri arayıp önizlemeli (`yay -Qi`) kaldırma.

### 4. 📂 Modern Dosya ve Dizin Yönetimi (`eza`)
* `ls`, `l`, `ll`, `la`: Git durumu ve ikon destekli modern listeleme.
* `T` / `Ta`: 3 seviyeli ağaç (Tree) görünümü.
* `..`, `...`, `....`: Hızlı üst dizinlere geçiş.
* Otomatik `ls`: `cd` ile dizin değiştirildiğinde otomatik `ls` çalıştırma.

### 5. ☁️ Rclone İzleme Araçları
* `rclone-status`, `rclone-vfs`, `watch-rclone-all`: Rclone VFS kuyruğunu ve senkronizasyon istatistiklerini `jq` ile anlık izleme.

### 6. ⌨️ Özel Tuş Atamaları
* `!` ve `$`: Bash tarzı "bang-bang" (`sudo !!`) geçmiş genişletmesi.
* `Ctrl + F`: `zoxide` etkileşimli dizin arama arayüzünü (`zi`) açar.
