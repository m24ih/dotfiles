# 🔑 SSH Yapılandırması ve Güvenlik Kuralları

Bu paket, SSH istemci ayarlarını (`~/.ssh/config`) ve SSH sunucusuna (`sshd`) yönelik ağ erişim kısıtlamalarını yönetir.

---

## 📁 Dosya Yapısı

```text
ssh/
├── .ssh/
│   └── config         # İstemci yapılandırması (Proton Pass SSH Agent & kısayollar)
└── README.md          # Bu dokümantasyon
```

---

## 🖥️ İstemci Yapılandırması (`~/.ssh/config`)

`stow` aracılığıyla `~/.ssh/config` konumuna bağlanır:

```ssh
# Tüm SSH bağlantıları için varsayılan Proton Pass SSH Agent kullanımı
Host *
    IdentityAgent ~/.ssh/proton-pass-ssh-agent.sock

# Özel Sunucu Kısayolu
Host sunucum
    HostName 212.108.107.116
    User melih

Host yusuf
    HostName fedora
    User yusuf
```

* **Proton Pass Entegrasyonu:** SSH anahtarları yerel diskte şifresiz tutulmaz; Proton Pass masaüstü uygulamasının sunduğu agent soketi (`~/.ssh/proton-pass-ssh-agent.sock`) üzerinden doğrulanır.
* **Sunucu Kısayolları:** `ssh sunucum` veya `ssh yusuf` şeklinde hızlı bağlantı sağlar.

---

## 🛡️ Sunucu Güvenlik Yapılandırması (`/etc/ssh/sshd_config.d/`)

Sunucu güvenliği için `/etc/ssh/sshd_config.d/10-allowed-networks.conf` dosyası kullanılır:

```ssh
AllowUsers melih@192.168.1.* melih@192.168.0.* melih@100.*.*.* melih@127.0.0.1
```

### Güvenlik Kurallarının Anlamı:
1. **Kullanıcı Kısıtlaması:** Sadece `melih` kullanıcısı giriş yapabilir. `root` dahil diğer tüm hesaplar engellenir.
2. **Ağ Kısıtlaması:** Yalnızca aşağıdaki IP bloklarından gelen bağlantılar kabul edilir:
   * `192.168.1.*` & `192.168.0.*` (Yerel Ev/Ofis Ağı)
   * `100.*.*.*` (**Tailscale / CGNAT VPN Ağı**)
   * `127.0.0.1` (Yerel makine)

### Otomatik Kurulum:
Bu kuralı sisteme uygulamak için ana dizindeki betiği çalıştırmak yeterlidir:
```bash
./setup_sshd.sh
# veya
./install.sh sshd
```
