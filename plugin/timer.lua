if vim.fn.has("nvim-0.10") == 0 then
	vim.notify("timer.nvim requires Neovim >= 0.10", vim.log.levels.ERROR)
	return
end

local ok, timer = pcall(require, "timer")
if not ok then
	-- vim.api.nvim_err_writeln("Failed to load timer.nvim: " .. (timer or "unknown error"))
	return
end

timer.setup()
