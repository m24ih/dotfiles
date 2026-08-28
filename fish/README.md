# 🐟 Fish Shell (Akıllı ve Kullanıcı Dostu Kabuk)

Otomatik tamamlama, syntax renklendirme ve zengin fonksiyon desteği sunan etkileşimli kabuk yapılandırması.

---

## 📦 Kurulum

Eğer sisteminizde kurulu değilse şu komutla kurabilirsiniz:

```bash
# Arch / CachyOS:
sudo pacman -S --needed fish
# veya AUR:
yay -S --needed fish
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
        ├── config.fish       # Ana kabuk yapılandırması, alias'lar ve ortam değişkenleri
        ├── conf.d/           # Eklenti ve modüler ayarlar
        └── completions/      # CLI araçları için özel otomatik tamamlama betikleri
```

---

## ⚙️ Önemli Yapılandırmalar & Entegrasyonlar

* **Starship Prompt:** Terminal istemcisi olarak Starship ile entegre çalışır.
* **Akıllı Tamamlama:** `fastfetch`, `pacman`, `git`, `docker` ve `systemctl` gibi yaygın komutlar için geçmişe duyarlı akıllı tamamlama.
* **Kısayollar / Alias'lar:** Sık kullanılan sistem komutları için kısaltmalar tanımlıdır.
