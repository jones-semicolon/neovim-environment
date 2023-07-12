-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness
local config = { noremap = true, silent = true }

---------------------
-- General Keymaps
---------------------

-- clear search highlights
keymap.set("n", "<ESC>", ":nohl<CR>", config)

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<C-Up>", "<C-a>") -- increment
keymap.set("n", "<C-Down>-", "<C-x>") -- decrement
keymap.set("v", "<C-c>", '"+y')
keymap.set("n", "<C-c>c", '"+yy')
keymap.set("", "<C-p>", '"+p')

-- window management
keymap.set("n", "<leader>s", "<C-w>s") -- split window horizontally

----------------------
-- Plugin Keybinds
----------------------
keymap.set("n", "<leader>w", ":w<CR>", config)
keymap.set("n", "<leader>q", ":q<CR>", config)

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", config) -- toggle file explorer

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags

-- telescope git commands (not on youtube nvim video)
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>") -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>") -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>") -- list current changes per file with diff preview ["gs" for git status]
keymap.set("n", "<leader>fr", "<cmd>Telescope registers<cr>")

-- restart lsp server (not on youtube nvim video)
keymap.set("n", "<leader>rs", ":LspRestart<CR>") -- mapping to restart lsp if necessary

-- bufferline
keymap.set("n", "<leader>,", "<Cmd>BufferLineCyclePrev<CR>", config)
keymap.set("n", "<leader>.", "<Cmd>BufferLineCycleNext<CR>", config)
keymap.set("n", "<leader><", "<Cmd>BufferLineMovePrev<CR>", config)
keymap.set("n", "<leader>>", "<Cmd>BufferLineMoveNext<CR>", config)
keymap.set("n", "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", config)
keymap.set("n", "<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>", config)
keymap.set("n", "<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>", config)
keymap.set("n", "<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>", config)
keymap.set("n", "<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>", config)
keymap.set("n", "<leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>", config)
keymap.set("n", "<leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>", config)
keymap.set("n", "<leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>", config)
keymap.set("n", "<leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>", config)
keymap.set("n", "<leader>p", "<Cmd>BufferLineTogglePin<CR>", config)
keymap.set("n", "<leader>c", "<Cmd>bdelete<CR>", config)
keymap.set("n", "<leader>\\", "<Cmd>BufferLinePick<CR>", config)

-- Move Text
local opts = { noremap = true, silent = true }
-- Normal-mode commands
keymap.set("n", "<A-j>", ":MoveLine(1)<CR>", opts)
keymap.set("n", "<A-k>", ":MoveLine(-1)<CR>", opts)
keymap.set("n", "<A-h>", ":MoveHChar(-1)<CR>", opts)
keymap.set("n", "<A-l>", ":MoveHChar(1)<CR>", opts)
keymap.set("n", "<leader>wf", ":MoveWord(1)<CR>", opts)
keymap.set("n", "<leader>wb", ":MoveWord(-1)<CR>", opts)

-- Visual-mode commands
keymap.set("v", "<A-j>", ":MoveBlock(1)<CR>", opts)
keymap.set("v", "<A-k>", ":MoveBlock(-1)<CR>", opts)
keymap.set("v", "<A-h>", ":MoveHBlock(-1)<CR>", opts)
keymap.set("v", "<A-l>", ":MoveHBlock(1)<CR>", opts)
