# ☀️ Sunshine (MangoWM / wlroots GameStream & Sanal 2. Ekran Yapılandırması)

Bu paket, **Sunshine** ve **MangoWM (Wayland / wlroots)** kullanarak Android/iPad tabletleri (özellikle **Samsung Galaxy Tab S9+**) bağımsız ve akıcı bir **ikinci monitör** olarak kullanmak için hazırlanmış yapılandırmaları barındırır.

---

## 📁 Paket İçeriği

* `.config/sunshine/sunshine.conf`: Genel yakalama (`capture = wlr`), sanal ekran hedefi (`output_name = HEADLESS-1`) ve ses ayarları.
* `.config/sunshine/apps.json`: İstemci bağlandığında MangoWM IPC (`mmsg`) ve `wlr-randr` ile sanal ekranı açıp yapılandıran profil tanımları.

---

## ⚙️ Nasıl Çalışır? (Teknik Mimari)

```text
[ Moonlight İstemcisi (Tablet) ]
             │
             ▼ (RTSP / Port: 47990, 48010, 47998-48002)
   [ Sunshine Sunucusu ]
             │
    (Prep Command: do)
             ├─► mmsg dispatch create_virtual_output  ──► MangoWM'de "HEADLESS-1" oluşturur
             ├─► wlr-randr                           ──► Çözünürlüğü (${WIDTH}x${HEIGHT}@${FPS}) ayarlar
             │
   [ wlroots Screencopy Yakalama (capture = wlr) ]
             │
             ▼
[ Bağımsız 2. Ekran Görüntüsü ]
```

---

## 🛠️ Gereksinimler

* `mangowm` (Masaüstü ortamı ve dahili `mmsg` IPC aracı)
* `wlr-randr` (Sanal ekran çözünürlüğü ve konumlandırma için)
* `xdg-desktop-portal-wlr` (Ekran yakalama ve paylaşım köprüsü)
