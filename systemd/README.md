# ⚙️ Systemd (Kullanıcı Düzeyi Servisler ve Ortam Değişkenleri)

Kullanıcı oturumu açıldığında arka planda otomatik olarak başlatılan `systemd --user` servisleri ve oturum ortam değişkenleri.

---

## 📦 Kurulum ve Gereksinimler

Systemd tüm modern Linux dağıtımlarında yerel olarak gelir. İlgili servislerin paketlerini kurmak için:

```bash
# Sunshine (Yayın Servisi):
yay -S --needed sunshine

# Proton Pass CLI (SSH Agent):
yay -S --needed proton-pass-bin
```

---

## 📁 Dosya Yapısı

```text
systemd/
└── .config/
    ├── systemd/
    │   └── user/
    │       └── sunshine.service    # Sunshine sunucusunu başlatan kullanıcı servisi
    └── environment.d/
        └── proton-pass.conf        # Proton Pass SSH Agent soket yolu ortam değişkeni
```

---

## ⚙️ Servis Yönetim Komutları

Servisleri yönetmek için `sudo` kullanmadan doğrudan kullanıcı yetkisiyle şu komutlar kullanılır:

```bash
# Sunshine servisini başlat / durdur / yeniden başlat
systemctl --user start sunshine.service
systemctl --user stop sunshine.service
systemctl --user restart sunshine.service

# Durumunu kontrol et
systemctl --user status sunshine.service

# Açılışta otomatik başlamasını sağla
systemctl --user enable sunshine.service
```
