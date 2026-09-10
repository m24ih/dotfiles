# 🔋 Dinamik Güç Yönetimi Betikleri (`power-management`)

Bu modül, dizüstü bilgisayarda **priz (AC)** ve **batarya (pil)** durumları arasında geçiş yapıldığında arka plandaki kaynak tüketicilerini otomatik olarak yöneten betikleri ve KDE Plasma (PowerDevil) entegrasyonunu sağlar.

---

## 🎯 Ne İşe Yarar?

Dizüstü bilgisayarlarda pil ömrünü en çok kısaltan faktörler işlemci taramaları ve harici ekran kartının (NVIDIA dGPU) gereksiz yere uyanık kalmasıdır.

Bu paket iki temel betik içerir:
1. **`power-on-battery.sh`** (Bataryaya Geçildiğinde):
   * **Sunshine Sunucusunu Durdurur:** Sunshine arka planda NVIDIA RTX 4060 GPU'ya doğrudan bağlı çalıştığı için kartın derin uykuya (`D3cold`) geçmesini engeller. Servis durdurulduğunda dGPU boşa çıkar, harcanan güç ~2-5W azalır ve sıcaklık düşer.
   * **Baloo Dosya İndekslemesini Askıya Alır (`balooctl6 suspend`):** KDE'nin arka plan disk ve dosya taramasını dondurarak disk G/Ç ve CPU döngülerinden tasarruf sağlar.
   * **Masaüstü Bildirimi Gönderir:** Güç tasarrufu moduna geçildiğini bildiren düşük öncelikli bir bildirim gösterir.

2. **`power-on-ac.sh`** (Prize / Şarja Takıldığında):
   * **Sunshine Sunucusunu Başlatır:** Priz gücüne geçildiğinde oyun akış sunucusunu otomatik olarak tekrar aktif eder.
   * **Baloo Dosya İndekslemesini Devam Ettirir (`balooctl6 resume`):** Dosya indeksleme sürecini kaldığı yerden devam ettirir.
   * **Masaüstü Bildirimi Gönderir:** Performans moduna dönüldüğünü bildirir.

---

## 📂 Dosya Yapısı

```text
power-management/
├── .local/
│   └── bin/
│       ├── power-on-battery.sh   # Batarya güç tasarruf betiği
│       └── power-on-ac.sh        # Priz performans modu betiği
└── README.md                     # Bu kılavuz belgesi
```

`stow` ile bağlandığında betikler doğrudan `~/.local/bin/` dizinine sembolik bağ (symlink) olarak yerleşir:
* `~/.local/bin/power-on-battery.sh`
* `~/.local/bin/power-on-ac.sh`

---

## ⚙️ KDE Plasma Entegrasyonu (PowerDevil)

KDE Plasma 6, güç durum değişimlerinde otomatik komut çalıştırmayı destekler. Yapılandırma `~/.config/powerdevilrc` dosyasında şu şekilde tutulur:

```ini
[AC][RunScript]
ProfileLoadCommand=/home/melih/.local/bin/power-on-ac.sh

[Battery][RunScript]
ProfileLoadCommand=/home/melih/.local/bin/power-on-battery.sh
```

### Grafik Arayüzden Kontrol Etmek İsterseniz:
1. **Sistem Ayarları (System Settings)** > **Güç Yönetimi (Power Management)** yoluna gidin.
2. Üstteki sekmelerden **"On Battery" (Pilde)** sekmesini seçin.
3. **"Run command or script"** (Komut veya betik çalıştır) alanını bulun.
4. "When entering 'On Battery' state" karşısına `/home/melih/.local/bin/power-on-battery.sh` yazın.
5. Benzer şekilde **"On AC Power" (Fişte)** sekmesine geçip `/home/melih/.local/bin/power-on-ac.sh` yolunu tanımlayın.
6. **Uygula (Apply)** butonuna tıklayın.

---

## 🛠️ Nasıl Test Edilir?

Terminal üzerinden betiklerin sorunsuz çalıştığını manuel olarak test edebilirsiniz:

```bash
# 1. Batarya tasarruf modunu test et:
~/.local/bin/power-on-battery.sh

# Durumu doğrula:
balooctl6 status                     # Indexer state: Suspended olmalı
systemctl --user status sunshine     # inactive (dead) olmalı
nvidia-smi                           # GPU'da Sunshine kalmamalı

# 2. Priz modunu test et:
~/.local/bin/power-on-ac.sh

# Durumu doğrula:
balooctl6 status                     # Indexer state: Idle / Running olmalı
systemctl --user status sunshine     # active (running) olmalı
```

---

## 🔧 Yeni Servisler Eklemek (Özelleştirme)

İleride bataryadayken başka servisleri de kapatmak isterseniz (örneğin Docker konteynerleri, Syncthing veya Free Download Manager), `power-on-battery.sh` dosyasındaki hazır yorum satırlarını açabilir veya yeni komutlar ekleyebilirsiniz:

```bash
# Örnek: Docker konteynerlerini bataryada kapatmak için:
docker stop $(docker ps -q) 2>/dev/null || true

# Örnek: Syncthing dosya eşitlemeyi durdurmak için:
systemctl --user stop syncthing.service 2>/dev/null || true
```
