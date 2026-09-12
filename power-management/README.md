# 🔋 Donanım & Masaüstü Güç Yönetimi (`power-management`)

Bu modül, dizüstü bilgisayarda **priz (AC)** ve **batarya (pil)** durumları arasında geçiş yapıldığında hem donanım/çekirdek seviyesinde (TLP) hem de masaüstü/kullanıcı seviyesinde (KDE Plasma PowerDevil) kaynak tüketicilerini akıllı ve dinamik olarak yönetir.

---

## 🏛️ İki Katmanlı Güç Mimarisi

Güç tasarrufu ve performans dengesi iki tamamlayıcı katmanda yürütülür:

```text
┌──────────────────────────────────────────────────────────────────┐
│                   GÜÇ DURUMU DEĞİŞİMİ (AC ⟷ BAT)                 │
└────────────────┬────────────────────────────────┬────────────────┘
                 │                                │
                 ▼                                ▼
  [Katman 1: Donanım & Çekirdek (TLP)]   [Katman 2: Masaüstü & Servisler (KDE)]
  ├── CPU Turbo Boost (AC: 1, BAT: 0)     ├── Sunshine Sunucusu (dGPU Uyku)
  ├── Pil Tasarruf Profili (BAT: SAV)     ├── Baloo İndeksleyici (Suspend/Resume)
  ├── Enerji/Performans Politikası (EPP)  └── Masaüstü Bildirimleri
  └── PPD & Tuned Servislerini Maskeleme
```

### 1. Katman 1: Donanım & Çekirdek Güç Yönetimi (TLP)
- **CPU Turbo Boost Denetimi:** Prizdeyken Intel/AMD işlemcilerde maksimum performans için Turbo Boost devrededir (`CPU_BOOST_ON_AC=1`). Bataryaya geçildiğinde gereksiz anlık frekans patlamalarını ve yüksek watt tüketimini engellemek için Turbo Boost kapatılır (`CPU_BOOST_ON_BAT=0`, `CPU_BOOST_ON_SAV=0`).
- **Batarya Güç Profili:** Bataryada `SAV` (Power Saving) profiline geçilerek PCIe ASPM, ses kartı güç tasarrufu ve disk G/Ç zaman aşımları en verimli seviyeye çekilir.
- **Platform Profilleri:** AC modunda `performance`, bataryada `low-power` platform profili işletilir.

### 2. Katman 2: Masaüstü & Kullanıcı Betikleri (KDE PowerDevil)
- **`power-on-battery.sh` (Bataryaya Geçildiğinde):**
  - **Sunshine'ı Durdurur:** NVIDIA RTX 4060 dGPU'ya doğrudan bağlı oyun akış servisini durdurur. Harici ekran kartı anında derin uykuya (`D3cold`) geçer, sıcaklık düşer ve boşa harcanan ~2-5W güç tasarruf edilir.
  - **Baloo İndeksleyicisini Askıya Alır (`balooctl6 suspend`):** Disk ve CPU taramalarını dondurur.
  - **TLP'yi Batarya Moduna Alır:** Udev gecikmelerini beklemeden anında batarya profilini tetikler.
- **`power-on-ac.sh` (Prize / Şarja Takıldığında):**
  - **Sunshine'ı Başlatır:** Priz gücünde oyun akışını otomatik tekrar açar.
  - **Baloo'yu Devam Ettirir (`balooctl6 resume`):** Dosya indekslemeyi kaldığı yerden sürdürür.
  - **TLP'yi AC Moduna Alır:** Yüksek performans profiline anında geçişi garantiler.

---

## ⚠️ TLP, Power-Profiles-Daemon (PPD) ve Tuned Çakışması

Modern Linux dağıtımlarında güç yönetiminde en sık karşılaşılan sorun TLP, PPD ve Tuned'un aynı sysfs düğümlerine ve CPU governor'larına hükmetmeye çalışmasıdır:

| Araç | Çalışma Prensibi | Çakışma Nedeni | Çözüm |
| :--- | :--- | :--- | :--- |
| **TLP** | Kapsamlı kernel/donanım optimizasyon motoru | PPD ve Tuned ile aynı anda çalışamaz | **Birincil güç yöneticisi olarak kullanılır.** |
| **PPD** (`power-profiles-daemon`) | GNOME/KDE basit 3 kademeli güç profili daemon'ı | TLP ile servis çakışması üretir | Sistemde **maskelenir** (`systemctl mask`). Arch'ta `tlp-pd` drop-in paketiyle PPD emüle edilir. |
| **Tuned** | Dağıtıma özel profil yöneticisi (Fedora/RHEL) | TLP güç ayarlarını ezer | Sistemde **maskelenir** (`systemctl mask`). |

### `--allowerasing` ve Paket Yöneticisi Entegrasyonu:
Fedora ve DNF tabanlı sistemlerde `tlp` paketi kurulurken varsayılan gelen `power-profiles-daemon` paket çakışması çıkarır. Bu nedenle dotfiles kurulum motorunda ([`install.sh`](file:///home/melih/Projects/dotfiles/install.sh)) tüm DNF komutlarına standart olarak `--allowerasing` argümanı eklenmiştir:
```bash
sudo dnf install -y --allowerasing tlp ...
```
Arch Linux tarafında ise [`packages/hardware.txt`](file:///home/melih/Projects/dotfiles/packages/hardware.txt) içindeki `tlp-pd` paketi PPD'nin yerini doğrudan alarak KDE ve masaüstü arayüzlerinin TLP'yi yerel güç profili gibi görmesini sağlar.

---

## 📂 Dosya Yapısı

```text
power-management/
├── .local/
│   └── bin/
│       ├── power-on-battery.sh     # Batarya modu dinamik geçiş betiği
│       └── power-on-ac.sh          # Priz modu performans geçiş betiği
├── etc/
│   └── tlp.d/
│       └── 01-power-save.conf      # TLP drop-in batarya & CPU boost yapılandırması
├── .stow-local-ignore              # etc/ dizininin $HOME içine stow edilmesini engeller
└── README.md                       # Bu kılavuz belgesi
```

* `stow power-management` çalıştırıldığında betikler `~/.local/bin/` dizinine yerleşir.
* `etc/` dizini `.stow-local-ignore` ile korunur; sistem yapılandırması [`scripts/setup_power_management.sh`](file:///home/melih/Projects/dotfiles/scripts/setup_power_management.sh) tarafından `/etc/tlp.d/01-power-save.conf` konumuna kurulur.

---

## ⚙️ Kurulum ve Yapılandırma

Tüm güç yönetimini, TLP konfigürasyonunu ve KDE PowerDevil entegrasyonunu tek komutla kurmak için:

```bash
bash scripts/setup_power_management.sh
```

Bu betik otomatik olarak:
1. `power-profiles-daemon.service` ve `tuned.service` servislerini durdurup maskeler.
2. `01-power-save.conf` dosyasını `/etc/tlp.d/` altına yerleştirir.
3. `tlp.service` servisini devreye alır ve `tlp start` çalıştırır.
4. `~/.config/powerdevilrc` dosyasına AC ve Battery betik yollarını kaydeder.

---

## 🛠️ Nasıl Test Edilir ve Doğrulanır?

### 1. TLP ve Donanım Durumunu Doğrulama:
```bash
# TLP genel durumu ve aktif profil:
sudo tlp-stat -s

# CPU frekansları ve Turbo Boost durumu:
sudo tlp-stat -p

# PPD ve Tuned'un maskelendiğini kontrol et:
systemctl is-enabled power-profiles-daemon tuned
# Çıktı: "masked" olmalıdır
```

### 2. Dinamik Kullanıcı Betiklerini Test Etme:
```bash
# Batarya modunu simüle et:
~/.local/bin/power-on-battery.sh

# Doğrula:
balooctl6 status                     # Suspended olmalı
systemctl --user status sunshine     # inactive (dead) olmalı
nvidia-smi                           # GPU'da Sunshine kalmamalı

# Priz modunu simüle et:
~/.local/bin/power-on-ac.sh

# Doğrula:
balooctl6 status                     # Idle / Running olmalı
systemctl --user status sunshine     # active (running) olmalı
```

---

## 🔧 Özelleştirme

Bataryadayken kapatmak istediğiniz ilave servisler varsa (örneğin Docker konteynerleri, Syncthing veya indirme yöneticileri), `~/.local/bin/power-on-battery.sh` içindeki hazır şablon satırlarını aktif hale getirebilirsiniz.
