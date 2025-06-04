local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
}

beautiful.useless_gap = 0
awful.layout.set(awful.layout.suit.dwindle)

beautiful.border_normal = "#ffffff77"
beautiful.border_focus = "#ffffffff"

client.connect_signal("manage", function(c)
    c.border_width = 0  -- Change to a positive value if you want borders
    c.border_color = beautiful.border_normal
end)

awful.client.setmaster(1)

local tags = {
    names = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    layout = { 
        awful.layout.suit.tile, 
        awful.layout.suit.tile, 
        awful.layout.suit.tile, 
        awful.layout.suit.tile, 
        awful.layout.suit.tile, 
        awful.layout.suit.tile, 
        awful.layout.suit.tile, 
        awful.layout.suit.tile, 
        awful.layout.suit.tile 
    }
}

for s = 1, screen.count() do
    awful.tag(tags.names, s, tags.layout)
end

local terminal = "alacritty"
local file_manager = "terminal -e yazi"
local editor = "terminal -e nvim"

local modkey = "Mod4"

globalkeys = gears.table.join(

    awful.key({ modkey }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),

    awful.key({ modkey }, "f", function () awful.spawn(file_manager) end,
              {description = "open file manager", group = "launcher"}),

    awful.key({ modkey }, "e", function () awful.spawn(editor) end,
              {description = "open text editor", group = "launcher"}),

    awful.key({ modkey }, "space", function () awful.spawn("rofi --show drun") end,
              {description = "run rofi", group = "launcher"}),

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

    awful.key({ "Mod1" }, "g", function ()
        awful.spawn("galculator", { floating = true })
    end,
    {description = "open galculator as floating", group = "launcher"}),

    awful.key({ modkey }, "Print", function () 
        awful.spawn("scrot") 
    end,
    {description = "take a screenshot", group = "launcher"}),

    awful.key({ modkey }, "\\", function () 
        awful.spawn("i3lock") 
    end,
    {description = "lock screen", group = "awesome"}),

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

    awful.key({ modkey }, "Down", function () awful.client.focus.bydirection("down") end,
              {description = "focus window below", group = "client"}),

    awful.key({ modkey }, "Up", function () awful.client.focus.bydirection("up") end,
              {description = "focus window above", group = "client"}),

    awful.key({ modkey }, "Left", function () awful.client.focus.bydirection("left") end,
              {description = "focus window to the left", group = "client"}),

    awful.key({ modkey }, "Right", function () awful.client.focus.bydirection("right") end,
              {description = "focus window to the right", group = "client"}),

    awful.key({ modkey }, "j", function () awful.client.focus.bydirection("down") end,
              {description = "focus window below", group = "client"}),

    awful.key({ modkey }, "k", function () awful.client.focus.bydirection("up") end,
              {description = "focus window above", group = "client"}),

    awful.key({ modkey }, "h", function () awful.client.focus.bydirection("left") end,
              {description = "focus window to the left", group = "client"}),

    awful.key({ modkey }, "l", function () awful.client.focus.bydirection("right") end,
              {description = "focus window to the right", group = "client"}),

    awful.key({ modkey }, "Escape", awesome.quit,
              {description = "exit awesome", group = "awesome"}),

    awful.key({ modkey }, "c", function () 
        local c = client.focus
        if c then c:kill() end 
    end,
    {description = "kill active window", group = "client"}),

    awful.key({ modkey }, "f", function ()
        local c = client.focus
        if c then
            c.floating = not c.floating
        end
    end,
    {description = "toggle floating for the active window", group = "client"})
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
        if tags[3] then  -- Check if tags[3] exists
            c:move_to_tag(tags[3])
        end
    end
end)

