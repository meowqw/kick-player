#!/usr/bin/env bash
# Install kick-player for the current user.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${XDG_BIN_HOME:-$HOME/.local/bin}"
APP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
MPV_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/mpv"
SL_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/streamlink"

mkdir -p "$BIN_DIR" "$APP_DIR" "$MPV_DIR/watch_later" "$SL_DIR"

install -m 0755 "$ROOT/bin/kick" "$BIN_DIR/kick"
install -m 0755 "$ROOT/bin/kick-gui" "$BIN_DIR/kick-gui"
install -m 0644 "$ROOT/share/applications/kick.desktop" "$APP_DIR/kick.desktop"
install -m 0644 "$ROOT/config/mpv-kick.conf" "$MPV_DIR/kick-player.conf"

# Ensure mpv includes our config (do not clobber an existing mpv.conf)
MPV_CONF="$MPV_DIR/mpv.conf"
INCLUDE_LINE='include="~~/kick-player.conf"'
if [[ -f "$MPV_CONF" ]]; then
  if ! grep -Fq 'kick-player.conf' "$MPV_CONF"; then
    printf '\n# kick-player\n%s\n' "$INCLUDE_LINE" >>"$MPV_CONF"
    echo "Appended include to $MPV_CONF"
  fi
else
  printf '%s\n' "$INCLUDE_LINE" >"$MPV_CONF"
  echo "Created $MPV_CONF"
fi

# Streamlink config only if missing
if [[ ! -f "$SL_DIR/config" ]]; then
  install -m 0644 "$ROOT/config/streamlink.config" "$SL_DIR/config"
  echo "Installed $SL_DIR/config"
else
  echo "Kept existing $SL_DIR/config"
fi

command -v update-desktop-database >/dev/null && update-desktop-database "$APP_DIR" 2>/dev/null || true

missing=()
for cmd in mpv yt-dlp streamlink; do
  command -v "$cmd" >/dev/null || missing+=("$cmd")
done

echo
echo "Installed:"
echo "  $BIN_DIR/kick"
echo "  $BIN_DIR/kick-gui"
echo "  $APP_DIR/kick.desktop"
echo "  $MPV_DIR/kick-player.conf"
echo
if ((${#missing[@]} > 0)); then
  echo "Missing packages: ${missing[*]}"
  if command -v pacman >/dev/null; then
    echo "  sudo pacman -S ${missing[*]}"
  elif command -v apt-get >/dev/null; then
    echo "  sudo apt install ${missing[*]}"
  elif command -v dnf >/dev/null; then
    echo "  sudo dnf install ${missing[*]}"
  fi
  echo
fi

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *)
    echo "Note: add $BIN_DIR to PATH (e.g. in ~/.bashrc):"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo
    ;;
esac

echo "Open the app launcher and search for «Kick», or run: kick-gui"
echo "CLI: kick <channel-or-url>"
