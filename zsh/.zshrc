# =============================================================================
# Zsh Configuration
# =============================================================================

# --- Fastfetch & Logo Yönetimi ---
__update_fastfetch_logo() {
  local logo_dir="$HOME/.config/fastfetch/logo"
  [[ -d "$logo_dir" ]] || return
  [[ -f /etc/os-release ]] || return

  # /etc/os-release dosyasından ID, ID_LIKE ve LOGO değerlerini oku
  local os_id os_like os_logo
  os_id=$(grep -E "^ID=" /etc/os-release 2>/dev/null | head -n 1 | sed -E 's/^ID=//; s/["'\'' ]//g' | tr '[:upper:]' '[:lower:]')
  os_like=$(grep -E "^ID_LIKE=" /etc/os-release 2>/dev/null | head -n 1 | sed -E 's/^ID_LIKE=//; s/["'\'' ]//g' | tr '[:upper:]' '[:lower:]')
  os_logo=$(grep -E "^LOGO=" /etc/os-release 2>/dev/null | head -n 1 | sed -E 's/^LOGO=//; s/["'\'' ]//g' | tr '[:upper:]' '[:lower:]')

  local -a candidates
  [[ -n "$os_id" ]] && candidates+=("$os_id")
  if [[ -n "$os_like" ]]; then
    for item in ${(s: :)os_like}; do
      candidates+=("$item")
    done
  fi
  [[ -n "$os_logo" ]] && candidates+=("$os_logo")

  local found_logo=""
  for cand in "${candidates[@]}"; do
    [[ -z "$cand" ]] && continue

    # 1. Standart kalıp eşleştirmeleri: cand-logo.png, cand.png, cand_logo.png
    for pattern in "${cand}-logo.png" "${cand}.png" "${cand}_logo.png" "$cand"; do
      for file in "$logo_dir"/*(N); do
        local fname="${file:t}"
        [[ "$fname" == "os-logo.png" ]] && continue
        if [[ "${fname:l}" == "${pattern:l}" ]]; then
          found_logo="$file"
          break 2
        fi
      done
    done
    [[ -n "$found_logo" ]] && break

    # 2. Alt dize eşleşmesi
    for file in "$logo_dir"/*(N); do
      local fname="${file:t}"
      [[ "$fname" == "os-logo.png" ]] && continue
      if [[ "${fname:l}" == *"${cand:l}"* ]]; then
        found_logo="$file"
        break 2
      fi
    done
  done

  if [[ -n "$found_logo" && -f "$found_logo" ]]; then
    local current_target desired_target rel_target
    current_target=$(realpath "$logo_dir/os-logo.png" 2>/dev/null)
    desired_target=$(realpath "$found_logo" 2>/dev/null)
    if [[ "$current_target" != "$desired_target" ]]; then
      rel_target="${found_logo:t}"
      ln -sf "$rel_target" "$logo_dir/os-logo.png"
    fi
  fi
}

fastfetch() {
  __update_fastfetch_logo
  command fastfetch "$@"
}

# =============================================================================
# ENVIRONMENT VARIABLES (ORTAM DEĞİŞKENLERİ)
# =============================================================================

# XDG Base Directory
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export LINUXTOOLBOXDIR="$HOME/linuxtoolbox"

# Editör ve Sayfalayıcı
export EDITOR="nvim"
export VISUAL="nvim"
export MANROFFOPT="-c"
if command -v bat &>/dev/null; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# Geliştirme Ortamları
export ANDROID_HOME="/opt/android-sdk"
export ANDROID_AVD_HOME="$HOME/.android/avd"
export JAVA_HOME="/usr/lib/jvm/java-25-openjdk"
export FLUTTER_HOME="/opt/flutter"
export PUB_CACHE="$HOME/.pub-cache"
export CHROME_EXECUTABLE="/usr/bin/google-chrome-stable"

# Proton Pass Entegrasyonu
export SSH_AUTH_SOCK="$HOME/.ssh/proton-pass-ssh-agent.sock"
export PROTON_PASS_LINUX_KEYRING=dbus
export PROTON_PASS_KEY_PROVIDER=fs

if [[ -o interactive ]] && command -v dbus-update-activation-environment &>/dev/null; then
  dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP GNOME_KEYRING_CONTROL SSH_AUTH_SOCK PROTON_PASS_KEY_PROVIDER 2>/dev/null
fi

# =============================================================================
# PATH YÖNETİMİ
# =============================================================================

typeset -U path
path=(
  "$HOME/bin"
  "$HOME/.local/bin"
  "$HOME/.grok/bin"
  "$HOME/.npm-global/bin"
  "$HOME/.cargo/bin"
  "/var/lib/flatpak/exports/bin"
  "$HOME/.local/share/flatpak/exports/bin"
  "$FLUTTER_HOME/bin"
  "$PUB_CACHE/bin"
  "$ANDROID_HOME/platform-tools"
  "$ANDROID_HOME/cmdline-tools/latest/bin"
  "$ANDROID_HOME/emulator"
  "$ANDROID_HOME/tools/bin"
  $path
)
export PATH

# =============================================================================
# OH MY ZSH & EKLENTİLER
# =============================================================================

export ZSH="$HOME/.oh-my-zsh"

plugins=(
  git
  docker
  docker-compose
  archlinux
  zsh-autosuggestions
  zsh-history-substring-search
  zsh-completions
  zsh-autopair
  zsh-syntax-highlighting
)

[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# =============================================================================
# ETKİLEŞİMLİ KABUK ENTEGRASYONLARI
# =============================================================================

if [[ -o interactive ]]; then
  # Akış kontrolünü kapat (Ctrl+S/Q kilitlenmelerini önler)
  stty -ixon 2>/dev/null

  # FZF Kaynakları
  [[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
  [[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh

  # Quickshell Terminal Renk Dizileri
  if [[ -f "$HOME/.local/state/quickshell/user/generated/terminal/sequences.txt" ]]; then
    cat "$HOME/.local/state/quickshell/user/generated/terminal/sequences.txt"
  fi

  # Starship & Zoxide
  if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
  fi
  if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
  fi

  # Başlangıç Karşılaması (Fastfetch)
  if command -v fastfetch &>/dev/null; then
    fastfetch
  fi
fi

# =============================================================================
# CONDA (LAZY LOAD - TEMBEL YÜKLEME)
# =============================================================================

__conda_setup() {
  if [[ -f "/home/melih/anaconda3/bin/conda" ]]; then
    eval "$('/home/melih/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  fi
}

conda() {
  unfunction conda
  __conda_setup
  conda "$@"
}

ENABLE_CORRECTION="true"
setopt correct_all

# =============================================================================
# ALIAS (KISAYOL) TANIMLAMALARI
# =============================================================================

# Editör Kısayolları
alias spico='sudo pico'
alias snano='sudo nano'
alias vim='nvim'
alias vi='nvim'
alias svi='sudo nvim'
alias vis='nvim "+set si"'
alias ezshc='nvim ~/.zshrc'
alias efishc='nvim ~/.config/fish/config.fish'
alias ebashc='nvim ~/.bashrc'

# Arama Araçları
if command -v rg &>/dev/null; then
  alias grep='rg'
else
  alias grep='/usr/bin/grep --color=auto'
fi

if command -v bat &>/dev/null; then
  alias cat='bat'
fi

# Temel Sistem Komutları
alias da='date "+%Y-%m-%d %A %T %Z"'
alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias cls='clear'
alias apt-get='sudo apt-get'
alias multitail='multitail --no-repeat -c'
alias freshclam='sudo freshclam'
alias btop='sudo -E btop'

# Dizin Gezinme
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias bd='cd "$OLDPWD"'

# Dosya Yönetimi & eza
alias rmd='/bin/rm --recursive --force --verbose'
alias ls='eza -l --icons --git --header'
alias l='eza --icons --git'
alias ll='eza -la --icons --git --header'
alias la='eza -la --icons --git --header'
alias l.='eza -laD --icons --git --header'
alias lt='eza -la --sort=modified --reverse --icons --git --header'
alias lS='eza -la --sort=size --reverse --icons --git --header'
alias lx='eza -la --sort=ext --icons --git --header'
alias T='eza --tree --level=3 --icons --git'
alias Ta='eza --tree --level=3 -a --icons --git'
alias lf='eza -l --icons --git --no-dir'
alias ldir='eza -lD --icons --git'

# İzinler
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Arama ve Sistem Bilgisi
alias h='history | grep'
alias p='ps aux | grep'
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"
alias f="find . | grep"
alias checkcommand="type -t"
alias openports='netstat -nape --inet'
alias diskspace="du -S | sort -n -r | more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

# Rclone Yönetimi
alias rclone-status='rclone rc core/stats --url localhost:5572'
alias rclone-vfs='rclone rc vfs/stats --url localhost:5572'
alias rclone-queue='rclone rc vfs/queue --url localhost:5572'
alias watch-rclone='watch -n 1 -c "rclone rc core/stats --url localhost:5572 | jq -C ."'
alias watch-rclone-queue='watch -n 1 -c "rclone rc vfs/queue --url localhost:5572 | jq -C ."'
alias watch-rclone-all='watch -n 1 -c "zsh -c rclone-all"'

# Arşivler
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'
alias sha1='openssl sha1'

# Donanım ve Servisler
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'
alias clickpaste='sleep 3; xdotool type "$(xclip -o -selection clipboard)"'
alias kssh="kitty +kitten ssh"
alias docker-clean='docker container prune -f; docker image prune -f; docker network prune -f; docker volume prune -f'
alias hug="systemctl --user restart hugo"
alias lanm="systemctl --user restart lan-mouse"
alias logs="sudo find /var/log -type f -exec file {} + | grep 'text' | cut -d: -f1 | xargs tail -f"
alias integrated="sudo envycontrol -s integrated --verbose"
alias hybrid="sudo envycontrol -s hybrid --verbose"
alias glorious="mxw report battery"

# Paket Yöneticileri (Paru & Yay)
alias p="paru"
alias pup="paru -Syu"
alias pin="paru -S"
alias prm="paru -Rns"
alias pse="paru -Ss"
alias paruf="paru -Slq | fzf --multi --preview 'paru -Sii {1}' --preview-window=down:75% | xargs -ro paru -S"
alias parur="paru -Qq | fzf --multi --preview 'paru -Qi {1}' --preview-window=down:75% | xargs -ro paru -Rns"

alias y="yay"
alias yup="yay -Syu"
alias yin="yay -S"
alias yrm="yay -Rns"
alias yse="yay -Ss"
alias yayf="yay -Slq | fzf --multi --preview 'yay -Sii {1}' --preview-window=down:75% | xargs -ro yay -S"
alias yayr="yay -Qq | fzf --multi --preview 'yay -Qi {1}' --preview-window=down:75% | xargs -ro yay -Rns"

# =============================================================================
# FONKSİYONLAR
# =============================================================================

# Rclone Tüm İstatistikler
rclone-all() {
  echo "=== Core Stats ==="
  rclone rc core/stats --url localhost:5572 | jq -C .
  echo "=== VFS Queue ==="
  rclone rc vfs/queue --url localhost:5572 | jq -C .
}

# Hızlı Yedekleme
backup() {
  if [[ -z "$1" ]]; then
    echo "Kullanım: backup <dosya_adı>"
    return 1
  fi
  cp -r "$1" "$1.bak"
}

# Akıllı Kopyalama (Klasör algılanırsa -r otomatik)
copy() {
  if [[ $# -eq 2 && -d "$1" ]]; then
    local from="${1%/}"
    local to="$2"
    command cp -r "$from" "$to"
  else
    command cp "$@"
  fi
}

# Dosya, sembolik bağ ve dizin sayılarını listeleme
countfiles() {
  for t in f l d; do
    local name="files"
    [[ "$t" == "l" ]] && name="links"
    [[ "$t" == "d" ]] && name="directories"
    echo "$(find . -type "$t" 2>/dev/null | wc -l) $name"
  done
}

# Arşiv çıkarma fonksiyonu
extract() {
  for archive in "$@"; do
    if [[ -f "$archive" ]]; then
      case "$archive" in
        *.tar.bz2|*.tbz2) tar xvjf "$archive" ;;
        *.tar.gz|*.tgz)   tar xvzf "$archive" ;;
        *.bz2)            bunzip2 "$archive" ;;
        *.rar)            unrar x "$archive" ;;
        *.gz)             gunzip "$archive" ;;
        *.tar)            tar xvf "$archive" ;;
        *.zip)            unzip "$archive" ;;
        *.Z)              uncompress "$archive" ;;
        *.7z)             7z x "$archive" ;;
        *)                echo "Bilinmeyen arşiv türü: '$archive'" ;;
      esac
    else
      echo "'$archive' geçerli bir dosya değil!"
    fi
  done
}

# Dosya içinde metin arama
ftext() {
  grep -iIHrn --color=always "$1" . | less -r
}

# İlerleme çubuğu ile dosya kopyalama
cpp() {
  local total_size
  total_size=$(stat -c '%s' "$1")
  strace -q -ewrite cp -- "$1" "$2" 2>&1 |
  awk -v total_size="$total_size" '{
            count += $NF
            if (count % 10 == 0) {
                percent = count / total_size * 100
                printf "%3d%% [", percent
                for (i=0;i<=percent;i++) printf "="
     
                printf ">"
                for (i=percent;i<100;i++) printf " "
                printf "]\r"
            }
        }
        END { print "" }'
}

# Kopyala ve o dizine git
cpg() {
  if [[ -d "$2" ]]; then
    cp "$1" "$2" && cd "$2"
  else
    cp "$1" "$2"
  fi
}

# Taşı ve o dizine git
mvg() {
  if [[ -d "$2" ]]; then
    mv "$1" "$2" && cd "$2"
  else
    mv "$1" "$2"
  fi
}

# Dizin oluştur ve içine gir
mkdirg() {
  mkdir -p "$1" && cd "$1"
}

# Belirtilen sayıda yukarı dizine çık
up() {
  local limit=${1:-1}
  local path=""
  for i in $(seq 1 "$limit"); do
    path="../$path"
  done
  cd "$path"
}

# Çalışılan dizinin son iki bölümünü göster
pwdtail() {
  pwd | awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}

# IP adresi bulma
alias whatismyip='whatsmyip'
whatsmyip() {
  echo -n "Dahili IP: "
  local local_ip
  if command -v ip &>/dev/null; then
    local_ip=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}')
    if [[ -n "$local_ip" ]]; then
      echo "$local_ip"
    else
      ip addr show 2>/dev/null | grep -E "inet .*scope global" | awk '{print $2}' | cut -d/ -f1 | head -n 1
    fi
  elif command -v hostname &>/dev/null; then
    hostname -I 2>/dev/null | awk '{print $1}'
  else
    echo "Bulunamadı"
  fi

  echo -n "Harici IP: "
  curl -4s ifconfig.me
  echo ""
}

# GitHub Fonksiyonları
gcom() {
  git add .
  git commit -m "$1"
}

lazyg() {
  git add .
  git commit -m "$1"
  git push
}

# Hastebin Belge Yükleme
hb() {
  if [[ $# -eq 0 ]]; then
    echo "Dosya yolu belirtilmedi."
    return 1
  fi
  if [[ ! -f "$1" ]]; then
    echo "Dosya yolu mevcut değil."
    return 1
  fi
  local uri="http://bin.christitus.com/documents"
  local response
  response=$(curl -s -X POST -d @"$1" "$uri")
  if [[ $? -eq 0 ]]; then
    local hasteKey
    hasteKey=$(echo "$response" | jq -r '.key')
    echo "http://bin.christitus.com/$hasteKey"
  else
    echo "Belge yüklenemedi."
  fi
}

# Dizin değişiminde otomatik ls
chpwd() {
  if [[ -o interactive ]]; then
    ls
  fi
}

# =============================================================================
# TUŞ ATAMALARI (KEY BINDINGS) & VI MODU
# =============================================================================

# Vi Modunu Etkinleştir
bindkey -v

# ESC tuşu gecikmesini en aza indir (varsayılan 0.4s çok yavaştır)
export KEYTIMEOUT=15

# Visual Mode (Görsel Seçim) ve Vurgulama
bindkey -M vicmd 'v' visual-mode
bindkey -M vicmd 'V' visual-line-mode
zle_highlight=(region:standout)

# Normal Modda 'vv' ile geçerli komutu Neovim'de ($EDITOR) açıp düzenleme
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'vv' edit-command-line

# Hem Normal (vicmd) hem Ekleme (viins) modunda arama ve geçmiş tuşları
bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward
bindkey -M viins '^a' beginning-of-line
bindkey -M viins '^e' end-of-line
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^h' backward-delete-char
bindkey -M viins '^w' backward-kill-word

# Ctrl+f -> Zoxide Interactive Search
bindkey -M viins '^f' 'zi\n'
bindkey -M vicmd '^f' 'zi\n'

# zsh-history-substring-search tuş atamaları (Normal ve Ekleme modu için)
bindkey -M viins '^[[A' history-substring-search-up
bindkey -M viins '^[[B' history-substring-search-down
bindkey -M vicmd '^[[A' history-substring-search-up
bindkey -M vicmd '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up 2>/dev/null
bindkey "$terminfo[kcud1]" history-substring-search-down 2>/dev/null

# Düzenleme Kısayolları
bindkey '^Z' undo 2>/dev/null

# Vi Moduna göre İmleç Şeklini Değiştir (Normal Mod: Blok [█], Ekleme Modu: Çizgi [|])
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
_fix_cursor() { echo -ne '\e[5 q'; }
precmd_functions+=(_fix_cursor)

# =============================================================================
# DİĞER
# =============================================================================

# Added by Antigravity CLI installer
export PATH="/home/melih/.local/bin:$PATH"

# =============================================================================
# MODÜLER YAPILANDIRMALAR (~/.config/zshrc.d)
# =============================================================================
if [ -d "$HOME/.config/zshrc.d" ]; then
  for file in "$HOME/.config/zshrc.d"/*.{zsh,sh}(N); do
    [ -f "$file" ] && source "$file"
  done
fi
