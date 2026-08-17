#!/usr/bin/env bash

baseDir=$(dirname "$(realpath "$0")")
scrDir=$(dirname "$(dirname "$(realpath "$0")")")

pkg_installed() {
  local PkgIn=$1

  if pacman -Q "${PkgIn}" &>/dev/null; then
    return 0
  else
    return 1
  fi
}

if ! pkg_installed flatpak; then
  sudo pacman -S flatpak
fi

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flats=$(awk -F '#' '{print $1}' "${baseDir}/flat_packages.txt" 2>/dev/null | sed 's/ //g' | xargs)

if [ -n "${flats}" ]; then
  flatpak install -y flathub ${flats}
fi
flatpak remove --unused -y

gtkTheme=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | sed "s/'//g")
gtkIcon=$(gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null | sed "s/'//g")

flatpak --user override --filesystem=~/.themes
flatpak --user override --filesystem=~/.icons

flatpak --user override --filesystem=~/.local/share/themes
flatpak --user override --filesystem=~/.local/share/icons

if [ -n "${gtkTheme}" ]; then
  flatpak --user override --env=GTK_THEME=${gtkTheme}
fi
if [ -n "${gtkIcon}" ]; then
  flatpak --user override --env=ICON_THEME=${gtkIcon}
fi
