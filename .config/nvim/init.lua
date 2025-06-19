vim.o.background = "dark"
vim.opt.number = true
vim.opt.relativenumber = true
vim.cmd("highlight Normal ctermbg=NONE guibg=#000000b3")
vim.cmd("set shiftwidth=4 smarttab")
vim.cmd("set expandtab")
vim.cmd("set tabstop=8 softtabstop=0")
vim.cmd("set noswapfile")
vim.cmd("set laststatus=0")
function ToggleBottomBar()
    if vim.opt.laststatus:get() == 0 then
        vim.opt.laststatus = 2
    else
        vim.opt.laststatus = 0
    end
end
vim.api.nvim_set_keymap('n', '<A-b>', ':lua ToggleBottomBar()<CR>', { noremap = true, silent = true })

