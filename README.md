# Melih's Dotfiles (Gelecekteki Kendime Notlar)

Bu repo, benim kişisel CachyOS end-4 Hyprland yapılandırma dosyalarımı (dotfiles) barındırır.

Tüm sistem `stow` kullanılarak modüler paketler halinde yönetilmektedir ve `install.sh` ana betiği (script) aracılığıyla yeni bir sistem kurulumunu otomatikleştirmek için tasarlanmıştır.

## 🚀 Yeni Bir Sisteme Hızlı Kurulum

Format sonrası yeni bir sisteme geçtiğimde izlemem gereken adımlar:

1.  **Temel Paketleri Kur:**
    Sisteme gerekli paket yöneticisini ve geliştirme araçlarını kur.
    ```bash
    # Arch-based (CachyOS, Arch, Manjaro, vb.):
    sudo pacman -Syu --needed git base-devel

    # Fedora-based:
    sudo dnf install -y git @development-tools

    # Debian/Ubuntu-based:
    sudo apt update
    sudo apt install -y git build-essential
    ```

2.  **Repoyu Klonla:**
    Bu `Dotfiles` reposunu, `stow` ve betiklerin beklediği `~/Documents` dizinine klonla.
    ```bash
    git clone https://github.com/m24ih/dotfiles.git ~/Documents/Dotfiles
    ```

3.  **Betiği Çalıştır:**
    Ana kurulum betiğini çalıştır. Bu betik otomatik olarak dağıtımınızı tespit eder ve uygun paket yöneticisini kullanır.
    ```bash
    cd ~/Documents/Dotfiles
    chmod +x install.sh
    ./install.sh
    ```
    Bu komut dağıtımınıza göre gerekli paket yöneticisini kurar ve tüm bileşenleri yükler.

    ### Seçmeli Kurulum (Yeni Özellik)
    `install.sh` artık modüler hâle getirilmiştir ve sadece belirli bölümleri çalıştırmak için komut satırı argümanları kabul eder:
    ```bash
# Sadece temel paketleri ve paket yöneticisini kur
./install.sh base package-manager

# Sadece dotfile bağlantılarını oluştur
./install.sh stow

# Sadece donanım ayarlarını uygula
./install.sh hardware

# Sadece yazı tiplerini kur
./install.sh fonts

# Tüm bölümleri (varsayılan davranış) çalıştırmak için argüman vermeyin
./install.sh
    ./install.sh
    ```

    Kullanılabilir bölümler:
    - `base` veya `packages`: git ve base-devel (veya dağıtım eşdeğeri)
    - `package-manager` veya `pm`: Dağıtım özel paket yöneticisini yay (Arch) veya zaten bulunan dnf/apt (Diğerleri)
    - `all`: packages.txt içindeki tüm paketleri kur (yay ile, Arch-based sistemlerde)
    - `flatpak`: Flatpak paketlerini kur
    - `stow` veya `dotfiles`: stow ile dotfile'ları bağla
    - `hardware`: F tuşları ve Keychron donanım ayarlarını uygula
    - `network`: Ağ ve ağ sürücü ayarlarını uygula (iwd, vivaldi middle click)
    - `discord`: Discord proxy ayarlarını uygula
    - `services`: Sistem ve kullanıcı servislerini yapılandır
    - `ufw`: UFW güvenlik duvarı kurallarını uygula
    - `warp`: Cloudflare WARP split tunnel kurallarını uygula
    - `fonts`: JetBrains Mono Nerd Font ve diğer yazı tiplerini kur
4.  **Manuel Olarak Yapılacaklar (ÖNEMLİ):**
    Kurulum betiği bittikten sonra, **asla** bu repoya eklenmemesi gereken "sır" (secret) dosyalarını manuel olarak yerine koy:
    * `~/.config/rclone/rclone.conf` (GDrive token'ları için)
    * `~/.config/gh/hosts.yml` (GitHub CLI token'ı için)
    * Gerekse `ssh` anahtarları (`~/.ssh/`).
    * (Bunları 1Password'den al.)

5.  **Yeniden Başlat:**
    Tüm ayarların (özellikle `fkeys` gibi donanım modüllerinin) tam olarak uygulanması için sistemi yeniden başlat.

---

## 🏗️ Sistem Nasıl Çalışır: `stow`

Bu repo, sembolik bağ (symlink) yöneticisi olan `stow`'u temel alır.

* `~/Documents/Dotfiles/` ana dizinimizdir.
* İçindeki her bir klasör (`hypr`, `nvim`, `fish`, `gtk` vb.) bir "stow paketi" olarak kabul edilir.
* Her paketin *içindeki* dosya yapısı, `~` (home) dizininin yapısını *taklit eder*.

**Örnek:** `fastfetch` ayarlarını `~/.config/fastfetch` konumuna bağlamak için, dosyaların konumu:
`~/Documents/Dotfiles/fastfetch/.config/fastfetch/` şeklindedir.

`install.sh` betiği, `STOW_PACKAGES` dizisinde listelenen tüm paketler için otomatik olarak `stow -R -t ~ [paket_adi]` komutunu çalıştırır ve tüm ayarları ana dizine bağlar.

## 📦 Yeni Bir Yapılandırma Ekleme (Yeni Bir 'stow' Paketi)

Gelecekte `rofi` gibi yeni bir programın yapılandırmasını eklemek istediğimde:

1.  **Paket Klasörünü Oluştur:**
    ```bash
    mkdir -p ~/Documents/Dotfiles/rofi
    ```

2.  **`~` Taklit Yapısını Oluştur:**
    `rofi` ayarları `~/.config/rofi` içinde duruyorsa, `stow` için şu yolu oluştur:
    ```bash
    mkdir -p ~/Documents/Dotfiles/rofi/.config
    ```

3.  **Mevcut Ayarları Taşı:**
    Gerçek yapılandırma klasörünü (`~/.config/rofi`) bu yeni `stow` paketinin içine taşı:
    ```bash
    mv ~/.config/rofi ~/Documents/Dotfiles/rofi/.config/
    ```

4.  **Ana Betiği Güncelle:**
    `install.sh` dosyasını aç ve `STOW_PACKAGES` dizisine `"rofi"` kelimesini ekle.

5.  **Yeni Paketi "Stow" Et:**
    (İsteğe bağlı) Betiği tekrar çalıştırmak yerine hemen bağlamak için:
    ```bash
    cd ~/Documents/Dotfiles
    stow -R -t ~ rofi
    ```

6.  **Git'e Gönder:**
    Yeni paketi repoya ekle.
    ```bash
    git add .
    git commit -m "feat: Yeni 'rofi' paketini ekle"
    git push
    ```

## ⚠️ Potansiyel Sorunlar ve Uyarılar

### 1. Embedded Git Repository (İç İçe Git Reposu)
Eğer `fish` veya `nvim` için bir temayı/eklentiyi `git clone` ile doğrudan `.../fish/.config/fish/` klasörünün *içine* klonlarsam, bu `Dotfiles` reposu `git add .` yaparken "warning: adding embedded git repository" uyarısı verir.

**Çözüm:** İçerideki eklenti/tema klasörünün `.git` dizinini silerek onu "düz" dosyalara dönüştür.
```bash
# 1. Hatalı eklemeyi Git'in hafıyasından zorla kaldır
git rm --cached -f [hatali_paket_yolu]

# 2. İçerideki .git klasörünü sil
rm -rf [hatali_paket_yolu]/.git

# 3. Artık "düz" olan klasörü tekrar ekle
git add [hatali_paket_yolu]
```

### 2. Seçmeli Kurulum Kullanımı
Yeni modüler `install.sh` ile sadece ihtiyacınız olan bölümleri çalıştırabilirsiniz. Bu, mevcut bir sistemde sadece donanım ayarlarını güncellemek veya sadece yeni bir stow paketi eklemek gibi senaryolar için kullanışlıdır.

Örnek kullanım senaryoları:
- Sadece dotfile bağlantısını yenilemek: `./install.sh stow`
- Yeni bir sistemde sadece temel paketleri ve yay'ı kurmak: `./install.sh base yay`
- Sadece ağ ayarlarını uygulamak (örneğin, iwd'ye geçmek): `./install.sh network`