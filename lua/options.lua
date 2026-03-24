require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
vim.opt.scrolloff = 2
vim.opt.sidescrolloff = 1
local o = vim.o
vim.opt.relativenumber = true
o.expandtab = true
o.smartindent = true
o.tabstop = 2
o.shiftwidth = 2
vim.opt.clipboard = "unnamedplus"
vim.opt.fileformat = "unix" -- always write LF endings
vim.opt.fixendofline = true -- ensure newline at EOF
-- vim.api.nvim_create_autocmd("TermOpen", {
--   pattern = "*",
--   callback = function()
--     local bufname = vim.api.nvim_buf_get_name(0)
--     if bufname:match "lazydocker" then
--       vim.wo.number = false
--       vim.wo.relativenumber = false
--     end
--   end,
-- })
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save = vim.fn.winsaveview()
    -- Remove trailing whitespace
    vim.cmd [[%s/\s\+$//e]]
    -- Remove carriage return characters
    vim.cmd [[%s/\r//ge]]
    vim.fn.winrestview(save)
  end,
})
-- Strip CRLF when pasting from Windows clipboard
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.cmd [[:silent! %s/\r//ge]]
  end,
})
vim.api.nvim_set_keymap("n", "<leader>fj", ":!google-java-format -i %<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
  "n",
  "<leader>Fj",
  ':!find . -name "*.java" -exec google-java-format -i {} + && echo "Formatted all Java files."<CR>',
  { noremap = true, silent = false }
)
vim.keymap.set("v", "<leader>fj", function()
  local start = vim.fn.line "'<"
  local finish = vim.fn.line "'>"
  vim.cmd(
    string.format(
      "!google-java-format --skip-sorting-imports --skip-removing-unused-imports -i --lines %d:%d %%",
      start,
      finish
    )
  )
end, { desc = "Format selected Java lines (in-place)" })

vim.diagnostic.config {
  virtual_text = true,
}
-- vim.g.mkdp_browser = vim.env.BROWSER
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)

    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
