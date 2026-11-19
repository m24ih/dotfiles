# Antigravity Global Geliştirici & Güvenlik Kuralları (agy CLI & Antigravity 2.0)

## RTK Komut Çıktısı (Akıllı & Seçici Kullanım)
- **Ne Zaman RTK Kullanılmalı:** Desteklenen ve çıktısı uzun olabilen derleme, test ve git operasyonlarında: `rtk git status`, `rtk git diff`, `rtk git log`, `rtk cargo test`, `rtk cargo build`, `rtk npm test`, `rtk pytest`.
- **Ne Zaman RTK KULLANILMAMALI (Doğrudan ham komut):**
  - Başında ortam değişkeni bulunan komutlar (`DISPLAY=:0 ...`, `WAYLAND_DISPLAY=...`, `VAR=val ...`).
  - Tarayıcı, GUI ve arka plan süreçleri (`google-chrome-stable`, `xdg-open`, `&`, daemon).
  - MCP araçları, DevTools portları (`curl 127.0.0.1:9222`), yerel soket/port testleri.
  - Kısa & hassas komutlar (`which`, `ls`, `cat`, `head`, `sed`, `grep`, `pwd`, `kill`, `ps`).
  - Boru hatları (`|`), `&&`, `;` veya karmaşık kabuk zincirleri.
- **`rtk proxy` Kullanımı:** Sadece desteklenmeyen fakat çıktısı yüzlerce satır devasa log üretecek düz araçlarda isteğe bağlıdır. Her komutun önüne körü körüne `rtk proxy` eklenmez. `rtk gain` kullanım istatistiklerini gösterir.

## 🔒 Güvenlik & Gizli Anahtar Koruması
- **Gitleaks:** Commit (`git commit`) öncesi zorunlu: `gitleaks git --staged`. Sızıntı tespit edilirse commit derhal durdurulur, kullanıcıya dosya/satır gösterilir, onaysız devam edilmez.
- **Hassas Dosyalar:** `.env`, `*.key`, `*.pem`, `credentials.json`, `token*`, SSH özel anahtarları daima `.gitignore` ile korunmalı, asla stage edilmemeli.

## 🛠️ Kod Kalitesi & Doğrulama
- **Doğrulama (Evidence Before Assertions):** Görevin bittiği iddia edilmeden önce ilgili test, derleme veya lint komutları fiilen çalıştırılıp çıktısı teyit edilmeli.
- **Commit Formatı & Sıklığı (Checkpoint Commits):** Conventional Commits standardı (`feat(...)`, `fix(...)`, `refactor(...)`, `test(...)`, `chore(...)`). Büyük işlerin tek commit'e yığılması beklenmez; bir subagent işini bitirdiğinde, bağımsız bir modül tamamlandığında veya önemli bir aşama kaydedildiğinde bekletilmeden atomik kontrol noktası (checkpoint) commit'i atılır. Olası regresyon ve hatalarda sağlam duruma güvenle dönülür.

## 🌐 Tarayıcı Otomasyonu (/browser)
- Varsayılan olarak `/browser` veya DevTools işlemi öncesi Chrome 9222 portu kapalıysa başlat:
  ```bash
  google-chrome-stable --remote-debugging-port=9222 --user-data-dir="$HOME/.config/chrome-debug"
  ```
- **Vivaldi İsteği (Veri Kaybı Olmadan):** Kullanıcı açıkça Vivaldi ile çalışılmasını isterse (örn. "Vivaldi'yi `/browser` ile çalıştır"), mevcut Vivaldi profiline (`~/.config/vivaldi`) zarar verecek şekilde süreci öldürme, yeniden başlatma veya ana profil üzerine yazma yapma:
  - Mevcut oturuma (açık sekmeler/oturumlar) bağlanmak için Vivaldi'de `vivaldi://inspect/#remote-debugging` açıkken `~/.config/vivaldi/DevToolsActivePort` dosyasından port ve WebSocket yolunu (`ws://127.0.0.1:<port>/devtools/browser/<id>`) okuyup `chrome-devtools-mcp --wsEndpoint` veya CDP WebSocket üzerinden bağlan.
  - İzole yeni bir Vivaldi örneği gerekiyorsa yalnızca ayrı profil diziniyle başlat: `vivaldi-stable --remote-debugging-port=9222 --user-data-dir="$HOME/.config/vivaldi-debug"`.
  - Not: Antigravity'nin yerleşik `/browser` alt ajanı kendi dahili tarayıcısını kullanır; Vivaldi otomasyonu `chrome_devtools` MCP / CDP WebSocket üzerinden yürütülür.

## 🧠 Merkezi İkinci Beyin (/home/melih/Sync/Obsidian/Agent)
Vault daima aktiftir. Melih aksini ("kaydetme") belirtmedikçe önemli kararları, bilgileri ve ilerlemeleri kaydet.
- Her işte `/home/melih/.gemini/antigravity/skills/beyin/SKILL.md` yönergelerini, kullanıcı `/beyin` komutunu ayrıca yazmasa da uygula. Hafıza, kaynak bağlamı, not/görev ve oturum kapanışı akışları bu skill'e tabidir.
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

## 🤖 Çoklu Model ve Hibrit Subagent Orkestrasyonu
Bu mimari Antigravity moduna göre **iki modlu** çalışır:
1. **Antigravity `Orchestrator (Neon)` (`gemini-pro-orchestrator-neon`) veya `Orchestrator (Argon)` (`gemini-pro-orchestrator-g1-pro`) Aktifken:** Yerleşik iki fazlı Plan–Execute mimarisi geçerlidir. Faz 1'de **Gemini 4 Neon** (veya **Argon**) salt-okunur (`Plan Mode`) araştırma ve mimari planlama yapar, ardından `exit_plan_mode` ile görevi aynı oturumdaki yerleşik **Gemini 4 Hydrogen** yürütücü modeline devreder (`Gemini 5h/Weekly` kotasını kullanır). Yürütücü doğrudan `edit_file` / `write_file` / `run_command` ile kodu uygular, test eder ve doğrular; beklenmeyen durumda `enter_plan_mode` ile planlayıcıya geri döner. **Codex Subagent Kuralı (2026-11-15):** Melih'in talimatıyla geliştirme, test ve bağımsız kod incelemesi sırasında `codex exec --ephemeral -C <dizin> -s workspace-write "[SUBAGENT] ..."` (veya `-s read-only`) komutunu sadece son çare olarak değil, aktif ve sık bir CLI subagent olarak kullan; çoklu paralel parça veya ücretsiz kota kalkanı gerekiyorsa diğer dış CLI işçilerini de seçebilirsin.
2. **Diğer Tüm Durumlarda (Düz `Gemini 4 Neon`, Düz `Gemini 4 Argon`, Codex veya Manuel Orkestrasyon):** Eski "Saf Orkestratör (Zero Direct Coding)" kuralı geçerlidir; ana ajan `write_file` / `edit_file` ile uygulama kodu yazmaz, kodlama adımlarını aşağıdaki **Seviye 0 → 1 → 2 → 3 → 4 → 5 → 6 (`codex exec`) → 7 → 8 → 9** tablosuna göre CLI işçilerine (veya açık talimatla dahili `invoke_subagent` `Model: "flash"` üzerinden) devreder.
- **Ana Ajanın Yalnızca Yürüteceği İşler (Manuel Mod):** Mimari planlama, görev dağıtımı, çıktı doğrulama (`evidence before assertions` — test/lint/build çalıştırma), git checkpoint commit ve İkinci Beyin (`beyin.py` / `note-edit`) senkronizasyonu.
- **Referans Kaynak:** `/home/melih/Sync/Obsidian/Agent/knowledge/coklu-model-hibrit-subagent-orkestrasyonu.md`

### Ajan Katmanları ve Öncelik Hiyerarşisi

| Katman | Araç / CLI | Model | Donanım / Maliyet & Kota Havuzu | Kullanım Alanı |
| :--- | :--- | :--- | :--- | :--- |
| **Seviye 0 (Yerel)** | **Ollama** | `qwen2.5-coder:7b` (`ollama/qwen2.5-coder:7b`), `qwen3.5:9b` | RTX 4060 GPU (~5.2 GB VRAM) / **0 Maliyet / Sınırsız** | Rutin fonksiyon yazımı, sözdizimi kontrolü, birim testler, boilerplate kodlar, genel muhakeme. |
| **Seviye 1 (OpenCode Dahili Ücretsiz)** | **`opencode`** | `opencode/deepseek-v4.1-flash-free`, `opencode/glm-5.3-flash-free`, `opencode/mimo-v2.6-flash-free`, `opencode/beam-free`, `opencode/flint-40b-free`, `opencode/nemotron-3.5-lightning-free`, `opencode/nemotron-3.5-super-vl-free`, `opencode/big-pickle` | **OpenCode Zen Havuzu** (OpenRouter'dan bağımsız kota) / **0 Maliyet** | Kod tabanı analizi, otonom kod yazımı, modül refactor, betik oluşturma, dokümantasyon, shell/test çalıştırma. |
| **Seviye 2 (OpenRouter Ücretsiz & Geniş Havuz)** | **`opencode`** | **Otomatik Ücretsiz Router:** `openrouter/openrouter/free`<br>**Doğrudan `:free` Modeller:** `openrouter/nvidia/nemotron-3-ultra-550b-a55b:free`, `openrouter/google/gemma-4-31b-it:free`, `openrouter/google/gemma-4-26b-a4b-it:free`, `openrouter/thinkingmachines/inkling:free`, `openrouter/cohere/north-mini-code:free`, `openrouter/recursive/flint-v1.0:free`, `openrouter/xingchen-agi/xing4.0-29b-a4b:free`<br>**Diğer OpenRouter Modelleri:** `openrouter/<vendor>/<model>` | **OpenRouter API Havuzu** (OpenCode Zen limitinden tamamen bağımsız) / **0 Maliyet / Esnek** | Seviye 1 (`opencode/*`) modelleri rate-limit (429) veya kota sınırına takıldığında Codex'e geçmeden önce başvurulan bağımsız bulut katmanı. |
| **Seviye 3 (NVIDIA NIM)** | **`opencode`** | Doğrulandı (2026-10-30): `nvidia/openai/gpt-oss-20b`, `nvidia/deepseek-ai/deepseek-v4.1-flash`, `nvidia/nvidia/nemotron-3-ultra-550b-a55b`. Özel kod: `nvidia/poolside/laguna-xs-2.1`. | **NVIDIA NIM API Havuzu** (Seviye 1 ve 2'den bağımsız, kullanıcının kendi API anahtarı) / **0 Maliyet** | Seviye 1 ve 2 dolduğunda `opencode` içinden kullanılan üçüncü bağımsız bulut havuzu. `nvidia/minimaxai/minimax-m3.1-flash` (`Invalid request`) ve `nvidia/z-ai/glm-5.3-flash` (60 sn'de cevap yok) kullanılmaz. |
| **Seviye 4 (Groq Ultra Hızlı LPU)** | **`opencode`** | `groq/openai/gpt-oss-120b`, `groq/qwen/qwen3.8-27b`, `groq/openai/gpt-oss-20b` | **Groq LPU Bulut Havuzu** / **0 Maliyet** | 8.000 TPM sınırı nedeniyle araçsız/hafif ajanlarda (`--agent title`, özet, hızlı Q&A/analiz) yüksek hızlı yanıt. |
| **Seviye 5 (`agy` — Gemini 5h/Weekly Havuzu)** | **`agy` CLI** | `gemini-3.8-flash-{low,medium,high}`<br>`gemini-4-hydrogen-{low,medium,high,xhigh}`<br>`gemini-4-neon-{low,medium,high,xhigh}`<br>`gemini-pro-orchestrator-neon` (`Orchestrator (Neon)`) | Antigravity `gemini-5h` / `gemini-weekly` kotası *(canlı doğrulandı: 2026-11-19)* | Flash: hızlı/hafif görevler, özet, basit kod/test. Hydrogen: orta-ağır hızlı kodlama, PDF/doküman analizi ve Orchestrator yürütücüsü. **Neon (2026-11-19):** Carbon'dan uyarlanmış yüksek kaliteli ajan kodlama, derin analiz, repo refactor/debug ve düşük halüsinasyonlu karmaşık işler (Argon'dan hızlı/güçlü). `Orchestrator (Neon)`: Neon tabanlı iki fazlı Plan–Execute. |
| **Seviye 6 (Cloud Güçlü — OpenAI)** | **Codex CLI** | Etkin Codex modeli (varsayılan `gpt-6.1-terra` medium) | OpenAI ChatGPT Plus Kotası | Derin mimari tasarım, karmaşık debug, planlama ve orkestrasyon. |
| **Seviye 7 (`agy` — Gemini 4 Argon Weekly + Hibrit)** | **`agy` CLI** | `gemini-pro-orchestrator-g1-pro` (`Orchestrator (Argon)`)<br>`gemini-4-argon-{low,medium,high}` | Antigravity `gemini-argon-wtu-weekly` (+ Hydrogen için `gemini-5h`) | `gemini-5h`/`gemini-weekly` havuzundan **bağımsız** ayrı haftalık Argon kotasını değerlendirmek, uçtan uca *"Argon planlasın + Hydrogen kodlasın"* çalıştırmak veya salt-okunur derin mimari/code review almak için. |
| **Seviye 8 (`agy` — Antigravity 3P Claude/GPT Bağımsız Havuz)** | **`agy` CLI** | `claude-sonnet-5-5-{low,medium,high}`<br>`claude-opus-5-5-{low,medium,high}`<br>`gpt-oss-120b-medium` | Antigravity `3p-5h` / `3p-weekly` pencereleri | Gemini ve OpenAI Codex kotalarından tamamen bağımsız üçüncü abonelik havuzu. |
| **Seviye 9 (GitHub Copilot Student)** | **Copilot CLI** | `--model auto` (doğrulandı). `gpt-5.4` bu hesapta mevcut değil. | GitHub Copilot Student aboneliği (AI credit kotası, `/usage` ile izlenir) | Codex kotasını korumak için orta/ağır işlerde ikinci bulut seçeneği. |

### Çalıştırma Protokolü ve Katı Kurallar
1. **Mod Ayrımı (Orchestrator Neon/Argon vs. Manuel Orkestrasyon):** Antigravity ana oturumunda `Orchestrator (Neon)` (`gemini-pro-orchestrator-neon`) veya `Orchestrator (Argon)` (`gemini-pro-orchestrator-g1-pro`) seçiliyse yerleşik `Plan → Execute` akışı çalışır; düz `Gemini 4 Neon`, düz `Gemini 4 Argon` veya başka manuel mod seçiliyse uygulama/kaynak kodu dosyalarını doğrudan `write_file` veya `edit_file` ile yazmak yasaktır, tüm kodlama adımları CLI işçilerine devredilir.
2. **Bağımsız Kota Havuzları (`opencode` Seviye 1–4 ↔ `agy` 3 Havuz ↔ Codex ↔ Copilot):**
   - Bir `opencode/<model>-free` modeli limite takıldığında önce Seviye 1 içindeki diğer `opencode/*-free` modelleri, sonra **Seviye 2 (`openrouter/*:free`)**, ardından **Seviye 3 (`nvidia/*` NIM)** ve **Seviye 4 (`groq/*`)** denenir.
   - Antigravity tarafında `codexbar usage --provider antigravity --format toon` çıktısındaki 3 ayrı pencere (`gemini-5h`, `3p-5h`, `gemini-argon-wtu-weekly`) ayrı değerlendirilir; uygun havuzlar arasında `kalan yüzde / sıfırlanmaya kalan saat` oranı yüksek olan önceliklendirilir.
3. **Yerel Model Bağlam Kuralı:** Ollama gibi yerel modellerin halüsinasyon görmesini engellemek için genel soru yerine ilgili dosya içerikleri (`cat`, `head`) komutla okunup doğrudan prompta enjekte edilmelidir.
4. **Headless Komut Formatları:**
   - **Seviye 0 (Ollama):** `ollama run qwen2.5-coder:7b "<görev>" --nowordwrap`
   - **Seviye 1 (opencode Dahili):** `opencode run --auto -m "opencode/deepseek-v4.1-flash-free" "<görev>"` (veya `opencode/glm-5.3-flash-free`, `opencode/mimo-v2.6-flash-free`, `opencode/beam-free`)
   - **Seviye 2 (opencode OpenRouter):** `opencode run --auto -m "openrouter/nvidia/nemotron-3-ultra-550b-a55b:free" "<görev>"` (veya `openrouter/openrouter/free`, `openrouter/google/gemma-4-31b-it:free`, `openrouter/<vendor>/<model>`)
   - **Seviye 3 (opencode NVIDIA NIM):** `opencode run --auto -m "nvidia/deepseek-ai/deepseek-v4.1-flash" "<görev>"` (veya `nvidia/openai/gpt-oss-20b`, `nvidia/nvidia/nemotron-3-ultra-550b-a55b`, `nvidia/poolside/laguna-xs-2.1`). `opencode` sunucu açılışı ~18 sn sürer, timeout en az 60 sn olmalı.
   - **Seviye 4 (opencode Groq LPU):** `opencode run --agent title -m "groq/openai/gpt-oss-120b" "<görev>"`
   - **Seviye 5 (`agy` Flash, Hydrogen & Neon):** `agy --print --model gemini-3.8-flash-medium --mode auto "<görev>"`, `agy --print --model gemini-4-hydrogen-medium --mode auto "<görev>"`, `agy --print --model gemini-4-neon-medium --mode auto "<görev>"` (`low|medium|high|xhigh`) ve `agy --print --model gemini-pro-orchestrator-neon --mode auto "<görev>"`
   - **Seviye 6 (Codex — Aktif Subagent):** `codex exec --ephemeral -C <dizin> -s workspace-write "[SUBAGENT] <görev>"` (inceleme için `-s read-only`; repo dışı için `--skip-git-repo-check`)
   - **Seviye 7 (`agy` Orchestrator Argon & Argon):** `agy --print --model gemini-pro-orchestrator-g1-pro --mode auto "<görev>"` ve `agy --print --model gemini-4-argon-high --mode auto "<görev>"`
   - **Seviye 8 (`agy` 3P Claude/GPT):** `agy --print --model claude-sonnet-5-5-medium --mode auto "<görev>"` (veya `claude-opus-5-5-medium`, `gpt-oss-120b-medium`)
   - **Seviye 9 (Copilot CLI):** `copilot -p "<görev>" -s --model auto --allow-all-tools`
5. **Doğrulama & Aşama Sonu Commit:** İşçi ajan (veya Hydrogen) işini tamamladığında ana ajan çıktıyı fiilen doğrular (`evidence before assertions`) ve elde edilen sağlam durumu hemen atomik checkpoint commit ile emniyete alır.
