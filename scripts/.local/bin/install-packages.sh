#!/usr/bin/env bash
set -e


if ! command -v yay >/dev/null; then
  echo "==> yay not found, installing..."
  sudo pacman -S --needed git base-devel
  git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
  (cd /tmp/yay-bin && makepkg -si --noconfirm)
fi

PKG_FILE="$HOME/Documents/packages.txt"
AUR_FILE="$HOME/Documents/aur-packages.txt"

[[ -f "$PKG_FILE" ]] || { echo "Missing $PKG_FILE"; exit 1; }
[[ -f "$AUR_FILE" ]] || { echo "Missing $AUR_FILE"; exit 1; }

echo "==> Installing pacman packages..."
sed -e 's/#.*//' -e '/^\s*$/d' "$PKG_FILE" \
  | xargs sudo pacman -S --needed --noconfirm

echo
echo "==> Installing AUR packages..."
sed -e 's/#.*//' -e '/^\s*$/d' "$AUR_FILE" \
  | xargs yay -S --needed --noconfirm

echo
echo "==> All packages installed successfully."

