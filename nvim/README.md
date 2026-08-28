# 💤 Neovim (LazyVim Yapılandırması)

Lua tabanlı, [LazyVim](https://github.com/LazyVim/LazyVim) çatısı üzerine kurulu modern, hafif ve hızlı IDE ortamı.

---

## 📦 Kurulum

Eğer sisteminizde Neovim ve derleme bağımlılıkları kurulu değilse şu komutla kurabilirsiniz:

```bash
# Arch / CachyOS:
sudo pacman -S --needed neovim ripgrep fd git base-devel lazygit
# veya AUR:
yay -S --needed neovim ripgrep fd git base-devel lazygit
```

---

## 📁 Dosya Yapısı

```text
nvim/
└── .config/
    └── nvim/
        ├── init.lua          # Neovim başlatıcı dosyası
        ├── lazyvim.json      # LazyVim ekstra eklenti durumu
        └── lua/
            ├── config/       # Temel seçenekler (options), kısayollar (keymaps) ve autocommand'lar
            └── plugins/      # Özel kullanıcı eklentileri (LSP, Treesitter, Tema vb.)
```

---

## ⚙️ Önemli Kısayollar (Keymaps)

* `<Space>`: Ana lider tuşu (Leader Key).
* `<Space> e`: Neo-tree dosya yöneticisi ağacını aç/kapat.
* `<Space> ff`: Dosya bulucu (Telescope file picker).
* `<Space> sg`: Proje genelinde anlık metin arama (Live grep).
* `<Space> gg`: Lazygit terminal arayüzünü aç.
* `<Space> l`: Lazy.nvim eklenti yöneticisini aç.
