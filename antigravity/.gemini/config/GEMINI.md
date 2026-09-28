# Antigravity Global Geliştirici & Güvenlik Kuralları (agy CLI & Antigravity 2.0)

## 🔒 Güvenlik & Gizli Anahtar (Secret) Koruması
- **Zorunlu Gitleaks Taraması:** Herhangi bir Git deposunda değişiklik commitlemeden (`git commit`) önce **MUTLAKA** `gitleaks git --staged` komutu çalıştırılmalı ve çıktısı incelenmelidir.
- **Sızıntı Durumunda Davranış:** Eğer `gitleaks` herhangi bir API anahtarı, token, parola, kimlik bilgisi (credential) veya hassas veri tespit ederse:
  1. Commit işlemi derhal durdurulmalıdır.
  2. Kullanıcıya hangi dosya ve satırda ne tür bir sızıntı tespit edildiği net bir şekilde açıklanmalıdır.
  3. Kullanıcının açık ve net onayı olmadan kesinlikle commit işlemi tamamlanmamalıdır.
- **Hassas Dosyaların Korunması:** `.env`, `*.key`, `*.pem`, `credentials.json`, `token*`, SSH özel anahtarları gibi dosyalar asla Git kuyruğuna alınmamalı, her zaman `.gitignore` ile korunmalıdır.

## 🛠️ Kod Kalitesi ve Doğrulama
- **Doğrulama Önceliği (Evidence Before Assertions):** Bir görevin tamamlandığı iddia edilmeden önce ilgili testler veya doğrulama komutları (derleme, lint, syntax check vb.) fiilen çalıştırılmalı ve çıktısı teyit edilmelidir.
- **Standart Commit Formatı:** Tüm commit mesajları konvansiyonel standartta (`feat(...)`, `fix(...)`, `refactor(...)`, `chore(...)` vb.) ve açıklayıcı olmalıdır.

## 🌐 Tarayıcı Otomasyonu (/browser)
- **/browser Komutlarında Ön Koşul:** Kullanıcı `/browser` komutunu veya tarayıcı otomasyonu gerektiren bir istek verdiğinde, herhangi bir işlem yapmadan önce Chrome'un 9222 portunun açık olup olmadığını kontrol et; açık değilse **MUTLAKA** şu komutla başlat:
  ```bash
  google-chrome-stable --remote-debugging-port=9222 --user-data-dir="$HOME/.config/chrome-debug"
  ```

## 🧠 Merkezi İkinci Beyin & Hafıza Entegrasyonu (/home/melih/Sync/Obsidian/Agent)
Kullanıcının düşünme ortağı ve merkezi ikinci beyin vault'u `/home/melih/Sync/Obsidian/Agent` konumundadır. Hangi projede, dizinde veya oturumda çalışırsan çalış bu sistem daima aktiftir:
- **Kişiselleştirme ve Kurallar:** Oturum başında `/home/melih/Sync/Obsidian/Agent/🔮 850-Companion/` altındaki `Core.md`, `Kurallar.md`, `Last-Session.md` ve aktif `Threads.md` dosyalarını dikkate al. Melih'in doğrudan söylediği tercihler, kararlar ve olgular bu dosyalardan öğrenilir.
- **Hafızaya Kayıt Varsayılanı (ÖNEMLİ):** Kullanıcı açıkça *"bunu kaydetme"*, *"beyne kaydetme"* veya *"[kaydetme]"* demediği sürece; oturum boyunca konuşulan tüm önemli mimari kararları, öğrenilen bilgileri, çevre/araç detaylarını ve proje ilerlemelerini varsayılan olarak ikinci beyne kaydet.
- **Nasıl Kaydedilir:**
  - Tekrar kullanılabilir kalıcı bilgi/karar: `/usr/bin/python3 /home/melih/Sync/Obsidian/Agent/beyin.py note-create --file <json>` veya vault'taki `knowledge/` altına Markdown notu oluşturup ardından `sync` çalıştır.
  - Görevler: `/usr/bin/python3 /home/melih/Sync/Obsidian/Agent/beyin.py task-create --file <json>`.
  - Oturum sonu devir kartı: `/home/melih/Sync/Obsidian/Agent/🔮 850-Companion/Last-Session.md` dosyasını son durumla yerinde güncelle.
  - Açık konu takibi: `/home/melih/Sync/Obsidian/Agent/🔮 850-Companion/Threads.md` dosyasını güncelle.
  - Her güncellemeden sonra senkronizasyon: `/usr/bin/python3 /home/melih/Sync/Obsidian/Agent/beyin.py sync`
- **Arama / Hatırlama:** Vault içindeki bilgiyi bulmak için `/usr/bin/python3 /home/melih/Sync/Obsidian/Agent/beyin.py context "<arama sorgusu>"` çalıştır.

## 🤖 Subagent / Çoklu Ajan Protokolü
- **Görev Delegasyonu:** Verilen görevlerde bağımsız araştırma, analiz, kodlama veya test işlerini ana context penceresini şişirmeden alt ajanlara (`invoke_subagent`) devret.
  - **Araştırma & İnceleme:** Kod tabanında çoklu dosya taraması, kütüphane incelemeleri veya web araştırmaları için salt-okunur `research` subagent'ını devreye sok.
  - **Paralel Görevler:** Birbirine bağımlı olmayan modül, özellik veya refactoring adımlarında `dispatching-parallel-agents` prensibiyle paralel `self` subagent'ları çalıştır.
  - **Test & Doğrulama:** Geliştirme sonrasında testlerin yazımı, çalıştırılması veya kod incelemesi adımlarını bağımsız bir alt ajana bırak.
  - **Atomik İstisna:** Tek adımlı, küçük düzeltmeler veya doğrudan tek yanıtta biten basit işlerde gereksiz gecikme ve maliyet üretmemek adına subagent fırlatma.
