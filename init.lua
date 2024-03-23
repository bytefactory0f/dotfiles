--===============================================================================
-- Vim settings
--===============================================================================
vim.opt.autoread = true    -- Autoread changes to files
vim.opt.number = true      -- Display line numbers
vim.opt.ruler = true
vim.opt.expandtab = true   -- Use spaces over tabs
vim.opt.smarttab = true    -- Indent according to shift width when pressing tab key
vim.opt.wrap = false       -- Don't wrap lines
vim.opt.autoindent = true  -- Copy indentation from previous line
vim.opt.cmdheight = 2      -- Height of the command bar
vim.opt.ignorecase = true  -- Ignore case when searching
vim.opt.incsearch = true   -- Search while entering characters
vim.opt.cursorline = true  -- Highlight current line
vim.opt.showmatch = true   -- Highlight matching brackets, parentheses, braces
vim.opt.swapfile = false   -- No swap files

vim.opt.wildignore = { '*.o', '*~', '*.pyc', '*.swp' }
vim.opt.listchars = { eol = '↵', trail = '⣿', space = '.', tab = '→ ', nbsp = '␣' }
vim.opt.list = true

-- No annoying sound on errors
vim.opt.belloff = 'all'

--===============================================================================
-- Indentation settings
--===============================================================================
vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = "lua",
        command = "setlocal tabstop=4 shiftwidth=4 softtabstop=0 expandtab"
    }
)

-- for js files, 2 spaces
vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = {"javascript", "javascriptreact", "typescript", "typescriptreact"},
        command = "setlocal tabstop=2 shiftwidth=2 softtabstop=0 expandtab"
    }
)

-- for groovy/gradle
vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = "gradle",
        command = "setlocal tabstop=2 shiftwidth=2 softtabstop=0 expandtab"
    }
)

-- for python files, 4 spaces
vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = "py",
        command = "setlocal tabstop=4 shiftwidth=4 softtabstop=0 expandtab"
    }
)

-- for bash files, 4 spaces
vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = "sh",
        command = "setlocal tabstop=4 shiftwidth=4 softtabstop=0 expandtab"
    }
)

-- for yaml files, 2 spaces
vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = { "yaml", "yml" },
        command = "setlocal tabstop=2 shiftwidth=2 softtabstop=0 expandtab"
    }
)

-- for go files, hard tab characters, with 4 space width
vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = "go",
        command = "setlocal tabstop=4 shiftwidth=4 softtabstop=0 noexpandtab"
    }
)


--===============================================================================
-- Plugins
--===============================================================================
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug 'morhetz/gruvbox'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-lua/plenary.nvim'
Plug('nvim-telescope/telescope.nvim', { tag = '0.1.0' })

-- Autocomplete
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'

vim.call('plug#end')

--===============================================================================
-- Side bar config
--===============================================================================
require("nvim-tree").setup({
  update_focused_file = {
    enable = true,
  },
  renderer = {
    icons = {
      show = {
        file = false,
        folder = false,
        folder_arrow = false,
      }
    }
  },
  view = {
    width = 50,
  },
})


--===============================================================================
-- Autocomplete config
--===============================================================================
local cmp = require("cmp")

cmp.setup({
    snippet = {
        expand = function(args)
           vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ['<Tab>'] = function(fallback)
                if cmp.visible() then
                        cmp.select_next_item()
                else
                        fallback()
                end
        end,
        ['<CR>'] = function(fallback)
                if cmp.visible() then
                        cmp.confirm()
                else
                        fallback()
                end
        end
    },

    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
    })
})


--===============================================================================
-- LSP config
--===============================================================================

local lspconfig = require("lspconfig")

-- Rust LSP config
lspconfig.rust_analyzer.setup {
    cmd = {
        "rustup", "run", "stable", "rust-analyzer",
    }
}

-- Go LSP config
lspconfig.gopls.setup{}

-- TypeScript LSP config
lspconfig.tsserver.setup {
    filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
    cmd = { "typescript-language-server", "--stdio" },
}

-- Python LSP config
lspconfig.pyright.setup{}

-- Bash LSP config
lspconfig.bashls.setup {
    filetypes = { "sh" },
    cmd = { "bash-language-server", "start" },
}



--===============================================================================
-- Key Bindings
--===============================================================================
vim.keymap.set('n', 'ff', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<C-p>', ':NvimTreeToggle<CR>') -- Toggles the file tree view
vim.keymap.set('n', '<C-e>', '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>') -- Show error diagnostics in window
vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', 'T', '<cmd>lua vim.lsp.buf.hover()<CR>')

--===============================================================================
-- Color Scheme
--===============================================================================
vim.cmd.colorscheme('gruvbox')

-- Change the color for the file browser
local gruvbox_blue_bold_color = vim.api.nvim_get_hl_by_name('GruvboxBlueBold', false)
local gruvbox_red_bold_color = vim.api.nvim_get_hl_by_name('GruvboxRedBold', false)

vim.api.nvim_set_hl(0, 'NvimTreeFolderName', { ctermfg = gruvbox_blue_bold_color["foreground"], bold = gruvbox_blue_bold_color["bold"] })
vim.api.nvim_set_hl(0, 'NvimTreeEmptyFolderName', { ctermfg = gruvbox_blue_bold_color["foreground"], bold = gruvbox_blue_bold_color["bold"] })
vim.api.nvim_set_hl(0, 'NvimTreeOpenedFolderName', { ctermfg = gruvbox_red_bold_color["foreground"], bold = gruvbox_red_bold_color["bold"] })
