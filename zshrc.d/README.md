# 🐚 zshrc.d (Modüler Zsh Yapılandırma Betikleri)

Zsh kabuğu başlatıldığında modüler olarak yüklenen tuş kısayolları, terminal renk şemaları ve TTY1 otomatik Hyprland başlatma kuralı.

---

## 📦 Kurulum ve Eklentiler

Eğer sisteminizde Zsh veya popüler eklentiler eksikse:

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
        ├── shortcuts.zsh        # Kelime silme (Ctrl+H) ve geri alma (Ctrl+Z) kısayolları
        ├── dots-hyprland.zsh    # Terminal dinamik renk dizilimleri yükleyicisi
        └── auto-Hypr.sh         # TTY1 girişinde otomatik Hyprland başlatıcı
```

---

## ⚙️ Yapılandırma Detayları

### 1. 🚀 TTY1 Otomatik Hyprland Başlatma (`auto-Hypr.sh`)
* Sanal konsolda (`TTY1` / `$XDG_VTNR -eq 1`) kullanıcı girişi yapıldığında grafik arayüz (`start-hyprland`) otomatik olarak başlatılır ve loglar `~/.cache/hyprland.log` dosyasına yazılır. Display Manager (SDDM/GDM) olmadan doğrudan hafif Wayland oturumuna geçiş sağlar.

### 2. ⌨️ Düzenleme Kısayolları (`shortcuts.zsh`)
* `Ctrl + H`: İmlecin solundaki kelimeyi siler (`backward-kill-word`).
* `Ctrl + Z`: Yazılan metni bir önceki adıma geri alır (`undo`).

---

## 🛠️ `~/.zshrc` Entegrasyonu

Bu modülleri aktif etmek için `~/.zshrc` dosyanızın sonuna şu satırların eklenmesi yeterlidir:

```zsh
for file in ~/.config/zshrc.d/*.{zsh,sh}; do
    [ -f "$file" ] && source "$file"
done
```
