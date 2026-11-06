#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="${XDG_BIN_HOME:-$HOME/.local/bin}"
APP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
MPV_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/mpv"

rm -rf "$MPV_DIR/scripts/uosc" "$MPV_DIR/script-opts/uosc.conf"
rm -f "$BIN_DIR/kick" "$BIN_DIR/kick-gui" "$APP_DIR/kick.desktop" "$MPV_DIR/kick-player.conf" "$MPV_DIR/scripts/kick-pin.lua"

MPV_CONF="$MPV_DIR/mpv.conf"
if [[ -f "$MPV_CONF" ]]; then
  tmp=$(mktemp)
  grep -v 'kick-player.conf' "$MPV_CONF" | grep -v '^# kick-player$' >"$tmp" || true
  mv "$tmp" "$MPV_CONF"
fi

command -v update-desktop-database >/dev/null && update-desktop-database "$APP_DIR" 2>/dev/null || true
echo "kick-player removed (history in ~/.config/kick kept)."
