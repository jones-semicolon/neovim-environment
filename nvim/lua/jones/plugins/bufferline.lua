local buffline_status, buffline = pcall(require, "bufferline")

if not buffline_status then
	return
end

buffline.setup()
