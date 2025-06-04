local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
}

beautiful.useless_gap = 0
awful.layout.set(awful.layout.suit.dwindle)
awful.layout.set(awful.layout.suit.tile)

client.connect_signal("manage", function(c)
    c.border_width = 0
    c.border_color = beautiful.border_normal
end)

beautiful.border_normal = "#ffffff77"
beautiful.border_focus = "#ffffffff"

awful.client.setmaster(1)

tags = {
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
    tags[s] = awful.tag(tags.names, s, tags.layout)
end

terminal = "alacritty"
file_manager = "terminal -e yazi"
editor = "terminal -e nvim"

modkey = "Mod4"

root.buttons(awful.util.table.join(
    awful.button({ modkey }, 1, function (c)
        c:activate { context = "mouse_click" }
        awful.mouse.client.move(c)
    end),

    awful.button({ modkey }, 3, function (c)
        c:activate { context = "mouse_click" }
        awful.mouse.client.resize(c)
    end)
))

globalkeys = gears.table.join(

    awful.key({ modkey }, "Return", function () awful.spawn("terminal") end,
              {description = "open a terminal", group = "launcher"}),

    awful.key({ modkey }, "f", function () awful.spawn("file_manager") end,
              {description = "open file manager", group = "launcher"}),

    awful.key({ modkey }, "e", function () awful.spawn("editor") end,
              {description = "open file manager", group = "launcher"}),

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

    for i = 1, 9 do
        awful.key({ modkey }, tostring(i), function () 
            local tag = awful.tag.gettags(1)[i] 
            if tag then 
                awful.tag.viewonly(tag) 
            end 
        end,
        {description = "switch to workspace " .. i, group = "tag"})
    end,

    for i = 1, 9 do
        awful.key({ modkey, "Shift" }, tostring(i), function () 
            local tag = awful.tag.gettags(1)[i] 
            if tag then 
                awful.client.movetotag(tag) 
            end 
        end,
        {description = "move window to workspace " .. i, group = "tag"})
    end,

    awful.key({ modkey }, "Escape", awesome.quit,
              {description = "exit awesome", group = "awesome"}),

    globalkeys,
    awful.key({ "Mod1" }, "f", function ()
        local c = client.focus
        if c then
            c.floating = not c.floating
        end
    end,
    {description = "toggle floating for the active window", group = "client"}),

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
        c:move_to_tag(tags[3])
    end
end)

export XDG_SESSION_TYPE=x11
export SDL_VIDEODRIVER=x11
export QT_QPA_PLATFORM=xcb
export XCURSOR_THEME=Bibata-Original-Classic
export XCURSOR_SIZE=16
export LIBVA_DRIVER_NAME=nvidia
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __GL_GSYNC_ALLOWED=1
export __GL_VRR_ALLOWED=0
