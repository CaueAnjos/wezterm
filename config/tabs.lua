-- config/tabs.lua
local wezterm = require("wezterm")
local appearance = require("config.appearance")
local M = {}

function M.apply_config(config)
	-- Configurações básicas da barra de abas
	config.hide_tab_bar_if_only_one_tab = true
	config.tab_bar_at_bottom = true
	config.use_fancy_tab_bar = false
	config.tab_max_width = 20

	-- Configuração do formato de título das abas
	wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
		local title = tab.tab_index + 1 .. ": " .. (tab.active_pane.title or "Terminal")
		local colors = appearance.colors

		local bg_color = tab.is_active and colors.active_tab or colors.inactive_tab
		local fg_color = tab.is_active and colors.text_active_tab or colors.text_inactive_tab

		-- Truncar o título se exceder o tamanho máximo
		if wezterm.column_width(title) > config.tab_max_width then
			local cropped_title = wezterm.truncate_right(title, config.tab_max_width - 6)
			title = cropped_title .. "..."
		end

		local next_tab = tabs[tab.tab_index + 2]
		local arrow_color = next_tab and (next_tab.is_active and colors.active_tab or colors.inactive_tab)
			or colors.inactive_tab

		return {
			{ Background = { Color = bg_color } },
			{ Foreground = { Color = fg_color } },
			{ Text = " " .. title .. " " },
			{ Foreground = { Color = arrow_color } },
			{ Text = wezterm.nerdfonts.pl_right_hard_divider },
		}
	end)
end

return M
