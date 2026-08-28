# 📁 XDG User Dirs (Kullanıcı Standart Dizin Yapılandırması)

Standart kullanıcı dizinlerinin (`~/Downloads`, `~/Documents`, `~/Pictures`, `~/Projects` vb.) konumlarını yöneten XDG yapılandırması.

---

## 📦 Kurulum

Eğer sisteminizde kurulu değilse şu komutla kurabilirsiniz:

```bash
# Arch / CachyOS:
sudo pacman -S --needed xdg-user-dirs
# veya AUR:
yay -S --needed xdg-user-dirs
```

Dizinleri oluşturmak veya güncellemek için:
```bash
xdg-user-dirs-update
```

---

## 📁 Dosya Yapısı

```text
user-dirs/
└── .config/
    └── user-dirs.dirs    # Standart XDG klasör yollarının tanımları
```
