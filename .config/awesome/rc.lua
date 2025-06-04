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

    awful.key({ modkey }, "s", function () awful.spawn("librewolf") end,
              {description = "open librewolf", group = "launcher"}),

    awful.key({ modkey }, "d", function () awful.spawn("flatpak run com.discordapp.Discord") end,
              {description = "open discord in flatpak", group = "launcher"}),

    awful.key({ modkey }, "g", function () awful.spawn("github") end,
              {description = "open github desktop app", group = "launcher"}),

    awful.key({ modkey }, "p", function () awful.spawn("prismlauncher") end,
              {description = "open prismlauncher", group = "launcher"}),

    awful.key({ modkey }, "b", function () awful.spawn("terminal -e btop") end,
              {description = "open btop in terminal", group = "launcher"}),

    awful.key({ modkey }, "a", function () awful.spawn("alarm-clock-applet -s") end,
              {description = "stop alarms", group = "launcher"}),

    awful.key({ modkey }, "F1", function () 
        awful.spawn("pkill librewolf") 
    end,
    {description = "kill all librewolf instances", group = "client"}),

    awful.key({ modkey }, "F2", function () 
        awful.spawn("pkill Discord") 
    end,
    {description = "kill all discord instances", group = "client"}),

    awful.key({ modkey }, "F3", function () 
        awful.spawn("pkill steam") 
    end,
    {description = "kill all steam instances", group = "client"}),















    awful.key({ modkey }, "Escape", awesome.quit,
              {description = "exit awesome", group = "awesome"}),

    awful.key({ modkey }, "c", function () 
        local c = client.focus
        if c then c:kill() end 
    end,
    {description = "kill active window", group = "client"}),













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
