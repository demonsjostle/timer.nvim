local popup_mod = require("timer.popup")

local M = {}

function M.start(duration_ms)
	local popup = popup_mod.TimerPopup()
	popup:countdown(duration_ms or 5000, 1000, function()
		vim.notify("⏰ Time's up!", vim.log.levels.INFO)
	end)
end

function M.setup()
	vim.keymap.set("n", "<leader>ut", function()
		local Input = require("nui.input")
		local ui = vim.api.nvim_list_uis()[1]
		local w, h = 30, 1

		local prompt = Input({
			position = { row = ui.height / 2 - h, col = ui.width / 2 - w / 2 },
			size = { width = w, height = h },
			border = { style = "rounded", text = { top = "[Timer seconds]" } },
		}, {
			prompt = "⏱️ ",
			default_value = "5",
			on_submit = function(input)
				local sec = tonumber(input)
				if sec and sec > 0 then
					M.start(sec * 1000)
				else
					vim.notify("⚠️ Invalid duration", vim.log.levels.WARN)
				end
			end,
			on_close = function() end,
		})

		prompt:mount()
	end, { desc = "⏱️ Start Timer (plugin)" })
end

return M
