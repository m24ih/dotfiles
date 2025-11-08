#!/bin/bash
#
# install_dotfiles.sh
# YENİ bir sistemde tüm dotfiles'ları "stow" ile bağlar.
# Dotfiles klasörünün içindeyken çalıştırılmalıdır.

echo "Tüm dotfiles'lar 'stow' ile ana dizine bağlanıyor..."

# Stow komutunun kendisi modülerdir.
# Dotfiles klasöründeki *her* alt klasörü (hypr, nvim, fish, gtk...)
# tek tek paket olarak görür ve -t ~ hedefine bağlar.

# '*' (yıldız) bu dizindeki tüm klasörleri (paketleri) al demektir.
# Betiklerimizi (install.sh vb.) ve text dosyalarını (packages.txt)
# görmezden gelmesi için basit bir filtreleme yapabiliriz.

# Sadece klasör olanları "stow" et
for pkg in */; do
  # Eğer gerçekten bir 'stow' paketi ise (içinde .config gibi yapılar varsa)
  # veya daha basitçe: betik dosyası değilse
  if [ -d "$pkg" ]; then
    # 'scripts' gibi betik klasörlerini hariç tutabiliriz
    if [ "$pkg" != "scripts/" ]; then
      echo "  -> Bağlanıyor: ${pkg%/}" # Sonundaki / işaretini kaldır
      stow -t "$HOME" "${pkg%/}"
    fi
  fi
done

# VEYA DAHA BASİT YÖNTEM (Eğer Dotfiles'da sadece paketler varsa):
# stow -t "$HOME" *

echo "✅ 'Stow' işlemi tamamlandı."
