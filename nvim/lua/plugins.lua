-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Colorscheme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({ flavour = "mocha" })
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = { theme = "catppuccin" },
            })
        end,
    },

    -- Fuzzy finder (replaces fzf.vim)
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<C-p>",      "<cmd>Telescope find_files<CR>" },
            { "<leader>fg", "<cmd>Telescope live_grep<CR>" },
            { "<leader>fb", "<cmd>Telescope buffers<CR>" },
            { "<leader>fh", "<cmd>Telescope help_tags<CR>" },
        },
    },

    -- File tree (replaces NERDTree)
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = { { "<leader>e", "<cmd>NvimTreeToggle<CR>" } },
        config = function()
            require("nvim-tree").setup()
        end,
    },

    -- Treesitter (syntax highlighting)
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua", "python", "typescript", "javascript", "go",
                    "yaml", "json", "bash", "markdown", "dockerfile",
                },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- Git signs in gutter
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },

    -- Auto-pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },

    -- Comment toggling
    {
        "numToStr/Comment.nvim",
        keys = { { "gcc", mode = "n" }, { "gc", mode = "v" } },
        config = true,
    },

    -- Tmux navigation
    { "christoomey/vim-tmux-navigator" },

    -- Which-key (keybinding hints)
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = true,
    },

    -- Copilot
    {
        "github/copilot.vim",
        event = "InsertEnter",
    },

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            require("ibl").setup()
        end,
    },
}, {
    -- lazy.nvim options
    install = { colorscheme = { "catppuccin" } },
    checker = { enabled = false },
})
