# 🚀 Google Antigravity CLI (`agy`) Yapılandırması

Bu dizin, **Google Antigravity CLI** (`agy`) için sistem seviyesindeki kullanıcı tercihlerini, sandbox yürütme politikalarını, güvenlik kısıtlamalarını ve çalışma alanı izinlerini barındırır.

---

## 🎯 Google Antigravity CLI Nedir?

**Antigravity**, Google DeepMind bünyesinde geliştirilen gelişmiş bir otonom kodlama asistanı ve eşli programlama (pair-programming) platformudur. Terminal veya IDE üzerinden doğrudan çalışarak:
- Dosya sistemini analiz edebilir, arama (`grep`, `fd`) ve dosya düzenleme yapabilir.
- Güvenli sandbox yalıtımında komut çalıştırabilir.
- Arka planda bağımsız alt ajanlar (**subagents**) koşturarak paralel araştırma ve test yürütebilir.
- Test Odaklı Geliştirme (TDD), Planlama (Writing Plans) ve Alt Ajan Destekli Geliştirme (SDD) metodolojilerini benimser.

---

## 📁 Dizin ve Dosya Yapısı

```text
antigravity/
├── .gemini/
│   └── antigravity-cli/
│       └── settings.json        # Ana yapılandırma, izinler, kısıtlamalar ve çalışma alanları
└── README.md                    # Bu dokümantasyon belgesi
```

### 🔗 Sisteme Bağlantı (Symlink)

Antigravity CLI, varsayılan olarak kullanıcı ana dizinindeki `~/.gemini/antigravity-cli` yolunu arar. Bu dizin doğrudan dotfiles içine sembolik bağla bağlanmıştır:

```bash
# Bağlantının durumu:
~/.gemini/antigravity-cli -> ~/Projects/dotfiles/antigravity/.gemini/antigravity-cli
```

> [!NOTE]
> `antigravity/.gemini/antigravity-cli/` içerisinde çalışma esnasında dinamik olarak oluşan oturum logları (`logs/`), bellek dökümleri (`brain/`), durum kilitleri (`presence/*.lock`) ve semantik indeksler (`annotations/*.pbtxt`), dotfiles deposunun kökündeki [`.gitignore`](../.gitignore) tarafından otomatik olarak dışlanır. Yalnızca sürüm kontrolünde tutulması gereken ana yapılandırma olan `settings.json` repoda yer alır.

---

## 🛡️ Güvenlik Politikası & Engellenen Komutlar (`permissions.deny`)

Sistem güvenliğini ve veri bütünlüğünü garantiye almak amacıyla `settings.json` içerisinde yapay zekanın kullanıcı onayı alsa dahi kesinlikle **yürütemeyeceği (kara listeye alınmış)** kritik komut kalıpları tanımlanmıştır:

| Kategori | Engellenen Kalıplar | Amaç / Gerekçe |
| :--- | :--- | :--- |
| **Yetki Yükseltme** | `sudo *`, `su *`, `doas *` | Sistemin kök (root) dizinine yetkisiz müdahalenin engellenmesi |
| **Yıkıcı Silme** | `rm -rf *`, `rm -r /*`, `rm -rf /*` | Kazara tüm proje veya kök dosya sisteminin silinmesini önleme |
| **Disk & Bölüntü** | `mkfs*`, `dd *`, `fdisk *`, `parted *` | Depolama birimlerinin biçimlendirilmesi veya bozulmasını engelleme |
| **İzin Manipülasyonu** | `chmod -R 777 *`, `chown -R *` | Güvensiz global dosya izinleri verilmesini önleme |
| **Paket Yönetimi** | `pacman *`, `yay *`, `paru *` | Kullanıcının bilgisi dışında sisteme izinsiz paket kurulmasını engelleme |
| **Servis & Güç** | `systemctl *`, `reboot`, `shutdown*` | Sistem servislerinin ve makinenin aniden kapatılmasını önleme |
| **Yıkıcı Git** | `git push --force*`, `git reset --hard*`, `git clean -f*`, `git rebase *` | Uzak depodaki geçmişin ezilmesini ve yerel değişikliklerin kaybını engelleme |
| **Pipe / Script İndirme** | `curl * \| bash`, `wget * \| sh` vb. | İnternetten indirilen şüpheli kabuk betiklerinin denetimsiz çalışmasını engelleme |
| **Konteyner Temizliği** | `docker system prune*`, `docker rm -f*`, `docker volume rm*` | Çalışan Docker imajlarının veya veritabanı volumelerinin silinmesini engelleme |

---

## ⚙️ Temel Çalışma Ayarları (`settings.json`)

* **Model:** `"Gemini 3.8 Flash (High)"` — Düşük gecikme, yüksek token kapasitesi ve derin mantıksal çıkarım yeteneğine sahip birincil model.
* **Editör Entegrasyonu:** `"editor": "nvim"` — Harici dosya görüntüleme ve hızlı düzenlemelerde Neovim çağrılır.
* **Sandbox Yalıtımı:** `"enableTerminalSandbox": true` — Komutların sistemden izole, güvenli bir kum havuzunda yürütülmesini sağlar.
* **Araç Yürütme:** `"toolPermission": "always-proceed"` — Onaylı dosya okuma/yazma araçlarının kesintisiz çalışmasını mümkün kılar.
* **Harici Dizin Erişimi:** `"allowNonWorkspaceAccess": true` — Çalışma alanı dışındaki referans dosyaların incelenebilmesine izin verir.
* **Telemetri & Geri Bildirim:** `"enableTelemetry": false`, `"showFeedbackSurvey": false` — Kullanıcı gizliliği için telemetri kapalıdır.

---

## 📂 Güvenilen Çalışma Alanları (`trustedWorkspaces`)

Antigravity CLI'ın tam yetkiyle çalışabildiği yerel geliştirme ve not dizinleri:

* `~/Projects` (Tüm kaynak kod projeleri ve repolar)
* `~/Projects/dotfiles` (Sistem yapılandırma deposu)
* `~/Sync/Obsidian/Personal-Obsidian` (Kişisel notlar ve wiki arşivi)
* `~/.config` (Kullanıcı yapılandırmaları)
* `~/Documents` & `~/Downloads`

---

## 🔌 Eklenti (Plugin) Ekosistemi

CLI, `~/.gemini/config/plugins/` altında kurulu özel beceri (skill) paketleri ile güçlendirilmiştir:

1. **`superpowers`**:
   - `brainstorming`: Kod yazmaya başlamadan önce gereksinimleri netleştirme.
   - `writing-plans`: Çok adımlı mimari planlama dokümanları üretme.
   - `subagent-driven-development`: Görevleri alt ajanlara dağıtarak eşzamanlı tamamlama.
   - `test-driven-development` (TDD): Önce testleri yazıp ardından uygulamayı geliştirme.
   - `systematic-debugging`: Sistematik kök neden analizi ve hata tespiti.
   - `verification-before-completion`: İddia edilen her değişikliği çalıştırmadan önce kanıtlama.

2. **`ponytail`**:
   - Aşırı mühendisliği (over-engineering) engelleyen, en sade, en kısa ve en az bağımlılıklı çözümü zorlayan kıdemli mühendis yaklaşımı (`ponytail-review`, `ponytail-audit`, `ponytail-debt`).
