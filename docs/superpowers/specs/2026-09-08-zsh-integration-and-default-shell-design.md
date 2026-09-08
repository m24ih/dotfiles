# Tasarım Şartnamesi: Zsh Modülü Entegrasyonu ve Varsayılan Kabuk (Default Shell) Seçicisi

**Tarih:** 2026-09-08  
**Durum:** Onaylandı  
**Kapsam:** Architectural  

---

## 1. Genel Bakış ve Amaç

Bu çalışmanın amacı:
1. `/home/melih/Projects/MyZsh` deposundaki Zsh yapılandırmasını (`.zshrc`) dotfiles deposuyla birleştirmek; depodaki mevcut `zshrc.d/` modülleri ile tek bir birinci sınıf `zsh` Stow paketinde konsolide etmek.
2. `install.sh` içerisine `zsh` bileşenini (paket listesi `packages/zsh.txt`, stow paketi `zsh`, kurulum betiği `scripts/setup_zsh.sh`) dahil etmek.
3. Kurulum sihirbazına (`run_wizard`), kullanıcının varsayılan oturum kabuğunu (Default Shell) seçebileceği etkileşimli bir kabuk seçim mekanizması eklemek ve seçilen kabuk mevcuttan farklıysa `chsh -s` ile otomatik geçiş sağlamak.
4. `--dry-run` simülasyonu, CLI bayrakları ve `README.md` dokümantasyonunu yeni modül ve kabuk seçiciyi kapsayacak şekilde güncellemek.

---

## 2. Dizin ve Dosya Yapısı Değişiklikleri

### A. Stow Paketi (`zsh/`) Konsolidasyonu
- Yeni `zsh/` dizini oluşturulur:
  ```text
  zsh/
  ├── .zshrc                           # MyZsh/.zshrc dosyasından aktarılır
  └── .config/
      └── zshrc.d/                     # Mevcut zshrc.d/.config/zshrc.d altından taşınır
          ├── shortcuts.zsh            # Kısayollar
          ├── dots-hyprland.zsh        # Terminal renkleri
          └── auto-Hypr.sh             # Otomatik Hyprland başlatıcı
  ```
- `zsh/.zshrc` dosyasının sonuna modüler `zshrc.d` kaynaklarını otomatik yükleyen blok entegre edilir:
  ```zsh
  # Load modular configurations
  if [ -d "$HOME/.config/zshrc.d" ]; then
    for file in "$HOME/.config/zshrc.d"/*.{zsh,sh}(N); do
      [ -f "$file" ] && source "$file"
    done
  fi
  ```
- Eski `zshrc.d/` dizini tamamen kaldırılır (`git rm -r zshrc.d`).

### B. `stow_all.sh` Güncellemesi
- Varsayılan hedef paketler listesinden `zshrc.d` kaldırılır, yerine `zsh` eklenir.

---

## 3. Modüler Paket Listesi (`packages/zsh.txt`)

`packages/zsh.txt` dosyası aşağıdaki temel ve eklenti paketlerini barındırır:
- `zsh`: Z shell yorumlayıcısı
- `fzf`: Komut satırı bulanık arama aracı
- `zsh-completions`: İlave komut tamamlama tanımları
- `zsh-autosuggestions`: Geçmişe dayalı otomatik komut önerileri
- `zsh-syntax-highlighting`: Komut sözdizimi renklendirmesi
- `eza`: Modern ls / ağaç görünümü alternatifi (.zshrc alias'ları için)

---

## 4. Zsh Otomasyon Betiği (`scripts/setup_zsh.sh`)

`MyZsh/setup_zsh.sh` betiğinden türetilerek dotfiles standartlarına uyarlanır:
1. `~/.oh-my-zsh` dizini kontrol edilir; yoksa unattended modda kurulur:
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
   ```
2. `$ZSH_CUSTOM/plugins` (`~/.oh-my-zsh/custom/plugins`) dizini altında eksik olan eklentiler klonlanır:
   - `zsh-autosuggestions`
   - `zsh-syntax-highlighting`
   - `zsh-completions`
   - `zsh-history-substring-search`
   - `zsh-autopair`
3. Sembolik bağlama işlemi GNU Stow tarafından yapıldığı için betik içinde manuel `ln -sf` yapılmaz.
4. Betik `scripts/` dizininde yürütülebilir (`chmod +x`) olarak saklanır.

---

## 5. Varsayılan Kabuk (Default Shell) Seçim Mekanizması

### A. Etkileşimli Soru ve Açıklama (`run_wizard`):
Kategori 3 (Kabuk & Editör) tamamlandıktan sonra veya sihirbaz sonunda:
```text
┌──────────────────────────────────────────────────────────────┐
│ [Kabuk Tercihi] Varsayılan Oturum Kabuğu (Default Login Shell)
└──────────────────────────────────────────────────────────────┘
Mevcut kabuğunuz: /usr/bin/zsh (veya /usr/bin/fish)

Kullanılabilir Seçenekler:
  1) fish : Modern, zengin otomatik tamamlama ve renklendirme (Etkileşimli kullanım için ideal)
  2) zsh  : Güçlü, POSIX uyumlu, Oh My Zsh ve zengin eklenti ekosistemi
  3) bash : Standart sistem kabuğu
  4) atla : Mevcut kabuğu koru (Değişiklik yapma)

? Varsayılan kabuğunuz hangisi olsun? [1/2/3/4 veya fish/zsh/bash/atla] (Varsayılan: mevcut):
```
- Seçim `DEFAULT_SHELL_CHOICE` değişkeninde saklanır.

### B. Otomatik Değiştirme Mantığı (`execute_plan` / Phase 4):
- Eğer kullanıcı geçerli bir kabuk seçtiyse ve bu kabuk kullanıcının mevcut `$SHELL` değerinden farklıysa:
  - İlgili kabuğun ikili dosya yolu bulunur (`which fish`, `which zsh`, `which bash`).
  - `/etc/shells` içinde tanımlı olduğu teyit edilir (değilse eklenmesi uyarılır).
  - Normal modda: `chsh -s "$target_path"` çalıştırılır.
  - `--dry-run` modunda: Hiçbir komut çalıştırılmaz; `   • Varsayılan kabuk değiştirilecek: $CURRENT_SHELL -> $target_path (chsh -s)` olarak simülasyonda listelenir.

---

## 6. `install.sh` Bileşen Kaydı ve Akış Güncellemesi

1. **Bileşen Kaydı (Registry)**:
   - `ALL_MODULES`: `zsh` eklenir (toplam 23 modül).
   - `DEFAULT_MODULES`: `zsh` eklenir (`[Y]` varsayılan).
   - `get_module_title "zsh"`: `"Zsh Kabuğu & Oh My Zsh Ortamı"`
   - `get_module_package_file "zsh"`: `"packages/zsh.txt"`
   - `get_module_stow_packages "zsh"`: `"zsh"`
   - `get_module_scripts "zsh"`: `"scripts/setup_zsh.sh"`
2. **Sihirbaz (`run_wizard`)**:
   - `ask_yn "Zsh kabuğu ve Oh My Zsh ortamı kurulsun mu?" "Y"` sorusu eklenir.
   - Kabuk seçici fonksiyonu `prompt_default_shell` çağrılır.
3. **Özet Ekranı (`show_summary_and_confirm`)**:
   - Eğer varsayılan kabuk değişikliği planlandıysa özet kutusuna eklenir:
     `🐚 Varsayılan Kabuk Değişimi: $CURRENT_SHELL -> $TARGET_SHELL`
4. **CLI Parser & Bayraklar**:
   - `show_help`: `zsh` modülü listelenir.
   - `--default`, `--all`, pozisyonel modüller: `zsh` desteği tam entegre edilir.

---

## 7. Doğrulama ve Test Planı

1. **Sözdizimi Kontrolleri:**
   - `bash -n install.sh`
   - `bash -n stow_all.sh`
   - `bash -n scripts/setup_zsh.sh`
2. **Dry-Run Testleri:**
   - `./install.sh --dry-run --default`: `packages/zsh.txt` paketlerinin (6 yeni paket) dahil edildiği ve `zsh` stow paketinin listelendiği doğrulanır.
   - `./install.sh --dry-run zsh`: Yalnızca Zsh bileşenlerinin simülasyon çıktısı doğrulanır.
3. **Stow Uyumluluk Testi:**
   - `./stow_all.sh zsh` ile `~/.zshrc` ve `~/.config/zshrc.d/` bağlarının hatasız oluştuğu doğrulanır.
4. **Kabuk Değiştirme Simülasyonu:**
   - Farklı kabuk seçildiğinde dry-run çıktısında `chsh` simülasyon satırının yer aldığı teyit edilir.
