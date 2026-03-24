require "nvchad.mappings"
-- ===============================
--   Mappings (Framework-Free)
-- ===============================

-- Utility functions -----------------------------
local function GitDiffToClipboard()
  local uname = vim.loop.os_uname().sysname
  local copy_command = (uname == "Darwin") and "pbcopy" or "xclip -selection clipboard"

  vim.cmd(
    'silent ! (echo -e "Can you write me a conventional commit message for the below git diff, ensure it is in markdown and use the imperative, present tense. When generating commit message bodies, please wrap the text at 72 characters:\\n" && git diff --staged) | '
      .. copy_command
  )
end

local function CopyLoclistDiagnosticsToClipboard()
  local bufnr = 0
  local diagnostics = vim.diagnostic.get(bufnr)
  if #diagnostics == 0 then
    print "No diagnostics in buffer."
    return
  end

  local relpath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":.")
  local severity_map = {
    [vim.diagnostic.severity.ERROR] = "error",
    [vim.diagnostic.severity.WARN] = "warning",
    [vim.diagnostic.severity.INFO] = "info",
    [vim.diagnostic.severity.HINT] = "hint",
  }

  table.sort(diagnostics, function(a, b)
    if a.lnum == b.lnum then
      return a.col < b.col
    end
    return a.lnum < b.lnum
  end)

  local lines = { "Here is the error:" }
  for _, d in ipairs(diagnostics) do
    local msg = string.format(
      "%s|%d col %d-%d %s| %s",
      relpath,
      d.lnum + 1,
      d.col + 1,
      ((d.end_col and d.end_col > d.col) and d.end_col or (d.col + 1)) + 1,
      severity_map[d.severity] or "unknown",
      d.message
    )
    table.insert(lines, msg)
  end

  local output = table.concat(lines, "\n")
  local uname = vim.loop.os_uname().sysname
  local copy_command = (uname == "Darwin") and "pbcopy" or "xclip -selection clipboard"

  local handle = io.popen(copy_command, "w")
  if handle then
    handle:write(output)
    handle:close()
    print "Diagnostics copied to clipboard."
  else
    print "Failed to copy diagnostics to clipboard."
  end
end

-- ==========================================================
--  🔹 LSP + Code Navigation
-- ==========================================================
vim.keymap.set("n", "<leader>gic", function()
  vim.lsp.buf.incoming_calls()
end, { desc = "Get incoming code calls" })
vim.keymap.set("n", "<leader>goc", function()
  vim.lsp.buf.outgoing_calls()
end, { desc = "Get outgoing code calls" })

vim.keymap.set("n", "<Leader>*", '<Cmd>lua require("telescope.builtin").grep_string()<CR>')

-- --- Standard LSP keymaps (NvChad legacy equivalents) ---
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover documentation" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>f", function()
  vim.lsp.buf.format { async = true }
end, { desc = "Format buffer" })

-- --- Diagnostics navigation ---
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, { desc = "Show diagnostic float" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic list" })

-- ==========================================================
--  🔹 Git, LazyGit, and Docker
-- ==========================================================
vim.keymap.set("n", "<leader>gdc", GitDiffToClipboard, { desc = "Copy Git diff to clipboard" })
vim.keymap.set("n", "<leader>cd", CopyLoclistDiagnosticsToClipboard, { desc = "Copy diagnostics to clipboard" })
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Open LazyGit" })
vim.keymap.set("n", "<leader>ld", "<cmd>lua LazyDocker.toggle()<CR>", { desc = "Open LazyDocker" })

-- ==========================================================
--  🔹 Harpoon
-- ==========================================================
vim.keymap.set("n", "<leader>A", function()
  require("harpoon"):list():append()
end, { desc = "Harpoon: Add file" })
vim.keymap.set("n", "<leader>a", function()
  local harpoon = require "harpoon"
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon: Toggle quick menu" })

for i = 1, 5 do
  vim.keymap.set("n", "<leader>" .. i, function()
    require("harpoon"):list():select(i)
  end, { desc = "Harpoon: Go to file " .. i })
end

-- ==========================================================
--  🔹 GitHub Copilot
-- ==========================================================
vim.keymap.set("i", "<C-f>", 'copilot#Accept("<CR>")', {
  desc = "Accept Copilot Suggestion",
  replace_keycodes = false,
  nowait = true,
  silent = true,
  expr = true,
  noremap = true,
})
vim.keymap.set("i", "<M-]>", "<Plug>(copilot-next)", { desc = "Next Copilot Suggestion", silent = true })
vim.keymap.set("i", "<M-[>", "<Plug>(copilot-previous)", { desc = "Previous Copilot Suggestion", silent = true })
vim.keymap.set("i", "<C-]>", "<Plug>(copilot-dismiss)", { desc = "Dismiss Copilot Suggestion", silent = true })

-- ==========================================================
--  🔹 Neoclip
-- ==========================================================
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope neoclip<CR>", { desc = "Open Neoclip" })

-- ==========================================================
--  🔹 Vim-Tmux-Navigator
-- ==========================================================
vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Navigate Left" })
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Navigate Down" })
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Navigate Up" })
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Navigate Right" })
vim.keymap.set("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>", { desc = "Navigate Previous" })

-- ==========================================================
--  🔹 DAP (Debugger)
-- ==========================================================
vim.keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Add breakpoint" })
vim.keymap.set("n", "<leader>dc", "<cmd>DapContinue<CR>", { desc = "Continue" })
vim.keymap.set("n", "<leader>do", "<cmd>DapStepOver<CR>", { desc = "Step over" })
vim.keymap.set("n", "<leader>di", "<cmd>DapStepInto<CR>", { desc = "Step into" })
vim.keymap.set("n", "<leader>ds", "<cmd>DapStepOut<CR>", { desc = "Step out" })
vim.keymap.set("n", "<leader>dr", "<cmd>DapRestart<CR>", { desc = "Restart" })
vim.keymap.set("n", "<leader>dx", "<cmd>DapStop<CR>", { desc = "Stop" })
vim.keymap.set("n", "<leader>dus", function()
  local widgets = require "dap.ui.widgets"
  widgets.sidebar(widgets.scopes).open()
end, { desc = "Open debugging sidebar" })

-- ==========================================================
--  🔹 DAP-Go
-- ==========================================================
vim.keymap.set("n", "<leader>dgt", function()
  require("dap-go").debug_test()
end, { desc = "Debug Go test" })
vim.keymap.set("n", "<leader>dgl", function()
  require("dap-go").debug_last()
end, { desc = "Debug last Go test" })

-- ==========================================================
--  🔹 DAP-UI
-- ==========================================================
vim.keymap.set("n", "<leader>dui", function()
  require("dapui").open()
end, { desc = "Toggle DAP UI" })

-- ==========================================================
--  🔹 Gopher
-- ==========================================================
vim.keymap.set("n", "<leader>gsj", "<cmd>GoTagAdd json<CR>", { desc = "Add json struct tags" })
vim.keymap.set("n", "<leader>gsy", "<cmd>GoTagAdd yaml<CR>", { desc = "Add yaml struct tags" })

-- ==========================================================
-- 🔹 LLM Chat (Large Language Model Chat)
-- ==========================================================
-- Chat commands
vim.keymap.set({ "n", "i" }, "<C-g>c", "<cmd>GpChatNew<cr>", { desc = "New Chat" })
vim.keymap.set({ "n", "i" }, "<C-g>t", "<cmd>GpChatToggle<cr>", { desc = "Toggle Chat" })
vim.keymap.set({ "n", "i" }, "<C-g>f", "<cmd>GpChatFinder<cr>", { desc = "Chat Finder" })

vim.keymap.set("v", "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", { desc = "Visual Chat New" })
vim.keymap.set("v", "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", { desc = "Visual Chat Paste" })
vim.keymap.set("v", "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", { desc = "Visual Toggle Chat" })

vim.keymap.set({ "n", "i" }, "<C-g><C-x>", "<cmd>GpChatNew split<cr>", { desc = "New Chat split" })
vim.keymap.set({ "n", "i" }, "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", { desc = "New Chat vsplit" })
vim.keymap.set({ "n", "i" }, "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", { desc = "New Chat tabnew" })

vim.keymap.set("v", "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>", { desc = "Visual Chat New split" })
vim.keymap.set("v", "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", { desc = "Visual Chat New vsplit" })
vim.keymap.set("v", "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", { desc = "Visual Chat New tabnew" })

-- Prompt commands
vim.keymap.set({ "n", "i" }, "<C-g>r", "<cmd>GpRewrite<cr>", { desc = "Inline Rewrite" })
vim.keymap.set({ "n", "i" }, "<C-g>a", "<cmd>GpAppend<cr>", { desc = "Append (after)" })
vim.keymap.set({ "n", "i" }, "<C-g>b", "<cmd>GpPrepend<cr>", { desc = "Prepend (before)" })
vim.keymap.set({ "n", "i" }, "<C-g>dc", "<cmd>GpCommit<cr>", { desc = "Generate commit message based off git diff" })

vim.keymap.set("v", "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", { desc = "Visual Rewrite" })
vim.keymap.set("v", "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", { desc = "Visual Append (after)" })
vim.keymap.set("v", "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", { desc = "Visual Prepend (before)" })
vim.keymap.set("v", "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", { desc = "Implement selection" })

vim.keymap.set({ "n", "i" }, "<C-g>gp", "<cmd>GpPopup<cr>", { desc = "Popup" })
vim.keymap.set({ "n", "i" }, "<C-g>ge", "<cmd>GpEnew<cr>", { desc = "GpEnew" })
vim.keymap.set({ "n", "i" }, "<C-g>gn", "<cmd>GpNew<cr>", { desc = "GpNew" })
vim.keymap.set({ "n", "i" }, "<C-g>gv", "<cmd>GpVnew<cr>", { desc = "GpVnew" })
vim.keymap.set({ "n", "i" }, "<C-g>gt", "<cmd>GpTabnew<cr>", { desc = "GpTabnew" })

vim.keymap.set("v", "<C-g>gp", ":<C-u>'<,'>GpPopup<cr>", { desc = "Visual Popup" })
vim.keymap.set("v", "<C-g>ge", ":<C-u>'<,'>GpEnew<cr>", { desc = "Visual GpEnew" })
vim.keymap.set("v", "<C-g>gn", ":<C-u>'<,'>GpNew<cr>", { desc = "Visual GpNew" })
vim.keymap.set("v", "<C-g>gv", ":<C-u>'<,'>GpVnew<cr>", { desc = "Visual GpVnew" })
vim.keymap.set("v", "<C-g>gt", ":<C-u>'<,'>GpTabnew<cr>", { desc = "Visual GpTabnew" })

vim.keymap.set({ "n", "i" }, "<C-g>x", "<cmd>GpContext<cr>", { desc = "Toggle Context" })
vim.keymap.set("v", "<C-g>x", ":<C-u>'<,'>GpContext<cr>", { desc = "Visual Toggle Context" })

vim.keymap.set({ "n", "i", "v", "x" }, "<C-g>s", "<cmd>GpStop<cr>", { desc = "Stop" })
vim.keymap.set({ "n", "i", "v", "x" }, "<C-g>n", "<cmd>GpNextAgent<cr>", { desc = "Next Agent" })
vim.keymap.set({ "n", "i", "v", "x" }, "<C-g>l", "<cmd>GpSelectAgent<cr>", { desc = "Select Agent" })

-- ==========================================================
-- 🔹 Whisper commands (prefix <C-g>w)
-- ==========================================================

vim.keymap.set({ "n", "i" }, "<C-g>ww", "<cmd>GpWhisper<cr>", { desc = "Whisper" })
vim.keymap.set("v", "<C-g>ww", ":<C-u>'<,'>GpWhisper<cr>", { desc = "Visual Whisper" })

vim.keymap.set({ "n", "i" }, "<C-g>wr", "<cmd>GpWhisperRewrite<cr>", { desc = "Whisper Inline Rewrite" })
vim.keymap.set({ "n", "i" }, "<C-g>wa", "<cmd>GpWhisperAppend<cr>", { desc = "Whisper Append (after)" })
vim.keymap.set({ "n", "i" }, "<C-g>wb", "<cmd>GpWhisperPrepend<cr>", { desc = "Whisper Prepend (before)" })

vim.keymap.set("v", "<C-g>wr", ":<C-u>'<,'>GpWhisperRewrite<cr>", { desc = "Visual Whisper Rewrite" })
vim.keymap.set("v", "<C-g>wa", ":<C-u>'<,'>GpWhisperAppend<cr>", { desc = "Visual Whisper Append (after)" })
vim.keymap.set("v", "<C-g>wb", ":<C-u>'<,'>GpWhisperPrepend<cr>", { desc = "Visual Whisper Prepend (before)" })

vim.keymap.set({ "n", "i" }, "<C-g>wp", "<cmd>GpWhisperPopup<cr>", { desc = "Whisper Popup" })
vim.keymap.set({ "n", "i" }, "<C-g>we", "<cmd>GpWhisperEnew<cr>", { desc = "Whisper Enew" })
vim.keymap.set({ "n", "i" }, "<C-g>wn", "<cmd>GpWhisperNew<cr>", { desc = "Whisper New" })
vim.keymap.set({ "n", "i" }, "<C-g>wv", "<cmd>GpWhisperVnew<cr>", { desc = "Whisper Vnew" })
vim.keymap.set({ "n", "i" }, "<C-g>wt", "<cmd>GpWhisperTabnew<cr>", { desc = "Whisper Tabnew" })

vim.keymap.set("v", "<C-g>wp", ":<C-u>'<,'>GpWhisperPopup<cr>", { desc = "Visual Whisper Popup" })
vim.keymap.set("v", "<C-g>we", ":<C-u>'<,'>GpWhisperEnew<cr>", { desc = "Visual Whisper Enew" })
vim.keymap.set("v", "<C-g>wn", ":<C-u>'<,'>GpWhisperNew<cr>", { desc = "Visual Whisper New" })
vim.keymap.set("v", "<C-g>wv", ":<C-u>'<,'>GpWhisperVnew<cr>", { desc = "Visual Whisper Vnew" })
vim.keymap.set("v", "<C-g>wt", ":<C-u>'<,'>GpWhisperTabnew<cr>", { desc = "Visual Whisper Tabnew" })

--Git commands--
--git blame line (non toggle)
vim.keymap.set("n", "<leader>gb", "<cmd>GitBlameLine<CR>", { desc = "Git Blame Line" })
--git blame toggle
vim.keymap.set("n", "<leader>gB", "<cmd>GitBlameToggle<CR>", { desc = "Git Blame Toggle" })
