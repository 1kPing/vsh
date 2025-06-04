terminal = "alacritty"
file_manager = "yazi"
editor = "nvim"



















awful.spawn.with_shell("hyprpaper &")
awful.spawn.with_shell("waybar &")
awful.spawn.with_shell("pipewire &")
awful.spawn.with_shell("pipewire-pulse &")
awful.spawn.with_shell("wireplumber &")
awful.spawn.with_shell("signal-desktop &")
awful.spawn.with_shell("alarm-clock-applet -h &")
awful.spawn.with_shell("eww daemon &")

awful.spawn.with_shell("librewolf --new-instance &")
client.connect_signal("manage", function (c)
    if c.class == "LibreWolf" then
        c:move_to_tag(tags[3])  -- Assuming tags[3] corresponds to workspace 3
    end
end)
