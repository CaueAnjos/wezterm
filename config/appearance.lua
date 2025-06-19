-- config/appearance.lua
local wezterm = require("wezterm")
local M = {}

-- Definição de cores que serão compartilhadas
M.colors = {
	active_tab = "#fabd2f",
	inactive_tab = "#3c3836",
	text_active_tab = "#1d2021",
	text_inactive_tab = "#ebdbb2",
	background = "#282828",
	status_accent = "#458588",
}

function M.apply_config(config)
	-- Configurações de aparência da janela
	config.window_decorations = "RESIZE"
	config.color_scheme = "Catppuccin Mocha"
	config.window_background_opacity = 0.6
	config.win32_system_backdrop = "Acrylic"

	-- Configuração de cores específicas
	config.colors = {
		tab_bar = {
			background = M.colors.background,

			active_tab = {
				bg_color = M.colors.active_tab,
				fg_color = M.colors.text_active_tab,
				intensity = "Bold",
				underline = "None",
				italic = true,
				strikethrough = false,
			},

			inactive_tab = {
				bg_color = M.colors.inactive_tab,
				fg_color = M.colors.text_inactive_tab,
			},

			new_tab = {
				bg_color = M.colors.inactive_tab,
				fg_color = M.colors.text_inactive_tab,
			},
		},
	}
end

return M
