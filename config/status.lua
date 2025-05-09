-- config/status.lua
local wezterm = require("wezterm")
local appearance = require("config.appearance")
local M = {}

function M.setup()
	-- Configura o status da direita (modo tmux)
	wezterm.on("update-right-status", function(window, _)
		local colors = appearance.colors
		local SOLID_LEFT_ARROW = ""
		local ARROW_FOREGROUND = { Foreground = { Color = colors.inactive_tab } }
		local prefix = ""

		-- Mostra indicador quando leader estiver ativo
		if window:leader_is_active() then
			prefix = " " .. utf8.char(0x1f30a) -- ícone de onda do oceano
			SOLID_LEFT_ARROW = utf8.char(0xe0b2)
		end

		-- Identifica a aba ativa
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

		-- Ajusta a cor da seta se for a primeira aba
		if active_tab.tab_index == 1 then
			ARROW_FOREGROUND = { Foreground = { Color = colors.active_tab } }
		end

		-- Define o status da esquerda
		window:set_left_status(wezterm.format({
			{ Background = { Color = colors.status_accent } },
			{ Text = prefix },
			ARROW_FOREGROUND,
			{ Text = SOLID_LEFT_ARROW },
		}))
	end)
end

return M
