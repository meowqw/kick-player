# kick-player

Watch [Kick](https://kick.com) live streams and VODs in **mpv** — lighter and smoother than a browser.

- **Live** → [streamlink](https://streamlink.github.io/) → mpv  
- **VOD** → [yt-dlp](https://github.com/yt-dlp/yt-dlp) → mpv  
- Desktop app with recent history  
- Remembers VOD position (`save-position-on-quit`)
- Optional pin to all workspaces (Hyprland): `PIN=1` in `~/.config/kick/config`, `PIN=1 kick xqc`, toggle in the menu, or press `Shift+P` in the player

## Install

```bash
git clone https://github.com/meowqw/kick-player.git
cd kick-player
./install.sh
```

Dependencies: `mpv`, `yt-dlp`, `streamlink`.

```bash
# Arch / Omarchy
sudo pacman -S mpv yt-dlp streamlink

# Debian / Ubuntu
sudo apt install mpv yt-dlp streamlink
```

Optional GUI pickers: Omarchy menu (built-in on Omarchy) or `zenity`.

## Usage

**App launcher:** search for **Kick**

**CLI:**

```bash
kick xqc
kick https://kick.com/xqc
kick https://kick.com/maddyson/videos/<uuid>
QUALITY=720p60 kick xqc
kick-gui   # menu / prompt
```

Close VOD with `q` (or the window close button) to save resume position.

## Uninstall

```bash
./uninstall.sh
```

## Notes

- Kick VOD pages sometimes 404 in streamlink; VOD playback uses yt-dlp instead.  
- Live low-latency: uncomment `kick-low-latency` in `~/.config/streamlink/config`.  
- On Omarchy/Hyprland, mpv may get a floating window rule from the DE — resize with Super+Right Mouse or the window border.
