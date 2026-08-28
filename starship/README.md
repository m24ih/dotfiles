# 🚀 Starship (Çapraz Kabuk Komut Satırı İstemi)

Rust ile yazılmış, Tokyo Night paletiyle renklendirilmiş, donanım pil durumunu dinamik okuyan ve programlama dillerini otomatik tanıyan Powerline hap (pill) tasarımlı prompt.

---

## 📦 Kurulum ve Kabuk Entegrasyonu

Eğer sisteminizde Starship veya Nerd Font eksikse:

```bash
# Arch / CachyOS:
sudo pacman -S --needed starship ttf-jetbrains-mono-nerd
# veya AUR:
yay -S --needed starship ttf-jetbrains-mono-nerd
```

Kabuğunuzda aktifleştirme:
* **Fish (`config.fish`):** `starship init fish | source`
* **Zsh (`.zshrc`):** `eval "$(starship init zsh)"`

---

## 📁 Dosya Yapısı

```text
starship/
└── .config/
    └── starship.toml    # Powerline modülleri, özel pil betikleri ve renk paletleri
```

---

## ⚙️ Yapılandırma ve Özel Modüller (`starship.toml`)

### 1. 🔋 Donanımsal Özel Pil Göstergesi (Custom Battery Pills)
Linux `/sys/class/power_supply/BAT*/` arayüzünü doğrudan okuyan akıllı 4 aşamalı modül:
* **`custom.bat_good` (>= %50):** Yeşil renkli ` %` hapı.
* **`custom.bat_warn` (%20 - %50):** Sarı renkli ` %` uyarı hapı.
* **`custom.bat_crit` (< %20):** Kırmızı renkli ` %` kritik pil hapı.
* **`custom.bat_hidden`:** Şarj aleti takılıyken (AC prizde) pil simgesi gizlenerek satır sonu estetik şekilde kapatılır.

### 2. 🎨 Tokyo Night & Catppuccin Renk Paletleri
* Varsayılan olarak **Tokyo Night** paleti aktiftir.
* Dosya içerisinde alternatif olarak **Catppuccin (Mocha, Frappé, Macchiato, Latte)** paletleri de hazır tanımlıdır.

### 3. 🛠️ Geliştirici & Ortam Göstergeleri
* **Diller & Çalışma Zamanları:** `Node.js`, `Bun`, `Rust`, `Go`, `Python` (ve sanal ortam adı), `Java`, `Kotlin`, `C`, `Haskell`, `PHP`.
* **Conda Desteği:** Aktif Anaconda ortamını anında gösterir.
* **Git Durumu:** Staged (`+`), modified (`!`), untracked (`?`), ahead (`⇡`), behind (`⇣`).
* **Özel Klasör İkonları:** `Documents`, `Downloads`, `Pictures`, `Music` ve `Developer` klasörlerine özel Nerd Font ikonları atanmıştır.
* **Komut Süresi:** 45 saniyeden uzun süren işlemler için süre ve bildirim göstergesi (`cmd_duration`).
