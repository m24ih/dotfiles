# ☀️ Sunshine (GameStream & Sanal 2. Ekran Yapılandırması)

Bu paket, **Sunshine** ve **KDE Plasma (Wayland)** kullanarak Android/iPad tabletleri (özellikle **Samsung Galaxy Tab S9+**) bağımsız ve ultra akıcı (120Hz) bir **ikinci monitör** olarak kullanmak için hazırlanmış yapılandırmaları barındırır.

---

## 📁 Paket İçeriği

* `.config/sunshine/sunshine.conf`: Genel yakalama (`capture = kwin`), sanal ekran hedefi (`output_name = Virtual-TabletEkran`) ve ses ayarları.
* `.config/sunshine/apps.json`: İstemci bağlandığında sanal ekranı başlatan (`prep-cmd`) ve bağlantı koptuğunda kapatan profil tanımları.
* `systemd/.config/systemd/user/sunshine.service`: Oturum açıldığında Sunshine'ı arka planda başlatan systemd kullanıcı servisi.

---

## ⚙️ Nasıl Çalışır? (Teknik Mimari)

```text
[ Moonlight İstemcisi (Tablet) ]
             │
             ▼ (RTSP / Port: 47990, 48010, 47998-48002)
   [ Sunshine Sunucusu ]
             │
    (Prep Command: do)
             ├─► krfb-virtualmonitor ──► KWin'de "Virtual-TabletEkran" oluşturur
             ├─► kscreen-doctor      ──► Çözünürlüğü (${WIDTH}x${HEIGHT}@${FPS}) ayarlar
             │
   [ KWin ScreenCast Yakalama ]
             │
             ▼
[ Bağımsız 120Hz 2. Ekran Görüntüsü ]
```

### 1. Dinamik Çözünürlük ve 120Hz Desteği
Sunshine, Moonlight istemcisinden gelen çözünürlük ve FPS talebini ortam değişkeni olarak iletir (`${SUNSHINE_CLIENT_WIDTH}`, `${SUNSHINE_CLIENT_HEIGHT}`, `${SUNSHINE_CLIENT_FPS}`).

`apps.json` içerisindeki `do` komutu:
```bash
sh -c "killall -q krfb-virtualmonitor || true ; sleep 0.5 ; krfb-virtualmonitor --name 'TabletEkran' --resolution ${SUNSHINE_CLIENT_WIDTH}x${SUNSHINE_CLIENT_HEIGHT} --password '123456' --port 5900 & sleep 1.5 ; kscreen-doctor output.Virtual-TabletEkran.position.1920,0 output.Virtual-TabletEkran.mode.${SUNSHINE_CLIENT_WIDTH}x${SUNSHINE_CLIENT_HEIGHT}@${SUNSHINE_CLIENT_FPS} || true"
```
1. Eski süreçleri temizler (`killall`).
2. Tabletin çözünürlüğünde sanal ekranı açar (`krfb-virtualmonitor`).
3. Sanal ekranı ana monitörün sağına yerleştirir ve 120Hz moduna geçirir (`kscreen-doctor`).

---

## ⚡ Laptop Güç Yönetimi (Pil/Priz Otomasyonu)

Laptop pildeyken pil tasarrufu sağlamak için Sunshine servisi KDE Plasma üzerinden otomatik yönetilir:

1. **KDE Sistem Ayarları** ➔ **Güç Yönetimi (Power Management)** ➔ **Enerji Tasarrufu (Energy Saving)**
2. **"On Battery" (Pildeyken):**
   * `Run command or script:` ➔ `When entering this profile` ➔ `systemctl --user stop sunshine.service`
3. **"On AC Power" (Prizdeyken):**
   * `Run command or script:` ➔ `When entering this profile` ➔ `systemctl --user start sunshine.service`
4. **Apply (Uygula)** ile kaydedin.

---

## ⚠️ Bilinen Sorunlar ve İpuçları

### Samsung Book Cover Keyboard Touchpad Eksen Sorunu
* **Sorun:** Orijinal klavyeli kılıfın touchpad'i yatay modda eksenleri 90 derece dönmüş gibi davranabilir.
* **Neden:** Samsung tablet digitizer'ının donanımsal olarak dikey (portrait) üretilmesi ve Android'in ham dokunmatik sinyali iletmesi.
* **Geçici Çözüm:** Moonlight yayını açıkken Android bildirim panelini yukarıdan aşağı çekip kapatmak veya tableti **Samsung DeX** moduna alarak bağlanmak.

---

## 🔒 Güvenlik Notları (Dotfiles & Secrets)

Aşağıdaki dosyalar **asla** Git reposuna dahil edilmez (`.gitignore` ile engellenmiştir):
* `~/.config/sunshine/credentials/` (Özel SSL anahtarları)
* `~/.config/sunshine/sunshine_state.json` (Parola hash'i ve cihaz UUID/sertifikaları)
* `~/.config/sunshine/sunshine.log` (Bağlantı ve sistem logları)
