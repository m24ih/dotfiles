# 🚀 Google Antigravity CLI Yapılandırması

Bu paket, **Google Antigravity CLI** (`agy`) için kullanıcı ayarlarını ve izin tanımlamalarını barındırır.

---

## 📁 Dosya Yapısı

```text
antigravity/
└── .gemini/
    └── antigravity-cli/
        └── settings.json    # İzinler, onay politikaları ve CLI ayarları
```

---

## ⚙️ Yapılandırma Detayları

* `settings.json`: Otomatik komut çalıştırma izinleri, sandbox ayarları ve model parametrelerini yönetir.
* `.gitignore` kuralı sayesinde oturum logları, geçici kilit (`.lock`) dosyaları ve oturum bellekleri Git takibinden hariç tutulurken yalnızca temel `settings.json` dosyası sürüm kontrolünde tutulur.
