local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font("JetBrains Mono")
config.font_size = 15
config.adjust_window_size_when_changing_font_size = false

config.max_fps = 120
config.animation_fps = 120

config.window_decorations = "RESIZE"
config.color_scheme = "Gruvbox dark, hard (base16)"

config.default_prog = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe", "-NoLogo" }
config.default_cwd = "C:\\Users\\kawid"

config.window_background_opacity = 0.6
config.win32_system_backdrop = "Acrylic"

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- tab
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

config.tab_max_width = 20

local color_active_tab = "#fabd2f"
local color_inactive_tab = "#3c3836"
local text_color_active_tab = "#1d2021"
local text_color_inactive_tab = "#ebdbb2"

config.colors = {
	tab_bar = {
		background = "#282828",

		active_tab = {
			bg_color = color_active_tab,
			fg_color = text_color_active_tab,

			intensity = "Bold",
			underline = "None",
			italic = true,
			strikethrough = false,
		},

		inactive_tab = {
			bg_color = color_inactive_tab,
			fg_color = text_color_inactive_tab,
		},

		new_tab = {
			bg_color = color_inactive_tab,
			fg_color = text_color_inactive_tab,
		},
	},
}

local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab.tab_index + 1 .. ": " .. (tab.active_pane.title or "Terminal")

	local bg_color = tab.is_active and color_active_tab or color_inactive_tab
	local fg_color = tab.is_active and text_color_active_tab or text_color_inactive_tab

	if wezterm.column_width(title) > config.tab_max_width then
		local cropped_title = wezterm.truncate_right(title, config.tab_max_width - 6)
		title = cropped_title .. "..."
	end

	local next_tab = tabs[tab.tab_index + 2]
	local arrow_color = "#000000"

	if next_tab and next_tab.is_active then
		arrow_color = color_active_tab
	else
		arrow_color = color_inactive_tab
	end

	return {
		{ Background = { Color = bg_color } },
		{ Foreground = { Color = fg_color } },
		{ Text = " " .. title .. " " },
		{ Foreground = { Color = arrow_color } },
		{ Text = SOLID_LEFT_ARROW },
	}
end)

-- tmux
config.leader = { key = "ç", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	{
		mods = "CTRL",
		key = "/",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		mods = "LEADER",
		key = "c",
		action = wezterm.action.SpawnTab("DefaultDomain"),
	},
	{
		mods = "LEADER",
		key = "x",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		mods = "LEADER",
		key = "p",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		mods = "LEADER",
		key = "n",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		mods = "LEADER",
		key = "\\",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "-",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "h",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		mods = "LEADER",
		key = "j",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		mods = "LEADER",
		key = "k",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		mods = "LEADER",
		key = "l",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
}

for i = 1, 9 do
	-- leader + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i - 1),
	})
end

-- tmux status
wezterm.on("update-right-status", function(window, _)
	local SOLID_LEFT_ARROW = ""
	local ARROW_FOREGROUND = { Foreground = { Color = color_inactive_tab } }
	local prefix = ""

	if window:leader_is_active() then
		prefix = " " .. utf8.char(0x1f30a) -- ocean wave
		SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	end

	local active_tab = {
		tab_id = window:active_tab():tab_id(),
		tab_index = 0,
	}

	local tabs = window:mux_window():tabs()

	for i, tab in ipairs(tabs) do
		if tab:tab_id() == active_tab.tab_id then
			active_tab.tab_index = i
			break
		end
	end

	if active_tab.tab_index == 1 then
		ARROW_FOREGROUND = { Foreground = { Color = color_active_tab } }
	end

	window:set_left_status(wezterm.format({
		{ Background = { Color = "#458588" } },
		{ Text = prefix },
		ARROW_FOREGROUND,
		{ Text = SOLID_LEFT_ARROW },
	}))
end)

return config
