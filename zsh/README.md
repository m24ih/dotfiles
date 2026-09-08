# 🐚 Zsh & Oh My Zsh (Gelişmiş Z Shell Yapılandırması)

Modern Vi-mode, zengin eklenti ekosistemi (Oh My Zsh), Starship prompt entegrasyonu, FZF arama araçları, geliştirici ortam değişkenleri ve modüler betik yükleyicisi barındıran Zsh kabuğu yapılandırması.

---

## 📦 Kurulum ve Eklentiler

Zsh ortamının tam verimle çalışması için gerekli sistem paketleri ve CLI araçları:

```bash
# Arch Linux / CachyOS (veya dotfiles sihirbazı: ./install.sh zsh):
yay -S --needed zsh fzf zsh-completions zsh-autosuggestions zsh-syntax-highlighting eza
```

### ⚡ Otomatik Oh My Zsh ve Eklenti Kurulumu
Dotfiles içerisindeki `scripts/setup_zsh.sh` betiği, Oh My Zsh ve aşağıdaki 5 popüler özel eklentiyi `~/.oh-my-zsh/custom/plugins/` altına otomatik olarak klonlar:
* `zsh-autosuggestions`
* `zsh-syntax-highlighting`
* `zsh-completions`
* `zsh-history-substring-search`
* `zsh-autopair`

```bash
./scripts/setup_zsh.sh
```

Varsayılan oturum kabuğu yapmak için:
```bash
chsh -s $(which zsh)
```
*(veya `./install.sh` sihirbazındaki kabuk seçiciyi kullanabilirsiniz)*

---

## 📁 Dosya Yapısı

```text
zsh/
├── .zshrc                           # Ana kabuk yapılandırması, alias'lar ve fonksiyonlar
└── .config/
    └── zshrc.d/                     # Modüler Zsh betikleri dizini
        └── shortcuts.zsh            # Kelime silme (Ctrl+H) ve geri alma (Ctrl+Z) kısayolları
```

---

## ⚙️ Yapılandırma ve Öne Çıkan Özellikler (`.zshrc`)

### 1. ⌨️ Vi Modu, Görsel Mod ve Dinamik İmleç
* **Vi Tuş Atamaları:** `bindkey -v` ile standart Vi düzeni aktiftir.
* **Görsel Seçim Modu (Visual Mode):** `v` tuşuyla görsel seçim başlatılabilir.
* **Akıllı İmleç Şekli (Cursor Shape):**
  * Ekleme Modu (Insert): İnce dikey çizgi (`beam`).
  * Normal Mod (Command): Dolu dikdörtgen blok (`block`).
* **Hızlı Geri Alma / Silme:** `Ctrl + H` ile imlecin solundaki kelime silinir, `Ctrl + Z` ile geri alınır.

### 2. 🚀 Entegrasyonlar ve Hızlı Başlatma
* **Starship Prompt:** `eval "$(starship init zsh)"` ile ultra hızlı, Git durumunu gösteren komut istemi.
* **Zoxide Akıllı Dizin Geçişi:** `eval "$(zoxide init zsh)"` ile `z <hedef>` hızlı navigasyon.
* **FZF Anahtar Atamaları:** `/usr/share/fzf/key-bindings.zsh` ve `completion.zsh` ile `Ctrl + R` geçmiş araması ve `Ctrl + T` dosya bulucu.
* **Fastfetch Karşılama:** Dağıtım logosunu otomatik güncelleyerek terminal açılışında sistem bilgilerini görüntüler.

### 3. 🛠️ Geliştirici Ortam Değişkenleri & Güvenlik
* **SDK & Araçlar:** `ANDROID_HOME=/opt/android-sdk`, `FLUTTER_HOME=/opt/flutter`, `JAVA_HOME=/usr/lib/jvm/java-25-openjdk`.
* **Proton Pass SSH Agent:** `SSH_AUTH_SOCK=~/.ssh/proton-pass-ssh-agent.sock` ve Wayland DBus aktivasyonu.
* **Editör & Sayfalayıcı:** `EDITOR=nvim`, `VISUAL=nvim`, `MANPAGER` (`bat` ile renklendirilmiş yardım sayfaları).

### 4. ⚡ Zengin Alias (Kısayol) Kütüphanesi
* **Modern Dosya Listeleme (`eza`):** `ls`, `l`, `ll`, `la`, `tree` ikon ve git durumu destekli.
* **Navigasyon:** `..`, `...`, `....` hızlı üst dizinler.
* **Paket Yöneticisi:** `pacman`, `yay`, `cleanup`, `orphan` kısayolları.
* **Git & Docker:** `g`, `ga`, `gc`, `gp`, `gl`, `gst`, `dps`, `dstop` vb.

### 5. 🧩 Modüler Genişleme (`~/.config/zshrc.d`)
`.zshrc` dosyasının sonunda yer alan otomatik yükleyici sayesinde `~/.config/zshrc.d/*.zsh` kalıbındaki her yeni betik otomatik olarak kaynak (`source`) olarak yüklenir; ana `.zshrc` dosyasını şişirmeden modüler özellikler eklenebilir.
