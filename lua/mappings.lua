require "nvchad.mappings"
local M = {}

-- Define the function to run the shell command
local function GitDiffToClipboard()
  -- Detect the operating system
  local uname = vim.loop.os_uname().sysname

  -- Command based on the OS
  local copy_command
  if uname == "Darwin" then  -- macOS
    copy_command = "pbcopy"
  else  -- Assume Linux
    copy_command = "xclip -selection clipboard"
  end

  -- Run the appropriate shell command
  vim.cmd('silent ! (echo -e "Can you write me a conventional commit message for the below git diff, ensure it is in markdown and use the imperative, present tense. When generating commit message bodies, please wrap the text at 72 characters:\\n" && git diff --staged) | ' .. copy_command)
end

local function CopyLoclistDiagnosticsToClipboard()
  local bufnr = 0
  local diagnostics = vim.diagnostic.get(bufnr)
  if #diagnostics == 0 then
    print("No diagnostics in buffer.")
    return
  end

  local relpath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":.")

  local severity_map = {
    [vim.diagnostic.severity.ERROR] = "error",
    [vim.diagnostic.severity.WARN]  = "warning",
    [vim.diagnostic.severity.INFO]  = "info",
    [vim.diagnostic.severity.HINT]  = "hint",
  }

  table.sort(diagnostics, function(a, b)
    if a.lnum == b.lnum then
      return a.col < b.col
    end
    return a.lnum < b.lnum
  end)

  local lines = { "Here is the error:" }
  for _, d in ipairs(diagnostics) do
    local line = d.lnum + 1
    local col_start = d.col + 1
    local col_end = (d.end_col and d.end_col > d.col) and d.end_col or (d.col + 1)
    col_end = col_end + 1  -- Convert to 1-based index
    local severity = severity_map[d.severity] or "unknown"

    local msg = string.format(
      "%s|%d col %d-%d %s| %s",
      relpath, line, col_start, col_end, severity, d.message
    )
    table.insert(lines, msg)
  end

  local output = table.concat(lines, "\n")
  local uname = vim.loop.os_uname().sysname
  local copy_command = uname == "Darwin" and "pbcopy" or "xclip -selection clipboard"

  local handle = io.popen(copy_command, "w")
  if handle then
    handle:write(output)
    handle:close()
    print("Diagnostics copied to clipboard.")
  else
    print("Failed to copy diagnostics to clipboard.")
  end
end

M.incoming = {
  n = {
    ["<leader>gic"] = { function() vim.lsp.buf.incoming_calls() end, "Get incoming code calls" },
  },
}

M.outgoing = {
  n = {
    ["<leader>goc"] = { function() vim.lsp.buf.outgoing_calls() end, "Get outgoing code calls" },
  },
}
-- :lua vim.lsp.buf.outgoing_calls()
-- :lua vim.lsp.buf.incoming_calls()


M.gitdiff = {
  n = {
    -- The line below sets up the mapping for the custom Git diff command
    ["<leader>gdc"] = { GitDiffToClipboard, "Copy Git diff to clipboard" },
  },
}

M.diagnostic = {
  n = {
    ["<leader>cd"] = { CopyLoclistDiagnosticsToClipboard, "Copy diagnostic message to clipboard" },
  },
}

M.lazygit = {
  n = {
    -- The line below sets up the mapping for LazyGit
    ["<leader>gg"] = { "<cmd>LazyGit<CR>", "Open LazyGit" },
  },
}

M.lazydocker = {
  n = {
    -- The line below sets up the mapping for LazyDocker
    ["<leader>ld"] = { "<Cmd>lua LazyDocker.toggle()<CR>", "Open LazyDocker" },
  },
}

M.harpoon = {
  n = {
    ["<leader>A"] = { function() require("harpoon"):list():append() end, "Harpoon: Add file" },
    ["<leader>a"] = { function() local harpoon = require("harpoon") harpoon.ui:toggle_quick_menu(harpoon:list()) end, "Harpoon: Toggle quick menu" },
    ["<leader>1"] = { function() require("harpoon"):list():select(1) end, "Harpoon: Go to file 1" },
    ["<leader>2"] = { function() require("harpoon"):list():select(2) end, "Harpoon: Go to file 2" },
    ["<leader>3"] = { function() require("harpoon"):list():select(3) end, "Harpoon: Go to file 3" },
    ["<leader>4"] = { function() require("harpoon"):list():select(4) end, "Harpoon: Go to file 4" },
    ["<leader>5"] = { function() require("harpoon"):list():select(5) end, "Harpoon: Go to file 5" },
  },
}

-- GitHub Copilot mappings
M.copilot = {
  i = {
    ["<C-f>"] = {
      'copilot#Accept("<CR>")',
      "Accept Copilot Suggestion",
      opts = { replace_keycodes = false, nowait = true, silent = true, expr = true, noremap = true }
    },
    ["<M-]>"] = {
      "<Plug>(copilot-next)",
      "Next Copilot Suggestion",
      opts = { silent = true, noremap = true }
    },
    ["<M-[>"] = {
      "<Plug>(copilot-previous)",
      "Previous Copilot Suggestion",
      opts = { silent = true, noremap = true }
    },
    ["<C-]>"] = {
      "<Plug>(copilot-dismiss)",
      "Dismiss Copilot Suggestion",
      opts = { silent = true, noremap = true }
    },
  },
}

-- Neoclip mappings
M.neoclip = {
  n = {
    ["<leader>pr"] = { "<cmd>Telescope neoclip<CR>", "Open Neoclip" },
  },
}

-- Vim-tmux-navigator mappings
M.vimtmuxnavigator = {
  n = {
    ["<C-h>"] = { "<cmd>TmuxNavigateLeft<CR>", "Navigate Left" },
    ["<C-j>"] = { "<cmd>TmuxNavigateDown<CR>", "Navigate Down" },
    ["<C-k>"] = { "<cmd>TmuxNavigateUp<CR>", "Navigate Up" },
    ["<C-l>"] = { "<cmd>TmuxNavigateRight<CR>", "Navigate Right" },
    ["<C-\\>"] = { "<cmd>TmuxNavigatePrevious<CR>", "Navigate Previous" },
  },
}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add breakpoint at line"
    },
    ["<leader>dc"] = {
      "<cmd> DapContinue <CR>",
      "Continue"
    },
    ["<leader>do"] = {
      "<cmd> DapStepOver <CR>",
      "Step over"
    },
    ["<leader>di"] = {
      "<cmd> DapStepInto <CR>",
      "Step into"
    },
    ["<leader>ds"] = {
      "<cmd> DapStepOut <CR>",
      "Step out"
    },
    ["<leader>dr"] = {
      "<cmd> DapRestart <CR>",
      "Restart"
    },
    ["<leader>dx"] = {
      "<cmd> DapStop <CR>",
      "Stop"
    },
    ["<leader>dus"] = {
      function ()
        local widgets = require('dap.ui.widgets');
        local sidebar = widgets.sidebar(widgets.scopes);
        sidebar.open();
      end,
      "Open debugging sidebar"
    }
  }
}

M.dap_go = {
  plugin = true,
  n = {
    ["<leader>dgt"] = {
      function()
        require('dap-go').debug_test()
      end,
      "Debug go test"
    },
    ["<leader>dgl"] = {
      function()
        require('dap-go').debug_last()
      end,
      "Debug last go test"
    }
  }
}

M.dapui = {
  plugin = false,
  n = {
    ["<leader>dui"] = {
      function ()
        require('dapui').open()
      end,
      "Toggle DAP UI"
    }
  }
}

M.gopher = {
  plugin = true,
  n = {
    ["<leader>gsj"] = {
      "<cmd> GoTagAdd json <CR>",
      "Add json struct tags"
    },
    ["<leader>gsy"] = {
      "<cmd> GoTagAdd yaml <CR>",
      "Add yaml struct tags"
    }
  }
}

return M
