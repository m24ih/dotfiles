# 💤 Neovim (LazyVim Yapılandırması)

Lua tabanlı, [LazyVim](https://github.com/LazyVim/LazyVim) altyapısı üzerine kurulu, Wayland sistem panosu (`wl-clipboard`), Türkçe/İngilizce yazım denetimi ve modern LSP eklentileriyle donatılmış IDE ortamı.

---

## 📦 Kurulum ve Temel Bağımlılıklar

Neovim ve eklentilerin (Telescope, Tree-sitter, Mason, Lazygit) eksiksiz çalışabilmesi için gereken araçlar:

```bash
# Arch / CachyOS:
sudo pacman -S --needed neovim ripgrep fd git base-devel lazygit wl-clipboard tree-sitter-cli
# veya AUR:
yay -S --needed neovim ripgrep fd git base-devel lazygit wl-clipboard tree-sitter-cli
```

---

## 📁 Dosya Yapısı

```text
nvim/
└── .config/
    └── nvim/
        ├── init.lua          # Neovim başlangıç noktası
        ├── lazyvim.json      # Aktif LazyVim ekstra modülleri
        └── lua/
            ├── config/
            │   ├── options.lua   # Wayland panosu (wl-copy) ve Türkçe/İngilizce yazım denetimi
            │   ├── keymaps.lua   # Özel lider tuşu kısayolları
            │   └── autocmds.lua  # Otomatik komutlar
            └── plugins/          # Kullanıcı tanımlı özel eklenti konfigürasyonları
```

---

## ⚙️ Yapılandırma Detayları (`lua/config/options.lua`)

### 1. 📋 Wayland Yerel Pano Entegrasyonu (`wl-clipboard`)
* `vim.g.clipboard` üzerinden `wl-copy` ve `wl-paste` tanımlanmıştır. Sistem genelindeki kopyalama/yapıştırma panosu ile Neovim içi `y` / `p` işlemleri gecikmesiz ve pürüzsüz eşzamanlanır.

### 2. ✍️ Çok Dilli Yazım Denetimi (Spell Check)
* `vim.opt.spelllang = { "en", "tr" }`: Hem Türkçe hem İngilizce kelimeleri tanıyan sözlük denetimi.

---

## ⌨️ Önemli Kısayollar (Keymaps)

* `<Space>`: Ana Lider Tuşu (Leader Key).
* `<Space> e`: Neo-tree dosya gezgini panelini açar/kapatır.
* `<Space> ff`: Telescope ile proje içi dosya arama.
* `<Space> sg`: Ripgrep ile proje genelinde anlık metin arama (Live grep).
* `<Space> gg`: Lazygit görsel Git yönetim arayüzünü açar.
* `<Space> l`: Lazy.nvim eklenti yönetim ekranı.
* `<Space> cm`: Mason LSP/Formatter yönetim ekranı.
