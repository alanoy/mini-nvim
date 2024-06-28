local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "echasnovski/mini.nvim", version = "*" },
	{ "nvim-treesitter/nvim-treesitter" },
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = "nvim-tree/nvim-web-devicons",
		version = "*",
		lazy = false,
	},
	{
		"ethanholz/nvim-lastplace",
		event = "BufRead",
		config = function()
			require("nvim-lastplace").setup({
				lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
				lastplace_ignore_filetype = {
					"gitcommit",
					"gitrebase",
					"svn",
					"hgcommit",
				},
				lastplace_open_folds = true,
			})
		end,
	},
})

-- Set up 'mini.deps' (customize to your liking)
require("mini.deps").setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
	vim.g.mapleader = ","
	vim.o.shiftwidth = 2
	vim.o.tabstop = 2
	vim.o.colorcolumn = "100"
	vim.o.linespace = 10
	vim.o.backup = false
	vim.o.number = true
	vim.o.relativenumber = true
	vim.o.laststatus = 2
	vim.o.background = "dark"
	vim.o.list = true
	vim.o.listchars = table.concat({
		"tab:│ ",
		"extends:…",
		"nbsp:␣",
		"precedes:…",
	}, ",")
	vim.o.autoindent = true
	vim.o.expandtab = true
	vim.o.scrolloff = 10
	vim.o.clipboard = "unnamed,unnamedplus"
	vim.o.foldmethod = "expr"
	vim.o.foldexpr = "nvim_treesitter#foldexpr()"
	vim.o.foldcolumn = "1"
	vim.o.foldlevel = 999
	vim.o.foldlevelstart = 999
	vim.o.foldenable = true
	vim.opt.iskeyword:append("-")
	vim.opt.complete:append("kspell")

	vim.cmd("filetype plugin indent on")
	vim.cmd("colorscheme catppuccin-mocha")

	vim.api.nvim_create_autocmd({ "BufWritePre" }, {
		pattern = { "*" },
		command = [[%s/\s\+$//e]],
	})

	-- key mappings
	local nmap_leader = function(suffix, rhs, desc)
		vim.keymap.set("n", "<Leader>" .. suffix, rhs, { desc = desc })
	end

	local xmap_leader = function(suffix, rhs, desc)
		vim.keymap.set("x", "<Leader>" .. suffix, rhs, { desc = desc })
	end

	nmap_leader("e", "<Cmd>NvimTreeToggle<CR>", "Toggle NvimTree")
	nmap_leader("h", "<Cmd>nohlsearch<CR>", "No highlight search")
	nmap_leader("w", "<Cmd>w<CR>", "Save")
	nmap_leader("q", "<Cmd>q<CR>", "Quit")
	nmap_leader("bd", "<Cmd>bd<CR>", "Close buffer")
	nmap_leader("p", "<Cmd>Lazy<CR>", "Lazy")

	-- With and without LSP
	if vim.tbl_isempty(vim.lsp.buf_get_clients()) then
		vim.keymap.set("n", "<leader>bf", function()
			vim.lsp.buf.format()
		end, { noremap = true, silent = true, desc = "Format Buffer" })
	else
		vim.keymap.set("n", "<leader>bf", "gg=G<C-o>", { noremap = true, silent = true, desc = "Format Buffer" })
	end
end)

now(function()
	require("nvim-tree").setup()
end)

now(function()
	require("mini.sessions").setup({
		autowrite = true,
	})
end)

now(function()
	require("mini.starter").setup()
end)

later(function()
	require("mini.ai").setup()
end)

later(function()
	require("mini.align").setup()
end)

later(function()
	require("mini.basics").setup({
		options = {
			basic = true,
			extra_ui = true,
			win_borders = "bold",
		},
		mappings = {
			basic = true,
			windows = true,
		},
		autocommands = {
			basic = true,
			relnum_in_visual_mode = true,
		},
	})
end)

later(function()
	require("mini.bracketed").setup()
end)

later(function()
	require("mini.bufremove").setup()
end)

later(function()
	local miniclue = require("mini.clue")
	miniclue.setup({
		triggers = {
			-- Leader triggers
			{ mode = "n", keys = "<Leader>" },
			{ mode = "x", keys = "<Leader>" },

			-- Built-in completion
			{ mode = "i", keys = "<C-x>" },

			-- `g` key
			{ mode = "n", keys = "g" },
			{ mode = "x", keys = "g" },

			-- Marks
			{ mode = "n", keys = "'" },
			{ mode = "n", keys = "`" },
			{ mode = "x", keys = "'" },
			{ mode = "x", keys = "`" },

			-- Registers
			{ mode = "n", keys = '"' },
			{ mode = "x", keys = '"' },
			{ mode = "i", keys = "<C-r>" },
			{ mode = "c", keys = "<C-r>" },

			-- Window commands
			{ mode = "n", keys = "<C-w>" },

			-- `z` key
			{ mode = "n", keys = "z" },
			{ mode = "x", keys = "z" },
		},

		clues = {
			-- Enhance this by adding descriptions for <Leader> mapping groups
			{ mode = "n", keys = "<Leader>b", desc = "Buffer" },
			{ mode = "n", keys = "<Leader>p", desc = "Lazy" },
			miniclue.gen_clues.g(),
			miniclue.gen_clues.builtin_completion(),
			miniclue.gen_clues.marks(),
			miniclue.gen_clues.registers(),
			miniclue.gen_clues.windows(),
			miniclue.gen_clues.z(),
		},

		window = {
			delay = 300,
		},
	})
end)

later(function()
	require("mini.comment").setup()
end)

later(function()
	require("mini.completion").setup({
		mappings = {
			go_in = "<RET>",
		},
		window = {
			info = { border = "rounded" },
			signature = { border = "rounded" },
		},
	})
end)

later(function()
	require("mini.cursorword").setup()
end)

later(function()
	require("mini.diff").setup({
		view = {
			style = "sign",
			signs = { add = "█", change = "▒", delete = "" },
		},
	})
end)

later(function()
	require("mini.extra").setup()
end)

later(function()
	require("mini.indentscope").setup({
		draw = {
			animation = function()
				return 1
			end,
			delay = 100,
		},
		symbol = "│",
	})
end)

later(function()
	require("mini.jump").setup()
end)

later(function()
	require("mini.jump2d").setup()
end)

later(function()
	require("mini.pairs").setup()
end)

later(function()
	require("mini.splitjoin").setup()
end)

later(function()
	require("mini.surround").setup()
end)

later(function()
	require("mini.tabline").setup()
end)

later(function()
	require("mini.visits").setup()
end)

later(function()
	require("mini.statusline").setup({
		use_icons = true,
	})
end)
