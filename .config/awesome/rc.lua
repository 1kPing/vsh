local awful = require("awful")

terminal = "alacritty"
file_manager = "terminal -e yazi"
editor = "terminal -e nvim"

modkey = "Mod4"

globalkeys = gears.table.join(

    awful.key({ modkey }, "Return", function () awful.spawn("terminal") end,
              {description = "open a terminal", group = "launcher"}),

    awful.key({ modkey }, "f", function () awful.spawn("file_manager") end,
              {description = "open file manager", group = "launcher"}),

    awful.key({ modkey }, "e", function () awful.spawn("editor") end,
              {description = "open file manager", group = "launcher"}),

    awful.key({ modkey }, "space", function () awful.spawn("rofi --show drun") end,
              {description = "run rofi", group = "launcher"})

    awful.key({ modkey }, "Escape", awesome.quit,
              {description = "exit awesome", group = "awesome"}),














)

root.keys(globalkeys)














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
