local template_string_status, template_string = pcall(require, "template_string")

if not template_string_status then
	return
end

template_string.setup({
	filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "python" }, -- filetypes where the plugin is active
	jsx_brackets = true, -- must add brackets to jsx attributes
	remove_template_string = false, -- remove backticks when there are no template string
	restore_quotes = {
		-- quotes used when "remove_template_string" option is enabled
		normal = [[']],
		jsx = [["]],
	},
})
