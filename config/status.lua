-- config/status.lua
local wezterm = require("wezterm")
local appearance = require("config.appearance")
local M = {}

function M.setup()
	-- Configura o status da direita (modo tmux)
	wezterm.on("update-right-status", function(window, _)
		local colors = appearance.colors
		local DIVISER = ""
		local prefix = ""

		-- Mostra indicador quando leader estiver ativo
		if window:leader_is_active() then
			prefix = " " .. utf8.char(0x1f30a)
			DIVISER = utf8.char(0xe0b6)
		end

		window:set_right_status(wezterm.format({
			{ Background = { Color = colors.background } },
			{ Foreground = { Color = colors.status_accent } },
			{ Text = DIVISER },
			{ Background = { Color = colors.status_accent } },
			{ Foreground = { Color = colors.background } },
			{ Text = prefix },
		}))
	end)
end

return M
