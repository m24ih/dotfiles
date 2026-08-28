# 🚀 Starship (Çapraz Kabuk Komut Satırı İstemi)

Rust ile yazılmış, minimal, aşırı hızlı ve zengin özelleştirilebilir cross-shell prompt (komut satırı göstergesi).

---

## 📦 Kurulum

Eğer sisteminizde kurulu değilse şu komutla kurabilirsiniz:

```bash
# Arch / CachyOS:
sudo pacman -S --needed starship
# veya AUR:
yay -S --needed starship
```

Kabuğunuzda (Fish/Zsh/Bash) aktifleştirmek için:
* **Fish (`config.fish`):** `starship init fish | source`
* **Zsh (`.zshrc`):** `eval "$(starship init zsh)"`

---

## 📁 Dosya Yapısı

```text
starship/
└── .config/
    └── starship.toml    # Prompt formatı, renkler, semboller ve modül ayarları
```

---

## ⚙️ Desteklenen Göstergeler

* **Git Durumu:** Aktif branch, commit hash, staged/unstaged dosya durumu.
* **Programlama Dilleri:** Python (venv), Node.js, Rust, Go, Java vb. aktif ortam sürümleri.
* **Sistem Durumu:** Pil seviyesi, çalışma süresi ve komut yürütme zamanı.
