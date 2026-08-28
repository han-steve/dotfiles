local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.termguicolors = true
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 8
opt.undofile = true
opt.swapfile = false
opt.wrap = false
opt.cursorline = true
opt.cmdheight = 1
opt.showmode = false

-- 2-space YAML indentation (prevents un-indenting on carriage return)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "yaml",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
    end,
})
