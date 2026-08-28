# 📊 btop (Sistem ve Donanım Kaynak Monitörü)

C++ ile geliştirilmiş, donanım sensörlerini (CPU, GPU, RAM, Disk, Ağ) anlık olarak izleyen, özelleştirilmiş kaynak monitörü yapılandırması.

---

## 📦 Kurulum ve Bağımlılıklar

Eğer sisteminizde `btop` veya GPU izleme kütüphaneleri eksikse:

```bash
# Ana Paket (Arch / CachyOS):
sudo pacman -S --needed btop
# veya AUR:
yay -S --needed btop

# 🔴 AMD Ekran Kartı Sahipleri İçin (ÖNEMLİ):
# AMD Radeon GPU'ların saat hızlarını, VRAM kullanımını ve PCIe veri akışını izlemek için:
sudo pacman -S --needed rocm-smi-lib
```

> [!NOTE]
> `rocm-smi-lib`, AMD GPU'ların donanım sensörlerini ve PCIe bant genişliğini (`rsmi_measure_pcie_speeds = true`) btop'a aktarmak için gereklidir.

---

## 📁 Dosya Yapısı

```text
btop/
└── .config/
    └── btop/
        ├── btop.conf     # İnce ayarlanmış ana yapılandırma dosyası
        └── themes/       # Özel renk temaları
```

---

## ⚙️ Yapılandırma ve Özelleştirme Detayları

Bu dotfiles yapılandırmasındaki `btop.conf` kişisel donanımınıza göre optimize edilmiştir:

### 1. 💾 Disk ve Depolama Yapılandırması
* **Filtrelenmiş Diskler (`disks_filter = "/root /mnt/ROG_SSD"`):** Yalnızca ana sistem (`/root` / `/`) ve harici **ASUS ROG SSD** (`/mnt/ROG_SSD`) izlenir; gereksiz sanal bağlama noktaları gizlenir.
* **Swap Sürücü Olarak Gösterimi (`swap_disk = true`):** Takas alanı (Swap) disk bölümünün hemen altında ayrı bir sürücü gibi görselleştirilir.
* **G/Ç İstatistikleri (`show_io_stat = true`):** Disklerin anlık okuma/yazma meşguliyet yüzdesi (%) gösterilir.

### 2. 🎮 GPU ve PCIe Hız İzleme
* **Çoklu GPU Desteği (`shown_gpus = "nvidia amd intel apple"`):** Sistemdeki ayrık ve dahili grafik birimlerini otomatik tespit eder.
* **AMD & NVIDIA PCIe Ölçümü:** `rsmi_measure_pcie_speeds = true` ve `nvml_measure_pcie_speeds = true` ile ekran kartlarının PCIe veri yolu hızları aktif izlenir.

### 3. ⚡ Güç ve Sıcaklık Sensörleri
* **CPU Paket Gücü (`show_cpu_watts = true`):** İşlemcinin anlık watt tüketimi gösterilir.
* **Çekirdek Sıcaklıkları (`check_temp = true`, `show_coretemp = true`):** Her çekirdeğin sıcaklığı bağımsız takip edilir.
* **Laptop Pil Monitörü (`show_battery = true`, `show_battery_watts = true`):** Şarj durumu ve anlık güç çekişi watt cinsinden gösterilir.

### 4. 🧠 İşlem (Process) Listesi
* **Sıralama Modu (`proc_sorting = "cpu lazy"`):** İşlem listesi CPU kullanımına göre yumuşak/takip edilebilir şekilde sıralanır.
* **Bellek Gösterimi (`proc_mem_bytes = true`):** Yüzde yerine doğrudan megabayt/gigabayt cinsinden RAM kullanımı gösterilir.
* **Mini CPU Grafikleri (`proc_cpu_graphs = true`):** Her sürecin yanında anlık CPU yük grafiği çizilir.

---

## ⌨️ Temel Kısayollar

* `m`: Bellek görünümünü değiştirir.
* `p`: İşlem listesi sıralamasını değiştirir (CPU / RAM).
* `t`: Ağaç görünümünü (Process Tree) açar/kapatır.
* `f`: Süreçler arasında filtreleme/arama yapar.
* `k`: Seçili süreci sonlandırır (Kill).
* `q` / `Esc`: Çıkış.
