-- ==============================
-- Lazy.nvim bootstrap
-- ==============================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- ==============================
  -- Иконки
  -- ==============================
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup { default = true }
    end
  },

  -- ==============================
  -- Telescope
  -- ==============================
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-tree/nvim-web-devicons"
    },
    build = "make",
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/" },
        },
        extensions = { fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true } },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")

      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<space>ff", builtin.find_files, { desc = "Поиск файлов" })
      vim.keymap.set("n", "<space>fg", builtin.live_grep, { desc = "Поиск по содержимому" })
      vim.keymap.set("n", "<space>ft", function()
        telescope.extensions.file_browser.file_browser({
          path = vim.fn.expand("%:p:h"),
          respect_gitignore = false,
          hidden = true,
          grouped = true,
        })
      end, { desc = "Файловый менеджер" })
    end,
  },

  -- ==============================
  -- Tree-sitter
  -- ==============================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "java", "lua", "bash", "json", "vim", "regex" },
        highlight = { enable = true },
      })
    end
  },

  -- ==============================
  -- Тема TokyoNight
  -- ==============================
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd[[colorscheme tokyonight]]
    end
  },

  -- ==============================
  -- LSP и автодополнение
  -- ==============================
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", build = ":MasonUpdate" },
  { "williamboman/mason-lspconfig.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

})

-- ==============================
-- Нумерация
-- ==============================
vim.opt.number = true
vim.opt.relativenumber = true

-- ==============================
-- Мягкая подсветка строки
-- ==============================
vim.opt.cursorline = true
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2c2c2c" })

-- ==============================
-- Настройка nvim-cmp
-- ==============================
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  })
})

-- ==============================
-- Настройка LSP
-- ==============================
local lspconfig = require("lspconfig")

-- Для Java
lspconfig.jdtls.setup{}

-- Горячие клавиши для LSP
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Перейти к определению" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Показать документацию" })
