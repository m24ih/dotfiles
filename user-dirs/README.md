# 📁 XDG User Dirs (Standart Kullanıcı Dizinleri)

Kullanıcı ev dizinindeki standart klasörleri (`Desktop`, `Downloads`, `Documents`, `Projects` vb.) yöneten ve Türkçe/İngilizce sistemler arasında tutarlılık sağlayan XDG yapılandırması.

---

## 📦 Kurulum ve Güncelleme

Eğer sisteminizde `xdg-user-dirs` eksikse:

```bash
# Arch / CachyOS:
sudo pacman -S --needed xdg-user-dirs
# veya AUR:
yay -S --needed xdg-user-dirs
```

Dizinleri oluşturmak veya güncellemek için:
```bash
xdg-user-dirs-update
```

---

## 📁 Dosya Yapısı

```text
user-dirs/
└── .config/
    └── user-dirs.dirs    # Standart XDG klasör yollarının tanımları
```

---

## ⚙️ Tanımlı Dizinler (`user-dirs.dirs`)

Sistem diline bağlı klasör adı karmaşasını (örn: `İndirilenler` vs `Downloads`) önlemek için tüm dizinler İngilizce standart isimlere sabitlenmiştir:

* `~/Desktop` (Masaüstü)
* `~/Downloads` (İndirilenler)
* `~/Documents` (Belgeler)
* `~/Pictures` (Resimler)
* `~/Videos` (Videolar)
* `~/Music` (Müzik)
* `~/Projects` (Geliştirici Projeleri & Kod Depoları)
* `~/Templates` & `~/Public`
