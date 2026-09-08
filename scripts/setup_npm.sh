#!/bin/bash
# ==============================================================================
# NPM Global Dizin ve İzin Yapılandırması
# ==============================================================================
# Bu betik, npm'in global paketleri 'sudo' gerekmeden kullanıcı ev dizinine
# (~/.npm-global) kurmasını sağlar.
# Fish shell için PATH tanımlaması fish konfigürasyonunda mevcuttur.

set -e

echo ":: npm global dizin yapılandırması başlıyor..."

# npm kurulu mu kontrol et
if ! command -v npm &>/dev/null; then
    echo "⚠️ Uyarı: 'npm' sistemde bulunamadı. Lütfen önce Node.js / npm paketini kurun."
    exit 1
fi

NPM_GLOBAL_DIR="$HOME/.npm-global"

# 1. Global dizinleri oluştur
mkdir -p "$NPM_GLOBAL_DIR/bin"
mkdir -p "$NPM_GLOBAL_DIR/lib"

# 2. npm prefix'ini ~/.npm-global olarak ayarla
npm config set prefix "$NPM_GLOBAL_DIR"

# 3. Sahiplik ve izinleri doğrula
chown -R "$(id -u):$(id -g)" "$NPM_GLOBAL_DIR" 2>/dev/null || true

# 4. Fish shell kullanılıyorsa aktif oturum için PATH'e ekle
if command -v fish &>/dev/null; then
    fish -c "fish_add_path -g $NPM_GLOBAL_DIR/bin" 2>/dev/null || true
fi

echo "  -> npm global prefix '$NPM_GLOBAL_DIR' olarak ayarlandı."
echo "  -> Fish shell PATH: \$HOME/.npm-global/bin eklendi."
echo ":: npm yapılandırması başarıyla tamamlandı!"
