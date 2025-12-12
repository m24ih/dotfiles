source /usr/share/cachyos-fish-config/cachyos-config.fish

# Starship ve Zoxide'ı başlat
starship init fish | source
zoxide init fish | source

if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
end

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# >>> conda initialize >>>
# Conda'yı sadece gerektiğinde yüklemek için (Fish Shell Lazy Load)
function __conda_setup
    # Conda'nın asıl başlatma komutunu çalıştır
    if test -f /home/melih/anaconda3/bin/conda
        eval /home/melih/anaconda3/bin/conda "shell.fish" hook | source
    end
end

function conda
    # Bu geçici fonksiyonu sil
    functions --erase conda

    # Asıl conda kurulumunu yap
    __conda_setup

    # Şimdi gerçek conda komutunu kullanıcının argümanları ile çalıştır
    command conda $argv
end

set -x CHROME_EXECUTABLE /usr/bin/google-chrome-stable

set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx LINUXTOOLBOXDIR "$HOME/linuxtoolbox"
stty -ixon
set -gx EDITOR nvim
set -gx VISUAL nvim

alias spico 'sudo pico'
alias snano 'sudo nano'
alias vim nvim
alias vi nvim
alias svi 'sudo nvim' # vi'yi nvim'e yönlendirdiğimiz için svi'yi de güncelledik.
alias vis 'nvim "+set si"'

# grep için ripgrep (rg) kontrolü
if command -v rg >/dev/null 2>&1
    alias grep rg
else
    # GREP_OPTIONS artık önerilmiyor, --color=auto çoğu dağıtımda varsayılan.
    alias grep '/usr/bin/grep --color=auto'
end

# config.fish dosyasını düzenle
alias efishc 'nvim ~/.config/fish/config.fish'

# Tarih alias'ı
alias da 'date "+%Y-%m-%d %A %T %Z"'

# Değiştirilmiş komutlar
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
alias yayf "yay -Slq | fzf --multi --preview 'yay -Sii {1}' --preview-window=down:75% | xargs -ro yay -S"

# Dizin değiştirme alias'ları
alias home 'cd ~'
alias cd.. 'cd ..'
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias bd 'cd $dirprev' # Fish'te OLDPWD yerine dirprev kullanılır

# Dizin ve içeriğini sil
alias rmd '/bin/rm --recursive --force --verbose'

# eza (ls alternatifi) için alias'lar
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

# chmod alias'ları
alias mx 'chmod a+x'
alias 000 'chmod -R 000'
alias 644 'chmod -R 644'
alias 666 'chmod -R 666'
alias 755 'chmod -R 755'
alias 777 'chmod -R 777'

# Arama alias'ları
alias h 'history | grep'
alias p "ps aux | grep"
alias topcpu "/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"
alias f "find . | grep"

# Diğer alias'lar
alias checkcommand "type -t"
alias openports 'netstat -nape --inet'
alias rebootsafe 'sudo shutdown -r now'
alias rebootforce 'sudo shutdown -r -n now'
alias diskspace "du -S | sort -n -r | more"
alias folders 'du -h --max-depth=1'
alias folderssort 'find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree 'tree -CAhF --dirsfirst'
alias treed 'tree -CAFd'
alias mountedinfo 'df -hT'
alias mktar 'tar -cvf'
alias mkbz2 'tar -cvjf'
alias mkgz 'tar -cvzf'
alias untar 'tar -xvf'
alias unbz2 'tar -xvjf'
alias ungz 'tar -xvzf'
alias sha1 'openssl sha1'
#alias logs "sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]\$' | xargs tail -f"
alias clickpaste 'sleep 3; xdotool type (xclip -o -selection clipboard)'
alias kssh "kitty +kitten ssh"
alias docker-clean 'docker container prune -f; docker image prune -f; docker network prune -f; docker volume prune -f'
alias hug "systemctl --user restart hugo"
alias lanm "systemctl --user restart lan-mouse"

# Temel Komut
abbr --add p paru

# Güncelleme (System Update)
abbr --add pup "paru -Syu"

# Kurulum (Install)
abbr --add in "paru -S"

# Silme (Remove - Bağımlılıklar ve ayar dosyalarıyla birlikte)
abbr --add prm "paru -Rns"

# Arama (Search - Yüklü olmayanları da bulur)
abbr --add se "paru -Ss"

# Temizlik (Cache Clean - Orphan paketler ve önbellek)
abbr --add cl "paru -Sc"

# cat'i bat olarak kullanmak için (eğer yüklüyse)
if command -v bat >/dev/null 2>&1
    alias cat bat
end

#######################################################
# FONKSİYONLAR
#######################################################
# Not: Fish'te fonksiyonlar `function name ...; end` bloğu ile tanımlanır.
# Argümanlar `$1`, `$2` yerine `$argv[1]`, `$argv[2]` olarak alınır.

# Arşiv çıkarma fonksiyonu
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

# Dosya içinde metin arama
function ftext
    grep -iIHrn --color=always "$argv[1]" . | less -r
end

# İlerleme çubuğu ile dosya kopyalama
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

# Kopyala ve o dizine git
function cpg
    if test -d "$argv[2]"
        cp "$argv[1]" "$argv[2]"; and cd "$argv[2]"
    else
        cp "$argv[1]" "$argv[2]"
    end
end

# Taşı ve o dizine git
function mvg
    if test -d "$argv[2]"
        mv "$argv[1]" "$argv[2]"; and cd "$argv[2]"
    else
        mv "$argv[1]" "$argv[2]"
    end
end

# Dizin oluştur ve içine gir
function mkdirg
    mkdir -p "$argv[1]"
    cd "$argv[1]"
end

# Belirtilen sayıda yukarı dizine çık
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

# cd komutundan sonra ls çalıştır
function cd
    builtin cd $argv; and ls
end

# Çalışılan dizinin son iki bölümünü göster
function pwdtail
    pwd | awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
end

# Linux dağıtımını bul
function distribution
    set -l dtype unknown
    if test -r /etc/os-release
        source /etc/os-release
        switch $ID
            case fedora rhel centos
                set dtype redhat
            case sles "opensuse*"
                set dtype suse
            case ubuntu debian
                set dtype debian
            case gentoo
                set dtype gentoo
            case arch manjaro
                set dtype arch
            case slackware
                set dtype slackware
            case "*"
                if set -q ID_LIKE
                    switch $ID_LIKE
                        case "*fedora*" "*rhel*" "*centos*"
                            set dtype redhat
                        case "*sles*" "*opensuse*"
                            set dtype suse
                        case "*ubuntu*" "*debian*"
                            set dtype debian
                        case "*gentoo*"
                            set dtype gentoo
                        case "*arch*"
                            set dtype arch
                        case "*slackware*"
                            set dtype slackware
                    end
                end
        end
    end
    echo $dtype
end

# İşletim sistemi versiyonunu göster
function ver
    set -l dtype (distribution)
    switch $dtype
        case redhat
            if test -s /etc/redhat-release
                cat /etc/redhat-release
            else
                cat /etc/issue
            end
            uname -a
        case suse
            cat /etc/SuSE-release
        case debian
            lsb_release -a
        case gentoo
            cat /etc/gentoo-release
        case arch
            cat /etc/os-release
        case slackware
            cat /etc/slackware-version
        case "*"
            if test -s /etc/issue
                cat /etc/issue
            else
                echo "Hata: Bilinmeyen dağıtım"
                return 1
            end
    end
end

# Gerekli destek dosyalarını kur
function install_bashrc_support
    set -l dtype (distribution)
    switch $dtype
        case redhat
            sudo yum install multitail tree zoxide trash-cli fzf fastfetch
        case suse
            sudo zypper install multitail tree zoxide trash-cli fzf fastfetch
        case debian
            sudo apt-get install multitail tree zoxide trash-cli fzf
            set FASTFETCH_URL (curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | grep "browser_download_url.*linux-amd64.deb" | cut -d '"' -f 4)
            curl -sL $FASTFETCH_URL -o /tmp/fastfetch_latest_amd64.deb
            sudo apt-get install /tmp/fastfetch_latest_amd64.deb
        case arch
            sudo paru -S multitail tree zoxide trash-cli fzf fastfetch
        case slackware
            echo "Slackware için kurulum desteği yok"
        case "*"
            echo "Bilinmeyen dağıtım"
    end
end

# IP adresi bulma
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

# GitHub Fonksiyonları
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

#######################################################
# SON AYARLAMALAR VE ENTEGRASYONLAR
#######################################################

# Ctrl+f için özel tuş ataması
# 'zi' yazıp enter'a basar (zoxide interactive)
bind \cf 'commandline -i "zi"; commandline -f execute'

# PATH'e eklemeler (Fish'in kendi yöntemiyle)
fish_add_path -g "$HOME/.local/bin"
fish_add_path -g "$HOME/.cargo/bin"
fish_add_path -g /var/lib/flatpak/exports/bin
fish_add_path -g "/.local/share/flatpak/exports/bin"

# TTY1'de isek ve DISPLAY yoksa, grafik arayüzü başlat
if not set -q DISPLAY; and test (tty) = /dev/tty1
    exec startx
end
# --- DÜZELTİLMİŞ KOD BLOKU ---

# zoxide komutlarından sonra otomatik 'ls' çalıştırmak için.

# 'z' komutunu sarmalamak için
if functions -q z
    # Sadece '__zoxide_z' adında bir kopya HENÜZ YOKSA kopyala
    if not functions -q __zoxide_z
        functions --copy z __zoxide_z
    end

    # 'z' fonksiyonunu her zaman bizim versiyonumuzla yeniden tanımla
    function z --wraps z --description "zoxide ile dizin değiştir ve listele"
        # Orijinal fonksiyonu çağır VE başarılı olursa 'ls' çalıştır
        __zoxide_z $argv; and ls
    end
end

# 'zi' (interaktif) komutunu sarmalamak için
if functions -q zi
    # Sadece '__zoxide_zi' adında bir kopya HENÜZ YOKSA kopyala
    if not functions -q __zoxide_zi
        functions --copy zi __zoxide_zi
    end

    # 'zi' fonksiyonunu her zaman bizim versiyonumuzla yeniden tanımla
    function zi --wraps zi --description "zoxide ile interaktif dizin değiştir ve listele"
        # Orijinal fonksiyonu çağır VE başarılı olursa 'ls' çalıştır
        __zoxide_zi $argv; and ls
    end
end
