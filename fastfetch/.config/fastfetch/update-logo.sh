#!/usr/bin/env bash
# =============================================================================
# Fastfetch OS Logo Updater
# Updates ~/.config/fastfetch/logo/os-logo.png based on /etc/os-release
# =============================================================================

set -euo pipefail

LOGO_DIR="${1:-$HOME/.config/fastfetch/logo}"

if [ ! -d "$LOGO_DIR" ]; then
    exit 0
fi

if [ ! -f /etc/os-release ]; then
    exit 0
fi

# Source os-release
# shellcheck disable=SC1091
. /etc/os-release

OS_ID="${ID:-}"
OS_LIKE="${ID_LIKE:-}"
OS_LOGO="${LOGO:-}"

# Collect candidate identifiers
CANDIDATES=()
if [ -n "$OS_ID" ]; then
    CANDIDATES+=("$(echo "$OS_ID" | tr '[:upper:]' '[:lower:]')")
fi

if [ -n "$OS_LIKE" ]; then
    for like in $OS_LIKE; do
        CANDIDATES+=("$(echo "$like" | tr '[:upper:]' '[:lower:]')")
    done
fi

if [ -n "$OS_LOGO" ]; then
    CANDIDATES+=("$(echo "$OS_LOGO" | tr '[:upper:]' '[:lower:]')")
fi

FOUND_LOGO=""

for cand in "${CANDIDATES[@]}"; do
    [ -z "$cand" ] && continue

    # 1. Exact match with standard patterns: cand-logo.png, cand.png, cand_logo.png
    for pattern in "${cand}-logo.png" "${cand}.png" "${cand}_logo.png" "$cand"; do
        for file in "$LOGO_DIR"/*; do
            [ -f "$file" ] || continue
            fname=$(basename "$file")
            [ "$fname" = "os-logo.png" ] && continue
            fname_lower=$(echo "$fname" | tr '[:upper:]' '[:lower:]')
            pattern_lower=$(echo "$pattern" | tr '[:upper:]' '[:lower:]')
            if [ "$fname_lower" = "$pattern_lower" ]; then
                FOUND_LOGO="$file"
                break 2
            fi
        done
    done

    # 2. Case-insensitive substring match (e.g. CachyOS_Logo.png for cand="cachyos")
    for file in "$LOGO_DIR"/*; do
        [ -f "$file" ] || continue
        fname=$(basename "$file")
        [ "$fname" = "os-logo.png" ] && continue
        fname_lower=$(echo "$fname" | tr '[:upper:]' '[:lower:]')
        if [[ "$fname_lower" == *"$cand"* ]]; then
            FOUND_LOGO="$file"
            break 2
        fi
    done
done

if [ -n "$FOUND_LOGO" ] && [ -f "$FOUND_LOGO" ]; then
    TARGET_NAME=$(basename "$FOUND_LOGO")
    CURRENT_REAL=$(realpath "$LOGO_DIR/os-logo.png" 2>/dev/null || true)
    DESIRED_REAL=$(realpath "$FOUND_LOGO" 2>/dev/null || true)

    if [ "$CURRENT_REAL" != "$DESIRED_REAL" ]; then
        ln -sf "$TARGET_NAME" "$LOGO_DIR/os-logo.png"
        echo "Updated fastfetch logo to $TARGET_NAME"
    fi
fi
