local status, _ = pcall(vim.cmd, "colorscheme tokyonight")
if not status then
	print("Colorscheme not found!") -- print error if colorscheme not installed
	return
end
vim.cmd([[
  augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
  augroup END
]])
