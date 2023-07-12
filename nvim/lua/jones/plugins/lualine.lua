local status, lualine = pcall(require, "lualine")
if not status then
	return
end

local colors = {
	bg = "#202328",
	fg = "#bbc2cf",
	yellow = "#ECBE7B",
	cyan = "#008080",
	darkblue = "#081633",
	green = "#98be65",
	orange = "#FF8800",
	violet = "#a9a1e1",
	magenta = "#c678dd",
	blue = "#51afef",
	red = "#ec5f67",
}

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
	mode_color = function()
		local mode_color = {
			n = colors.red,
			i = colors.green,
			v = colors.blue,
			[""] = colors.blue,
			V = colors.blue,
			c = colors.magenta,
			no = colors.red,
			s = colors.orange,
			S = colors.orange,
			[""] = colors.orange,
			ic = colors.yellow,
			R = colors.violet,
			Rv = colors.violet,
			cv = colors.red,
			ce = colors.red,
			r = colors.cyan,
			rm = colors.cyan,
			["r?"] = colors.cyan,
			["!"] = colors.red,
			t = colors.red,
		}
		return { fg = mode_color[vim.fn.mode()] }
	end,
}

local config = {
	options = {
		component_separators = "",
		section_separators = "",
		theme = "tokyonight",
		disabled_filetypes = {
			statusline = {
				"NvimTree",
				"packer",
			},
		},
	},
	sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		-- These will be filled later
		lualine_c = {},
		lualine_x = {},
	},
	inactive_sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
}
-- Inserts a component in lualine_c at left section
local function ins_left(component)
	table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

local function inact_ins_right(component)
	table.insert(config.inactive_sections.lualine_c, component)
end

ins_left({
	function()
		return "▊"
	end,
	color = conditions.mode_color,
	padding = { left = 0, right = 1 }, -- We don't need space before this
})

--[[ ins_left({
	function()
		return ""
	end,
	color = conditions.mode_color,
	padding = { right = 1 },
}) ]]

ins_left({
	"filename",
	cond = conditions.buffer_not_empty,
	padding = { left = 0, right = 0 },
	file_status = true,
	newfile_status = true,
	symbols = {
		modified = "",
		readonly = "",
		newfile = "",
	},
})

ins_left({
	function()
		return "%="
	end,
})

ins_left({
	"diagnostics",
	sources = { "nvim_diagnostic" },
	symbols = { error = " ", warn = " ", info = " " },
	diagnostics_color = {
		color_error = { fg = colors.red },
		color_warn = { fg = colors.yellow },
		color_info = { fg = colors.cyan },
	},
})

ins_right({
	"diff",
	symbols = { added = " ", modified = "󰝤 ", removed = " " },
	diff_color = {
		added = { fg = colors.green },
		modified = { fg = colors.orange },
		removed = { fg = colors.red },
	},
	padding = { left = 0, right = 0 },
	cond = conditions.hide_in_width,
})
ins_right({ "location" })
ins_right({
	"filetype",
	icons_enabled = true,
	icon_only = true,
	padding = { right = 1, left = 0 },
})

ins_right({
	function()
		return "▊"
	end,
	color = conditions.mode_color,
	padding = { left = 0 },
})

inact_ins_right({
	function()
		return "%="
	end,
})

inact_ins_right({
	"filetype",
	cond = conditions.buffer_not_empty,
	icon_only = true,
	padding = { left = 0, right = 0 },
})

inact_ins_right({
	"filename",
	cond = conditions.buffer_not_empty,
})

lualine.setup(config)
