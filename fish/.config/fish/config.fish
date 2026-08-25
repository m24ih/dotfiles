# =============================================================================
# Fish Shell Configuration
# =============================================================================

# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================

# XDG Base Directory
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_CACHE_HOME "$HOME/.cache"

# Editor
set -gx EDITOR nvim
set -gx VISUAL nvim

# Man pages with bat
set -gx MANROFFOPT "-c"
if command -v bat >/dev/null 2>&1
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
end

# Development environments
set -gx ANDROID_HOME /opt/android-sdk
set -gx ANDROID_AVD_HOME "$HOME/.android/avd"
set -gx JAVA_HOME /usr/lib/jvm/java-25-openjdk
set -gx FLUTTER_HOME /opt/flutter
set -gx PUB_CACHE "$HOME/.pub-cache"
set -gx LINUXTOOLBOXDIR "$HOME/linuxtoolbox"

# Proton Pass integration
set -gx SSH_AUTH_SOCK "$HOME/.ssh/proton-pass-agent.sock"
set -gx PROTON_PASS_KEY_PROVIDER fs
if status is-interactive; and command -v dbus-update-activation-environment >/dev/null 2>&1
    dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP GNOME_KEYRING_CONTROL SSH_AUTH_SOCK PROTON_PASS_KEY_PROVIDER 2>/dev/null
end

# Chrome
set -gx CHROME_EXECUTABLE /usr/bin/google-chrome-stable

# =============================================================================
# PATH MANAGEMENT
# =============================================================================

# Add custom directories to PATH
fish_add_path -g \
    "$HOME/bin" \
    "$HOME/.local/bin" \
    "$HOME/.grok/bin" \
    "$HOME/.npm-global/bin" \
    "$HOME/.cargo/bin" \
    /var/lib/flatpak/exports/bin \
    "$HOME/.local/share/flatpak/exports/bin" \
    "$FLUTTER_HOME/bin" \
    "$PUB_CACHE/bin" \
    "$ANDROID_HOME/platform-tools" \
    "$ANDROID_HOME/cmdline-tools/latest/bin" \
    "$ANDROID_HOME/emulator" \
    "$ANDROID_HOME/tools/bin"

# =============================================================================
# FASTFETCH & GREETING
# =============================================================================

# OS-specific Fastfetch logo
function __update_fastfetch_logo
    set -l logo_dir "$HOME/.config/fastfetch/logo"
    test -d "$logo_dir"; or return
    test -f /etc/os-release; or return

    # Extract ID, ID_LIKE, and LOGO from /etc/os-release
    set -l os_id (command grep -E "^ID=" /etc/os-release 2>/dev/null | head -n 1 | string replace -r "^ID=" "" | string trim -c "\"'" | string lower)
    set -l os_like (command grep -E "^ID_LIKE=" /etc/os-release 2>/dev/null | head -n 1 | string replace -r "^ID_LIKE=" "" | string trim -c "\"'" | string lower)
    set -l os_logo (command grep -E "^LOGO=" /etc/os-release 2>/dev/null | head -n 1 | string replace -r "^LOGO=" "" | string trim -c "\"'" | string lower)

    set -l candidates $os_id (string split " " $os_like) $os_logo

    set -l found_logo ""
    for cand in $candidates
        test -z "$cand"; and continue

        # 1. Exact match with standard patterns: cand-logo.png, cand.png, cand_logo.png
        for pattern in "$cand-logo.png" "$cand.png" "$cand"_logo.png "$cand"
            for file in $logo_dir/*
                set -l fname (path basename "$file")
                test "$fname" = "os-logo.png"; and continue
                if test (string lower "$fname") = (string lower "$pattern")
                    set found_logo "$file"
                    break
                end
            end
            test -n "$found_logo"; and break
        end
        test -n "$found_logo"; and break

        # 2. Case-insensitive substring match (e.g. CachyOS_Logo.png for cand="cachyos")
        for file in $logo_dir/*
            set -l fname (path basename "$file")
            test "$fname" = "os-logo.png"; and continue
            if string match -qi "*$cand*" "$fname"
                set found_logo "$file"
                break
            end
        end
        test -n "$found_logo"; and break
    end

    if test -n "$found_logo" -a -f "$found_logo"
        set -l current_target (realpath "$logo_dir/os-logo.png" 2>/dev/null)
        set -l desired_target (realpath "$found_logo" 2>/dev/null)
        if test "$current_target" != "$desired_target"
            set -l rel_target (path basename "$found_logo")
            ln -sf "$rel_target" "$logo_dir/os-logo.png"
        end
    end
end

# Fastfetch wrapper to ensure OS logo is updated on each run
function fastfetch --description 'Run fastfetch with auto-updated OS logo'
    __update_fastfetch_logo
    command fastfetch $argv
end

# Greeting with Fastfetch
function fish_greeting
    if status is-interactive; and command -v fastfetch >/dev/null 2>&1
        fastfetch
    end
end

# =============================================================================
# SHELL OPTIONS
# =============================================================================

# Done plugin configuration
set -g __done_min_cmd_duration 10000
set -g __done_notification_urgency_level low

# Interactive shell integrations
if status is-interactive
    # Disable flow control (Ctrl+S/Q)
    stty -ixon

    # Starship & Zoxide
    if command -v starship >/dev/null 2>&1
        starship init fish | source
    end
    if command -v zoxide >/dev/null 2>&1
        zoxide init fish | source
    end

    # Quickshell sequences
    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    end
end

# =============================================================================
# CONDA (LAZY LOAD)
# =============================================================================

function __conda_setup
    if test -f /home/melih/anaconda3/bin/conda
        eval /home/melih/anaconda3/bin/conda "shell.fish" hook | source
    end
end

function conda
    functions -e conda
    __conda_setup
    command conda $argv
end

# =============================================================================
# ALIAS & ABBREVIATIONS
# =============================================================================

# Editor shortcuts
alias spico 'sudo pico'
alias snano 'sudo nano'
alias vim nvim
alias vi nvim
alias svi 'sudo nvim'
alias vis 'nvim "+set si"'
alias efishc 'nvim ~/.config/fish/config.fish'

# Search tools
if command -v rg >/dev/null 2>&1
    alias grep rg
else
    alias grep '/usr/bin/grep --color=auto'
end

if command -v bat >/dev/null 2>&1
    alias cat bat
end

# Basic system commands
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

# Navigation
alias home 'cd ~'
alias cd.. 'cd ..'
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias bd 'cd $dirprev'

# File management & eza
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

# Permissions
alias mx 'chmod a+x'
alias 000 'chmod -R 000'
alias 644 'chmod -R 644'
alias 666 'chmod -R 666'
alias 755 'chmod -R 755'
alias 777 'chmod -R 777'

# Search & info
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
alias watch-rclone 'watch -n 1 -c "rclone rc core/stats --url localhost:5572 | jq -C ."'

# Archives
alias mktar 'tar -cvf'
alias mkbz2 'tar -cvjf'
alias mkgz 'tar -cvzf'
alias untar 'tar -xvf'
alias unbz2 'tar -xvjf'
alias ungz 'tar -xvzf'
alias sha1 'openssl sha1'

# Other tools
alias rebootsafe 'sudo shutdown -r now'
alias rebootforce 'sudo shutdown -r -n now'
alias clickpaste 'sleep 3; xdotool type (xclip -o -selection clipboard)'
alias kssh 'kitty +kitten ssh'
alias docker-clean 'docker container prune -f; docker image prune -f; docker network prune -f; docker volume prune -f'
alias hug 'systemctl --user restart hugo'
alias lanm 'systemctl --user restart lan-mouse'
alias logs "sudo find /var/log -type f -exec file {} + | grep 'text' | cut -d: -f1 | xargs tail -f"

# Hardware control (Envycontrol)
alias integrated 'sudo envycontrol -s integrated --verbose'
alias hybrid 'sudo envycontrol -s hybrid --verbose'
alias glorious 'mxw report battery'

# Package managers
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

# =============================================================================
# FUNCTIONS
# =============================================================================

# History with timestamp
function history
    builtin history --show-time='%F %T ' $argv
end

# Simple backup
function backup --argument filename
    if test -z "$filename"
        echo "Kullanım: backup <dosya_adı>"
        return 1
    end
    cp -r "$filename" "$filename.bak"
end

# Smart copy
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
        set from (echo $argv[1] | string trim -r -c /)
        set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

# Count files, links, directories
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

# Auto ls on directory change
function __auto_ls --on-variable PWD
    if status is-interactive
        ls
    end
end

# Extract archives
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

# Find text
function ftext
    grep -iIHrn --color=always "$argv[1]" . | less -r
end

# Copy with progress bar
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

# Copy and go to directory
function cpg
    if test -d "$argv[2]"
        cp "$argv[1]" "$argv[2]"; and cd "$argv[2]"
    else
        cp "$argv[1]" "$argv[2]"
    end
end

# Move and go to directory
function mvg
    if test -d "$argv[2]"
        mv "$argv[1]" "$argv[2]"; and cd "$argv[2]"
    else
        mv "$argv[1]" "$argv[2]"
    end
end

# Make directory and go inside
function mkdirg
    mkdir -p "$argv[1]"
    cd "$argv[1]"
end

# Go up directories
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

# Get tail of current path
function pwdtail
    pwd | awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
end

# What's my IP
alias whatismyip whatsmyip
function whatsmyip
    echo -n "Dahili IP: "
    if command -v ip >/dev/null 2>&1
        set -l local_ip (ip route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}')
        if test -n "$local_ip"
            echo "$local_ip"
        else
            ip addr show 2>/dev/null | grep -E "inet .*scope global" | awk '{print $2}' | cut -d/ -f1 | head -n 1
        end
    else if command -v hostname >/dev/null 2>&1
        hostname -I 2>/dev/null | awk '{print $1}'
    else
        echo "Bulunamadı"
    end
    echo -n "Harici IP: "
    curl -4s ifconfig.me
    echo ""
end

# Git helpers
function gcom
    git add .
    git commit -m "$argv[1]"
end

function lazyg
    git add .
    git commit -m "$argv[1]"
    git push
end

# Hastebin upload
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

# =============================================================================
# KEY BINDINGS & THEME
# =============================================================================

# Set fish theme (moved from fish_frozen_theme.fish)
set --global fish_color_autosuggestion 555 brblack
set --global fish_color_cancel -r
set --global fish_color_command blue
set --global fish_color_comment red
set --global fish_color_cwd green
set --global fish_color_cwd_root red
set --global fish_color_end green
set --global fish_color_error brred
set --global fish_color_escape brcyan
set --global fish_color_history_current --bold
set --global fish_color_host normal
set --global fish_color_host_remote yellow
set --global fish_color_normal normal
set --global fish_color_operator brcyan
set --global fish_color_param cyan
set --global fish_color_quote yellow
set --global fish_color_redirection cyan --bold
set --global fish_color_search_match --background=111
set --global fish_color_selection white --bold --background=brblack
set --global fish_color_status red
set --global fish_color_user brgreen
set --global fish_color_valid_path --underline
set --global fish_pager_color_completion normal
set --global fish_pager_color_description B3A06D yellow -i
set --global fish_pager_color_prefix cyan --bold --underline
set --global fish_pager_color_progress brwhite --background=cyan
set --global fish_pager_color_selected_background -r

# Key bindings (moved from fish_frozen_key_bindings.fish)
# Set default key bindings to fish mode (not vi)
set -g fish_key_bindings fish_default_key_bindings

# Bang-bang history shortcuts
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]; commandline -f repaint
        case "*"
            commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

bind ! __history_previous_command
bind '$' __history_previous_command_arguments

# Ctrl+f -> zoxide interactive search
bind \cf 'commandline -i "zi"; commandline -f execute'
