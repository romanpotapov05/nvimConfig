-----------------------------------------------------------
-- БАЗОВЫЕ НАСТРОЙКИ
-----------------------------------------------------------
vim.g.mapleader = ' '

vim.o.number = true           -- обычная нумерация
vim.o.relativenumber = true   -- относительная нумерация
vim.o.cursorline = true       -- подсветка текущей строки
vim.o.termguicolors = true    -- true-color
vim.o.background = "light"    -- светлая тема

-----------------------------------------------------------
-- УСТАНОВКА lazy.nvim
-----------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------
-- ПЛАГИНЫ
-----------------------------------------------------------
require("lazy").setup({
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- File browser для Telescope
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },

  -- Подсветка синтаксиса и интеграция с Telescope через treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  -- Everforest colorscheme
  {
    "sainnhe/everforest",
  },
})

-----------------------------------------------------------
-- TELESCOPE
-----------------------------------------------------------
local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<Esc>"] = actions.close,
      },
    },
  },
  extensions = {
    file_browser = {
      theme = "dropdown",
      hijack_netrw = true,
      grouped = true,
      hidden = true,
      respect_gitignore = true,
    },
  },
})

telescope.load_extension("file_browser")

-----------------------------------------------------------
-- TREE-SITTER (подсветка, в т.ч. Java)
-----------------------------------------------------------
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua",
    "python",
    "c",
    "cpp",
    "javascript",
    "typescript",
    "html",
    "css",
    "bash",
    "java",       -- вот тут добавили Java
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})

-----------------------------------------------------------
-- Everforest оформление (light, medium)
-----------------------------------------------------------
-- Настройки темы нужно задать до colorscheme
vim.g.everforest_background = "medium"          -- soft / medium / hard
vim.g.everforest_better_performance = 1
vim.g.everforest_transparent_background = 0     -- 1 если хочешь прозрачный фон

vim.cmd("colorscheme everforest")

-----------------------------------------------------------
-- КЛАВИШИ ДЛЯ TELESCOPE
-----------------------------------------------------------
local builtin = require("telescope.builtin")

-- <Space>ff — поиск файла по имени
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope: find files" })

-- <Space>fg — поиск по содержимому файлов
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope: live grep" })

-- <Space>ft — файловый браузер (псевдо-дерево)
vim.keymap.set("n", "<leader>ft", function()
  telescope.extensions.file_browser.file_browser({
    path = "%:p:h",
    cwd = vim.loop.cwd(),
    initial_mode = "normal",
    grouped = true,
    hidden = true,
    respect_gitignore = true,
  })
end, { desc = "Telescope: file browser" })

-- <Space>fs — структура текущего файла через treesitter
vim.keymap.set("n", "<leader>fs", builtin.treesitter, { desc = "Telescope: treesitter symbols" })

-----------------------------------------------------------
-- КАЧЕСТВО ЖИЗНИ
-----------------------------------------------------------
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
