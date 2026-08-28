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
            { "<C-b>",      "<cmd>Telescope buffers<CR>" },
            { "<leader>fg", "<cmd>Telescope live_grep<CR>" },
            { "<leader>fb", "<cmd>Telescope buffers<CR>" },
            { "<leader>fh", "<cmd>Telescope help_tags<CR>" },
        },
        config = function()
            local actions = require("telescope.actions")
            require("telescope").setup({
                defaults = {
                    mappings = {
                        -- <C-j>/<C-k> = move down/up the result list
                        -- <C-s> = open selection in a horizontal split
                        -- (applied in both insert and normal mode inside the prompt)
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-s>"] = actions.select_horizontal,
                        },
                        n = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-s>"] = actions.select_horizontal,
                        },
                    },
                },
            })
        end,
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
        -- The default branch ("main") is a full, incompatible rewrite that removed
        -- nvim-treesitter.configs. Pin "master" to keep the legacy API below.
        branch = "master",
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

    -- Generate Go tests from source (:GoTests)
    { "buoto/gotests-vim", ft = "go" },

    -- Go debugging via Delve (vimscript port of nvim-dap workflow)
    { "sebdah/vim-delve", ft = "go" },

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
