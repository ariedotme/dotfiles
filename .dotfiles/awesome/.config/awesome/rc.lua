-- libs
pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local wibox = require("wibox")
local naughty = require("naughty")

-- error handling
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    if in_error then return end
    in_error = true

    -- Use Dunst for error notifications
    awful.spawn.with_shell("notify-send 'AwesomeWM Error' '" .. tostring(err) .. "'")
    in_error = false
  end)
end

-- autostart
awful.spawn.with_shell("picom --config ~/.config/picom/picom.conf")
awful.spawn.with_shell("dunst")
awful.spawn.with_shell("feh --bg-scale ~/.config/wallpapers/wallpaper.png")

-- vars
terminal = "kitty"
modkey = "Mod4"
browser = "google-chrome-stable"
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- layouts
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.floating,
  awful.layout.suit.max,
}



-- workspace tags
local tags = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
awful.screen.connect_for_each_screen(function(s)
  -- Create workspace tags
  awful.tag(tags, s, awful.layout.suit.tile)
  -- Set gaps between windows
  for _, t in pairs(s.tags) do
    t.gap = 10
  end

  -- Widgets
  local clock = wibox.widget.textclock("%a %b %d, %H:%M:%S", 1)

  local taglist = awful.widget.taglist {
    screen          = s,
    filter          = awful.widget.taglist.filter.all,
    buttons         = gears.table.join(
      awful.button({}, 1, function(t) t:view_only() end),
      awful.button({ modkey }, 1, function(t)
        if client.focus then
          client.focus:move_to_tag(t)
        end
      end)
    ),
    widget_template = {
      {
        {
          {
            id = "text_role",
            widget = wibox.widget.textbox,
          },
          left = 4,
          right = 4,
          widget = wibox.container.margin,
        },
        id = "background_role",
        widget = wibox.container.background,
      },
      widget = wibox.container.margin,
    },
  }

  local tasklist = awful.widget.tasklist {
    screen          = s,
    filter          = function(c)
      return c == client.focus -- Show only the focused window
    end,
    buttons         = gears.table.join(
      awful.button({}, 1, function(c)
        if c == client.focus then
          c.minimized = true -- Minimize if already focused
        else
          c:emit_signal("request::activate", "tasklist", { raise = true })
        end
      end)
    ),
    style           = {
      shape = gears.shape.rounded_rect,
    },
    layout          = {
      layout = wibox.layout.fixed.horizontal
    },
    widget_template = {
      {
        {
          id = "text_role",
          widget = wibox.widget.textbox,
          align = "center",
          valign = "center"
        },
        widget = wibox.container.margin,
      },
      bg = "#00000000", -- Fully transparent background
      widget = wibox.container.background,
    },
  }

  -- Create and setup the bar (to be implemented below)
  s.mywibox = awful.wibar({ position = "top", screen = s, bg = "#00000000", })

  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      taglist,
    },
    {
      layout = wibox.container.place,
      halign = "center",
      valign = "center",
      tasklist,
    },
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      clock,
    },
  }
end)

-- keybindings
globalkeys = gears.table.join(

-- workspace navigation
  awful.key({ modkey }, "Tab", function() awful.tag.viewnext() end),
  awful.key({ modkey, "Shift" }, "Tab", function() awful.tag.viewprev() end),

  -- window navigation
  awful.key({ modkey }, "Right", function()
    awful.client.focus.bydirection("right")
  end, { description = "focus window to the right", group = "client" }),

  awful.key({ modkey }, "Left", function()
    awful.client.focus.bydirection("left")
  end, { description = "focus window to the left", group = "client" }),

  awful.key({ modkey }, "Down", function()
    awful.client.focus.bydirection("down")
  end, { description = "focus window below", group = "client" }),

  awful.key({ modkey }, "Up", function()
    awful.client.focus.bydirection("up")
  end, { description = "focus window above", group = "client" }),
  -- window move inside same tag
  awful.key({ modkey, "Shift" }, "Left", function()
    if client.focus then
      awful.client.swap.bydirection("left", client.focus)
    end
  end, { description = "move window left", group = "client" }),

  awful.key({ modkey, "Shift" }, "Right", function()
    if client.focus then
      awful.client.swap.bydirection("right", client.focus)
    end
  end, { description = "move window right", group = "client" }),

  awful.key({ modkey, "Shift" }, "Up", function()
    if client.focus then
      awful.client.swap.bydirection("up", client.focus)
    end
  end, { description = "move window up", group = "client" }),

  awful.key({ modkey, "Shift" }, "Down", function()
    if client.focus then
      awful.client.swap.bydirection("down", client.focus)
    end
  end, { description = "move window down", group = "client" }),
  -- toggle window maximized
  awful.key({ modkey }, "m", function()
    if client.focus then
      client.focus.maximized = not client.focus.maximized
      client.focus:raise()
    end
  end, { description = "toggle maximized", group = "client" }),

  -- launch terminal
  awful.key({ modkey }, "Return", function() awful.spawn(terminal) end),

  -- launch application runner
  awful.key({ modkey }, "d", function()
    awful.spawn("rofi -show drun")
  end),

  -- close window
  awful.key({ modkey }, "q", function()
    if client.focus then client.focus:kill() end
  end),

  -- reload awesome
  awful.key({ modkey, "Shift" }, "r", awesome.restart),
  -- open browser
  awful.key({ modkey }, "Space", function() awful.spawn(browser) end)
)

-- workspace shortcuts (Super + n)
for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
    -- view
    awful.key({ modkey }, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      { description = "view tag", group = "Tags" }),
    -- move
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      { description = "move focused client to tag", group = "Tags" }))
end

root.keys(globalkeys)

-- rules
awful.rules.rules = {
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = globalkeys,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
    }
  },
}

-- signals

-- Signals
client.connect_signal("manage", function(c)
  if not c.floating and awful.layout.get(c.screen) == awful.layout.suit.tile then
    c.shape = function(cr, width, height)
      gears.shape.rectangle(cr, width, height)
    end
  end

  if c.class == "Google-chrome" then
    c.floating = false
  end
end)

-- client.connect_signal("manage", function(c)
--   if awesome.startup
--       and not c.size_hints.user_position
--       and not c.size_hints.program_position then
--     awful.placement.no_offscreen(c)
--   end
-- end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
