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
