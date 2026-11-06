-- Pin the mpv window to all Hyprland workspaces. `P` (shift+p) toggles; kick-pin=yes pins on start.
local function pin()
  mp.command_native_async({name = "subprocess", playback_only = false, args = {
    -- shortcut: Lua-config Hyprland (>=0.55) syntax only, add the legacy `dispatch pin pid:N` form if needed
    "hyprctl", "dispatch", ('hl.dsp.window.pin({ window = "pid:%d" })'):format(require("mp.utils").getpid())}})
end

mp.add_key_binding("P", "kick-pin", pin)

if mp.get_opt("kick-pin") == "yes" then
  local function on_vo(_, ready)
    if ready then mp.unobserve_property(on_vo); pin() end
  end
  mp.observe_property("vo-configured", "bool", on_vo)
end
