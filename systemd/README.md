# ⚙️ Systemd (Kullanıcı Düzeyi Servisler ve Ortam Değişkenleri)

Kullanıcı oturumu açıldığında arka planda otomatik olarak devreye giren `systemd --user` servisleri ve `environment.d` oturum ortam değişkenleri.

---

## 📦 Kurulum ve İlgili Paketler

Bu pakette yönetilen kullanıcı servisleri ve araçlar için:

```bash
# Sunshine (GameStream & İkinci Ekran Sunucusu):
yay -S --needed sunshine

# Proton Pass Masaüstü (Şifre & SSH Yönetimi):
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
        └── proton-pass.conf        # Proton Pass için Linux DBus keyring ortam değişkeni
```

---

## ⚙️ Yapılandırma Detayları

### 1. 🔑 Proton Pass Keyring (`environment.d/proton-pass.conf`)
* `PROTON_PASS_LINUX_KEYRING=dbus`: Kullanıcı oturumu açıldığında Proton Pass'in GNOME Keyring / KWallet üzerinden DBus arayüzü ile güvenli kilit açmasını sağlar.

### 2. ☀️ Sunshine Kullanıcı Servisi (`systemd/user/sunshine.service`)
* Grafik oturum (`graphical-session.target`) ve XDG masaüstü portalları yüklendikten sonra gecikmeli (`ExecStartPre=/bin/sleep 5`) olarak başlar.
* Çökme durumunda otomatik olarak tekrar dener (`Restart=on-failure`, `RestartSec=5s`).

---

## 🛠️ Servis Yönetim Komutları

Servisleri yönetmek için `sudo` kullanmadan doğrudan kullanıcı yetkisiyle şu komutlar kullanılır:

```bash
# Servis durumunu kontrol etme
systemctl --user status sunshine.service

# Servisi manuel başlatma / durdurma / yeniden başlatma
systemctl --user start sunshine.service
systemctl --user stop sunshine.service
systemctl --user restart sunshine.service

# Başlangıçta otomatik açılmayı aktif/pasif etme
systemctl --user enable sunshine.service
systemctl --user disable sunshine.service
```
