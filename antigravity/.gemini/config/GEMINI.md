# Antigravity Global Geliştirici & Güvenlik Kuralları (agy CLI & Antigravity 2.0)

## 🔒 Güvenlik & Gizli Anahtar Koruması
- **Gitleaks:** Commit (`git commit`) öncesi zorunlu: `gitleaks git --staged`. Sızıntı tespit edilirse commit derhal durdurulur, kullanıcıya dosya/satır gösterilir, onaysız devam edilmez.
- **Hassas Dosyalar:** `.env`, `*.key`, `*.pem`, `credentials.json`, `token*`, SSH özel anahtarları daima `.gitignore` ile korunmalı, asla stage edilmemeli.

## 🛠️ Kod Kalitesi & Doğrulama
- **Doğrulama (Evidence Before Assertions):** Görevin bittiği iddia edilmeden önce ilgili test, derleme veya lint komutları fiilen çalıştırılıp çıktısı teyit edilmeli.
- **Commit Formatı & Sıklığı (Checkpoint Commits):** Conventional Commits standardı (`feat(...)`, `fix(...)`, `refactor(...)`, `test(...)`, `chore(...)`). Büyük işlerin tek commit'e yığılması beklenmez; bir subagent işini bitirdiğinde, bağımsız bir modül tamamlandığında veya önemli bir aşama kaydedildiğinde bekletilmeden atomik kontrol noktası (checkpoint) commit'i atılır. Olası regresyon ve hatalarda sağlam duruma güvenle dönülür.

## 🌐 Tarayıcı Otomasyonu (/browser)
- `/browser` veya DevTools işlemi öncesi Chrome 9222 portu kapalıysa başlat:
  ```bash
  google-chrome-stable --remote-debugging-port=9222 --user-data-dir="$HOME/.config/chrome-debug"
  ```

## 🧠 Merkezi İkinci Beyin (/home/melih/Sync/Obsidian/Agent)
Vault daima aktiftir. Melih aksini ("kaydetme") belirtmedikçe önemli kararları, bilgileri ve ilerlemeleri kaydet.
- **Başlangıç:** `/home/melih/Sync/Obsidian/Agent/🔮 850-Companion/` altındaki `Core.md`, `Kurallar.md`, `Last-Session.md` ve aktif `Threads.md` dosyalarını dikkate al.
- **Kayıt Kanalları:**
  - Kalıcı bilgi/karar: `/usr/bin/python3 /home/melih/Sync/Obsidian/Agent/beyin.py note-create --file <json>` veya `knowledge/` altına MD + `sync`.
  - Görevler: `/usr/bin/python3 /home/melih/Sync/Obsidian/Agent/beyin.py task-create --file <json>`.
  - Oturum sonu devir kartı: `🔮 850-Companion/Last-Session.md` dosyasını son durumla yerinde güncelle.
  - Günlük receipt (Zorunlu): `/usr/bin/python3 /home/melih/Sync/Obsidian/Agent/beyin.py receipt --file <json> --harness antigravity`
  - Kişisel günlük (Personal-Obsidian): Otomatik yazma devre dışıdır. Oturum ve ilerleme takibi yalnızca Agent kasasında tutulur; kişisel günlüğe sadece Melih açıkça talep ettiğinde eklenir.
  - Açık konu takibi: `🔮 850-Companion/Threads.md` güncelle.
  - Senkronizasyon: Her güncellemeden sonra `/usr/bin/python3 /home/melih/Sync/Obsidian/Agent/beyin.py sync`.
- **Arama:** `/usr/bin/python3 /home/melih/Sync/Obsidian/Agent/beyin.py context "<sorgu>"`.

## 🤖 Çoklu Model ve Hibrit Subagent Orkestrasyonu (Katı 4 Argon Protokolü)
Antigravity ana oturumunda **Gemini 4 Argon** kullanılırken ana ajan **saf orkestratör** olarak konumlanır; bizzat kaynak kod yazmaz (`write_file` / `edit_file` ile uygulama kodu üretmez). Kodlama, hata düzeltme, refactor ve test yazımı işlerini istisnasız aşağıdaki **Seviye 0 → 1A → 1B → 1C → 2 → 2.5** tablosuna göre CLI araçlarıyla (veya açık talimatla dahili `invoke_subagent` `Model: "flash"` üzerinden) diğer LLM'lere devreder.
- **Ana Ajanın Yalnızca Yürüteceği İşler:** Mimari planlama, görev dağıtımı, çıktı doğrulama (`evidence before assertions` — test/lint/build çalıştırma), git checkpoint commit ve İkinci Beyin (`beyin.py` / `note-edit`) senkronizasyonu.
- **Referans Kaynak:** `/home/melih/Sync/Obsidian/Agent/knowledge/coklu-model-hibrit-subagent-orkestrasyonu.md`

### Ajan Katmanları ve Öncelik Hiyerarşisi

| Katman | Araç / CLI | Model | Donanım / Maliyet & Kota Havuzu | Kullanım Alanı |
| :--- | :--- | :--- | :--- | :--- |
| **0. Seviye (Yerel)** | **Ollama** | `qwen2.5-coder:7b` (`ollama/qwen2.5-coder:7b`) | RTX 4060 GPU (~5.2 GB VRAM) / **0 Maliyet / Sınırsız** | Rutin fonksiyon yazımı, sözdizimi kontrolü, birim testler, boilerplate kodlar. |
| **1A. Seviye (OpenCode Dahili Ücretsiz)** | **`opencode`** | `opencode/deepseek-v4.1-flash-free`, `opencode/glm-5.3-flash-free`, `opencode/mimo-v2.6-flash-free`, `opencode/beam-free`, `opencode/flint-40b-free`, `opencode/nemotron-3.5-lightning-free`, `opencode/nemotron-3.5-super-vl-free`, `opencode/big-pickle` | **OpenCode Zen Havuzu** (OpenRouter'dan bağımsız kota) / **0 Maliyet** | Kod tabanı analizi, otonom kod yazımı, modül refactor, betik oluşturma, dokümantasyon, shell/test çalıştırma. |
| **1B. Seviye (OpenRouter Ücretsiz & Geniş Havuz)** | **`opencode`** | **Otomatik Ücretsiz Router:** `openrouter/openrouter/free`<br>**Doğrudan `:free` Modeller:** `openrouter/nvidia/nemotron-3-ultra-550b-a55b:free`, `openrouter/google/gemma-4-31b-it:free`, `openrouter/google/gemma-4-26b-a4b-it:free`, `openrouter/thinkingmachines/inkling:free`, `openrouter/cohere/north-mini-code:free`, `openrouter/recursive/flint-v1.0:free`, `openrouter/xingchen-agi/xing4.0-29b-a4b:free`<br>**Diğer OpenRouter Modelleri:** `openrouter/<vendor>/<model>` | **OpenRouter API Havuzu** (OpenCode Zen limitinden tamamen bağımsız) / **0 Maliyet / Esnek** | 1A (`opencode/*`) modelleri rate-limit (429) veya kota sınırına takıldığında Codex'e geçmeden önce başvurulan bağımsız bulut katmanı. |
| **1C. Seviye (NVIDIA NIM)** | **`opencode`** | Doğrulandı (2026-10-30): `nvidia/openai/gpt-oss-20b`, `nvidia/deepseek-ai/deepseek-v4.1-flash`, `nvidia/nvidia/nemotron-3-ultra-550b-a55b`. Diğer `nvidia/*` modelleri listede ama test edilmedi. | **NVIDIA NIM API Havuzu** (1A ve 1B'den bağımsız, kullanıcının kendi API anahtarı) / **0 Maliyet** | 1A ve 1B dolduğunda `opencode` içinden kullanılan üçüncü bağımsız bulut havuzu. `nvidia/minimaxai/minimax-m3.1-flash` (`Invalid request`) ve `nvidia/z-ai/glm-5.3-flash` (60 sn'de cevap yok) kullanılmaz. |
| **2. Seviye (Cloud Güçlü)** | **Codex CLI** | `gpt-5.6-terra` (OpenAI) | OpenAI Kotası (`tokens used` takipli) | Derin mimari tasarım, karmaşık debug, algoritmik çözümler. |
| **2.5. Seviye (GitHub Copilot Student)** | **Copilot CLI** | `--model auto` (doğrulandı). `gpt-5.4` bu hesapta mevcut değil. | GitHub Copilot Student aboneliği (AI credit kotası, `/usage` ile izlenir) | Codex kotasını korumak için orta/ağır işlerde ikinci bulut seçeneği. |

### Çalıştırma Protokolü ve Katı Kurallar
1. **Saf Orkestrasyon Yasağı (Zero Direct Coding on 4 Argon):** 4 Argon aktifken uygulama/kaynak kodu dosyalarını doğrudan `write_file` veya `edit_file` ile yazmak yasaktır; tüm kodlama adımları CLI işçilerine devredilir.
2. **Bağımsız Kota Havuzları (1A `opencode/*` ↔ 1B `openrouter/*`):** `opencode/` sağlayıcısı altındaki modeller ile `openrouter/` sağlayıcısı altındaki modellerin rate-limit ve kullanım kotaları birbirinden tamamen bağımsızdır:
   - Bir `opencode/<model>-free` modeli limite takıldığında önce 1A içindeki diğer `opencode/*-free` modelleri denenir.
   - 1A (`opencode/*`) havuzu tamamen dolduğunda doğrudan Codex'e (Seviye 2) atlanmaz; `opencode models` içindeki **1B (`openrouter/openrouter/free` veya `openrouter/*:free`)** modellerine geçilir.
   - 1B de dolarsa Seviye 1C (`nvidia/*` NIM) kullanılır; sonra Codex (2) ve Copilot CLI (2.5).
3. **Yerel Model Bağlam Kuralı:** Ollama gibi yerel modellerin halüsinasyon görmesini engellemek için genel soru yerine ilgili dosya içerikleri (`cat`, `head`) komutla okunup doğrudan prompta enjekte edilmelidir.
4. **Headless Komut Formatları:**
   - **Ollama (Seviye 0):** `ollama run qwen2.5-coder:7b "<görev>" --nowordwrap`
   - **opencode Dahili (Seviye 1A):** `opencode run --auto -m "opencode/deepseek-v4.1-flash-free" "<görev>"` (veya `opencode/glm-5.3-flash-free`, `opencode/mimo-v2.6-flash-free`, `opencode/beam-free`)
   - **opencode OpenRouter (Seviye 1B):** `opencode run --auto -m "openrouter/nvidia/nemotron-3-ultra-550b-a55b:free" "<görev>"` (veya `openrouter/openrouter/free`, `openrouter/google/gemma-4-31b-it:free`, `openrouter/<vendor>/<model>`)
   - **opencode NVIDIA NIM (Seviye 1C):** `opencode run --auto -m "nvidia/deepseek-ai/deepseek-v4.1-flash" "<görev>"` (veya `nvidia/openai/gpt-oss-20b`, `nvidia/nvidia/nemotron-3-ultra-550b-a55b`). `opencode` sunucu açılışı ~18 sn sürer, timeout en az 60 sn olmalı.
   - **Codex (Seviye 2):** `codex exec --skip-git-repo-check "<görev>"`
   - **Copilot CLI (Seviye 2.5):** `copilot -p "<görev>" -s --model auto --allow-all-tools`
5. **Doğrulama & Aşama Sonu Commit:** İşçi ajan işini tamamladığında ana ajan çıktıyı fiilen doğrular (`evidence before assertions`) ve elde edilen sağlam durumu hemen atomik checkpoint commit ile emniyete alır.
