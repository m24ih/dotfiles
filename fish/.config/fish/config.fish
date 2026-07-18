# ===========================================================================
# BAŞLATMA VE BAĞIMLILIKLAR
# ===========================================================================

# CachyOS varsayılan yapılandırmasını yükle
if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

# Starship ve Zoxide entegrasyonu
starship init fish | source
zoxide init fish | source

# Quickshell sekansları
if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
end

# Etkileşimli kabuk ayarları (Ctrl+S / Ctrl+Q akış kontrolünü kapat)
if status is-interactive
    stty -ixon
end

# ===========================================================================
# CONDA (LAZY LOAD)
# ===========================================================================
function __conda_setup
    if test -f /home/melih/anaconda3/bin/conda
        eval /home/melih/anaconda3/bin/conda "shell.fish" hook | source
    end
end

function conda
    functions --erase conda
    __conda_setup
    command conda $argv
end

# ===========================================================================
# ORTAM DEĞİŞKENLERİ (ENV VARS)
# ===========================================================================
set -gx CHROME_EXECUTABLE /usr/bin/google-chrome-stable
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx LINUXTOOLBOXDIR "$HOME/linuxtoolbox"

set -gx EDITOR nvim
set -gx VISUAL nvim

# Proton Pass Entegrasyonu
set -gx SSH_AUTH_SOCK "$HOME/.ssh/proton-pass-agent.sock"
set -gx PROTON_PASS_LINUX_KEYRING dbus

# Android, Java, Flutter
set -gx ANDROID_HOME /opt/android-sdk
set -gx ANDROID_AVD_HOME "$HOME/.android/avd"
set -gx JAVA_HOME /usr/lib/jvm/java-25-openjdk
set -gx FLUTTER_HOME /opt/flutter
set -gx PUB_CACHE "$HOME/.pub-cache"

# ===========================================================================
# PATH YÖNETİMİ
# ===========================================================================
fish_add_path -g \
    "$HOME/bin" \
    "$HOME/.local/bin" \
    "$HOME/.cargo/bin" \
    /var/lib/flatpak/exports/bin \
    "$HOME/.local/share/flatpak/exports/bin" \
    "$FLUTTER_HOME/bin" \
    "$PUB_CACHE/bin" \
    "$ANDROID_HOME/platform-tools" \
    "$ANDROID_HOME/cmdline-tools/latest/bin" \
    "$ANDROID_HOME/emulator" \
    "$ANDROID_HOME/tools/bin"

# ===========================================================================
# ALIAS VE KISALTMALAR (ABBR)
# ===========================================================================
# Editör & Sistem Kısayolları
alias spico 'sudo pico'
alias snano 'sudo nano'
alias vim nvim
alias vi nvim
alias svi 'sudo nvim'
alias vis 'nvim "+set si"'
alias efishc 'nvim ~/.config/fish/config.fish'

if command -v rg >/dev/null 2>&1
    alias grep rg
else
    alias grep '/usr/bin/grep --color=auto'
end

if command -v bat >/dev/null 2>&1
    alias cat bat
end

# Temel Sistem Komutları
alias da 'date "+%Y-%m-%d %A %T %Z"'
alias cp 'cp -i'
alias mv 'mv -i'
alias rm 'trash -v'
alias mkdir 'mkdir -p'
alias ps 'ps auxf'
alias ping 'ping -c 10'
alias less 'less -R'
alias cls clear
alias apt-get 'sudo apt-get'
alias multitail 'multitail --no-repeat -c'
alias freshclam 'sudo freshclam'

# Navigasyon
alias home 'cd ~'
alias cd.. 'cd ..'
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias bd 'cd $dirprev'

# Dosya Yönetimi & eza
alias rmd '/bin/rm --recursive --force --verbose'
alias ls 'eza -l --icons --git --header'
alias l 'eza --icons --git'
alias ll 'eza -la --icons --git --header'
alias la 'eza -la --icons --git --header'
alias l. 'eza -laD --icons --git --header'
alias lt 'eza -la --sort=modified --reverse --icons --git --header'
alias lS 'eza -la --sort=size --reverse --icons --git --header'
alias lx 'eza -la --sort=ext --icons --git --header'
alias T 'eza --tree --level=3 --icons --git'
alias Ta 'eza --tree --level=3 -a --icons --git'
alias lf 'eza -l --icons --git --no-dir'
alias ldir 'eza -lD --icons --git'

# Yetki (Chmod)
alias mx 'chmod a+x'
alias 000 'chmod -R 000'
alias 644 'chmod -R 644'
alias 666 'chmod -R 666'
alias 755 'chmod -R 755'
alias 777 'chmod -R 777'

# Arama & Bilgi
alias h 'history | grep'
alias p 'ps aux | grep'
alias topcpu '/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10'
alias f 'find . | grep'
alias checkcommand 'type -t'
alias openports 'netstat -nape --inet'
alias diskspace 'du -S | sort -n -r | more'
alias folders 'du -h --max-depth=1'
alias folderssort 'find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree 'tree -CAhF --dirsfirst'
alias treed 'tree -CAFd'
alias mountedinfo 'df -hT'

alias rclone-status 'rclone rc core/stats --url localhost:5572'

# Arşiv
alias mktar 'tar -cvf'
alias mkbz2 'tar -cvjf'
alias mkgz 'tar -cvzf'
alias untar 'tar -xvf'
alias unbz2 'tar -xvjf'
alias ungz 'tar -xvzf'
alias sha1 'openssl sha1'

# Diğer Araçlar
alias rebootsafe 'sudo shutdown -r now'
alias rebootforce 'sudo shutdown -r -n now'
alias clickpaste 'sleep 3; xdotool type (xclip -o -selection clipboard)'
alias kssh 'kitty +kitten ssh'
alias docker-clean 'docker container prune -f; docker image prune -f; docker network prune -f; docker volume prune -f'
alias hug 'systemctl --user restart hugo'
alias lanm 'systemctl --user restart lan-mouse'
alias logs "sudo find /var/log -type f -exec file {} + | grep 'text' | cut -d: -f1 | xargs tail -f"

# Donanım Kontrolü (Envycontrol)
alias integrated 'sudo envycontrol -s integrated --verbose'
alias hybrid 'sudo envycontrol -s hybrid --verbose'

alias glorious 'mxw report battery'

# Paket Yöneticisi (Paru & Yay Kısaltmaları)
abbr --add p paru
abbr --add pup "paru -Syu"
abbr --add pin "paru -S"
abbr --add prm "paru -Rns"
abbr --add pse "paru -Ss"
alias paruf "paru -Slq | fzf --multi --preview 'paru -Sii {1}' --preview-window=down:75% | xargs -ro paru -S"
alias parur "paru -Qq | fzf --multi --preview 'paru -Qi {1}' --preview-window=down:75% | xargs -ro paru -Rns"

abbr --add y yay
abbr --add yup "yay -Syu"
abbr --add yin "yay -S"
abbr --add yrm "yay -Rns"
abbr --add yse "yay -Ss"
alias yayf "yay -Slq | fzf --multi --preview 'yay -Sii {1}' --preview-window=down:75% | xargs -ro yay -S"
alias yayr "yay -Qq | fzf --multi --preview 'yay -Qi {1}' --preview-window=down:75% | xargs -ro yay -Rns"

# ===========================================================================
# FONKSİYONLAR
# ===========================================================================

function countfiles
    for t in f l d
        set name files
        if test $t = l
            set name links
        end
        if test $t = d
            set name directories
        end
        echo (find . -type $t 2>/dev/null | wc -l) $name
    end
end

# Dizin değiştiğinde otomatik 'ls' tetikle (chpwd yerine nizamî fish metodu)
function __auto_ls --on-variable PWD
    if status is-interactive
        ls
    end
end

function extract
    for archive in $argv
        if test -f "$archive"
            switch "$archive"
                case "*.tar.bz2" "*.tbz2"
                    tar xvjf "$archive"
                case "*.tar.gz" "*.tgz"
                    tar xvzf "$archive"
                case "*.bz2"
                    bunzip2 "$archive"
                case "*.rar"
                    unrar x "$archive"
                case "*.gz"
                    gunzip "$archive"
                case "*.tar"
                    tar xvf "$archive"
                case "*.zip"
                    unzip "$archive"
                case "*.Z"
                    uncompress "$archive"
                case "*.7z"
                    7z x "$archive"
                case "*"
                    echo "Bilinmeyen arşiv türü: '$archive'"
            end
        else
            echo "'$archive' geçerli bir dosya değil!"
        end
    end
end

function ftext
    grep -iIHrn --color=always "$argv[1]" . | less -r
end

function cpp
    set total_size (stat -c '%s' "$argv[1]")
    strace -q -ewrite cp -- "$argv[1]" "$argv[2]" 2>&1 |
        awk -v total_size=$total_size '{
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
end

function cpg
    if test -d "$argv[2]"
        cp "$argv[1]" "$argv[2]"; and cd "$argv[2]"
    else
        cp "$argv[1]" "$argv[2]"
    end
end

function mvg
    if test -d "$argv[2]"
        mv "$argv[1]" "$argv[2]"; and cd "$argv[2]"
    else
        mv "$argv[1]" "$argv[2]"
    end
end

function mkdirg
    mkdir -p "$argv[1]"
    cd "$argv[1]"
end

function up
    set -l limit $argv[1]
    if test -z "$limit"
        set limit 1
    end
    set -l path ""
    for i in (seq 1 $limit)
        set path "../$path"
    end
    cd $path
end

function pwdtail
    pwd | awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
end

alias whatismyip whatsmyip
function whatsmyip
    echo -n "Dahili IP: "
    if command -v ip >/dev/null 2>&1
        ip addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
    else
        ifconfig wlan0 | grep "inet " | awk '{print $2}'
    end
    echo -n "Harici IP: "
    curl -4 ifconfig.me
end

function gcom
    git add .
    git commit -m "$argv[1]"
end

function lazyg
    git add .
    git commit -m "$argv[1]"
    git push
end

function hb
    if count $argv -eq 0
        echo "Dosya yolu belirtilmedi."
        return 1
    end
    if not test -f "$argv[1]"
        echo "Dosya yolu mevcut değil."
        return 1
    end
    set -l uri "http://bin.christitus.com/documents"
    set -l response (curl -s -X POST -d @"$argv[1]" "$uri")
    if test $status -eq 0
        set -l hasteKey (echo $response | jq -r '.key')
        echo "http://bin.christitus.com/$hasteKey"
    else
        echo "Belge yüklenemedi."
    end
end

# ===========================================================================
# TUŞ ATAMALARI (KEY BINDINGS)
# ===========================================================================
# Ctrl+f tuşuna basıldığında zoxide interaktif arama tetiklenir
bind \cf 'commandline -i "zi"; commandline -f execute'
