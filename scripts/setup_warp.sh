#!/bin/bash
# ==============================================================================
# CLOUDFLARE WARP SPLIT TUNNEL VE YEREL/TAILSCALE AĞ HARİÇ TUTMA BETİĞİ
# ==============================================================================
# Bu betik WARP tünelinin yerel ağlarınıza (LAN) ve Tailscale VPN trafiğinize 
# müdahale etmesini engeller.

set -e

echo ":: Cloudflare WARP Split Tunnel Kuralları Yapılandırılıyor..."

if command -v warp-cli &>/dev/null; then
    # Yerel Özel Ağlar (RFC 1918)
    warp-cli tunnel ip add-range 192.168.0.0/16 2>/dev/null || true
    warp-cli tunnel ip add-range 10.0.0.0/8 2>/dev/null || true
    warp-cli tunnel ip add-range 172.16.0.0/12 2>/dev/null || true

    # Tailscale Ağları (CGNAT IPv4 & ULA IPv6)
    warp-cli tunnel ip add-range 100.64.0.0/10 2>/dev/null || true
    warp-cli tunnel ip add-range fd7a:115c:a1e0::/48 2>/dev/null || true

    echo "✅ WARP Split Tunnel Kuralları Uygulandı:"
    echo "   - Yerel Ağlar (192.168.x.x, 10.x.x.x, 172.16.x.x) hariç tutuldu."
    echo "   - Tailscale Ağları (100.64.0.0/10, fd7a:115c:a1e0::/48) hariç tutuldu."
else
    echo "⚠️ warp-cli bulunamadı, atlanıyor."
fi
