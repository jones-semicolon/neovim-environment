local alternate_status, alternate = pcall(require, "alternate")

if not alternate_status then
	return
end

alternate.setup()
