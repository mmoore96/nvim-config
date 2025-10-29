local o = vim.o
vim.opt.relativenumber = true
o.expandtab = true
o.smartindent = true
o.tabstop = 2
o.shiftwidth = 2
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname:match("lazydocker") then
      vim.wo.number = false
      vim.wo.relativenumber = false
    end
  end,
})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save = vim.fn.winsaveview()
    -- Remove trailing whitespace
    vim.cmd([[%s/\s\+$//e]])
    -- Remove carriage return characters
    vim.cmd([[%s/\r//ge]])
    vim.fn.winrestview(save)
  end,
})
vim.api.nvim_set_keymap('n', '<leader>fj', ':!google-java-format -i %<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>Fj', ':!find . -name "*.java" -exec google-java-format -i {} + && echo "Formatted all Java files."<CR>', { noremap = true, silent = false })
