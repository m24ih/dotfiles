# 🐚 zshrc.d (Modüler Zsh Yapılandırma Betikleri)

Zsh kabuğu başlatıldığında modüler olarak yüklenen ortam değişkenleri, kısayollar ve Hyprland entegrasyon betikleri.

---

## 📦 Kurulum

Eğer sisteminizde Zsh kurulu değilse şu komutla kurabilirsiniz:

```bash
# Arch / CachyOS:
sudo pacman -S --needed zsh zsh-autosuggestions zsh-syntax-highlighting
# veya AUR:
yay -S --needed zsh zsh-autosuggestions zsh-syntax-highlighting
```

---

## 📁 Dosya Yapısı

```text
zshrc.d/
└── .config/
    └── zshrc.d/
        ├── shortcuts.zsh        # Özel alias'lar ve hızlı komut kısayolları
        ├── dots-hyprland.zsh    # Hyprland ortamına özel ortam değişkenleri
        └── auto-Hypr.sh         # TTY1 girişinde otomatik Hyprland başlatma kuralı
```

---

## ⚙️ Nasıl Yüklenir?

`~/.zshrc` dosyanızda bu dizindeki tüm `.zsh` ve `.sh` dosyaları şu döngü ile otomatik olarak taranıp yüklenir:

```zsh
for file in ~/.config/zshrc.d/*.{zsh,sh}; do
    [ -f "$file" ] && source "$file"
done
```
