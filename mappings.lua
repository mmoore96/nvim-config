local M = {}

M.lazygit = {
  n = {
    -- The line below sets up the mapping for LazyGit
    ["<leader>gg"] = { "<cmd>LazyGit<CR>", "Open LazyGit" },
  },
}

M.lazydocker = {
  n = {
    -- The line below sets up the mapping for LazyDocker
    ["<leader>ld"] = { "<cmd>LazyDocker<CR>", "Open LazyDocker" },
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
    ["<C-f>"] = { 'copilot#Accept("<CR>")', "Accept Copilot Suggestion", opts = { replace_keycodes = false, nowait = true, silent = true, expr = true, noremap = true } }
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
