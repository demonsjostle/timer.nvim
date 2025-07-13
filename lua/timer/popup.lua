local has_nui, Popup = pcall(require, "nui.popup")
if not has_nui then
	vim.notify("Please install 'nui.nvim' to use timer UI", vim.log.levels.ERROR)
	return {}
end

local TimerPopup = Popup:extend("TimerPopup")
vim.api.nvim_set_hl(0, "TimerPopup", { fg = "#FFD700", bg = "#333333" })

function TimerPopup:init(opts)
	TimerPopup.super.init(
		self,
		vim.tbl_deep_extend("force", {
			position = { row = 0, col = "100%" },
			size = { width = 12, height = 1 },
			border = { style = "rounded" },
			win_options = {
				winblend = 10,
				winhighlight = "Normal:TimerPopup,FloatBorder:TimerPopup",
			},
		}, opts or {})
	)
end

local function seconds_to_hms(sec)
	local h = math.floor(sec / 3600)
	sec = sec % 3600
	local m = math.floor(sec / 60)
	local s = sec % 60
	return string.format("%02d:%02d:%02d", h, m, s)
end

function TimerPopup:countdown(ms, step, on_finish)
	self:mount()
	local rem = ms
	local win = self.winid

	local function tick()
		vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, {
			"⏳ " .. seconds_to_hms(math.ceil(rem / 1000)),
		})
		vim.fn.win_execute(win, "redraw")
		rem = rem - step
		if rem >= 0 then
			vim.defer_fn(tick, step)
		else
			self:unmount()
			if on_finish then
				on_finish()
			end
		end
	end

	tick()
end

return {
	TimerPopup = TimerPopup,
}
