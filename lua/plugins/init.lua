return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
    {
    "kdheepak/lazygit.nvim",
    lazy = false,
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "crnvl96/lazydocker.nvim",
    event = "VeryLazy",
    config = function()
      require("lazydocker").setup({
        window = {
          settings = {
            -- width = 2.618,
            -- height = 5.618,
            -- border = "rounded",
            -- relative = "editor",
          },
        },
      })
    end,
  },
  {
    "theprimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon"):setup()
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    require('telescope').setup({
      defaults = {
          layout_config = {
            prompt_position = 'bottom',
          },
          sorting_strategy = 'ascending',
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          live_grep = {
            additional_args = function()
              return grep_args
            end,
          },
          grep_string = {
            additional_args = function()
              return grep_args
            end,
          },
          buffers = {
            mappings = {
              n = {
                ['d'] = require('telescope.actions').delete_buffer,
              },
            },
          },
        },
        extensions = {
          fzf = {},
        },
      })
  },
   -- Copilot integration
  {
    "github/copilot.vim",
    lazy = false,
    init = function()  -- Mapping tab is already used by NvChad
      vim.g.copilot_no_tab_map = true;
      vim.g.copilot_assume_mapped = true;
      vim.g.copilot_tab_fallback = "";
      -- The mapping is set to other key, see custom/lua/mappings
      -- or run <leader>ch to see copilot mapping section
    end
  },
  {
  "AckslD/nvim-neoclip.lua",
  lazy = false,
  dependencies = {
    {'kkharji/sqlite.lua', module = 'sqlite'},
    {'nvim-telescope/telescope.nvim'},
  },
  config = function()
    require('neoclip').setup({
        history = 1000,
        enable_persistent_history = true,
        continuous_sync = true,
      })
  end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",
        "lua-language-server",
        "gofumpt",
        "goimports-reviser",
        "golines",
        "java-debug-adapter"
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      -- dap setup here (if any)
    end
  },
  { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    config = function()
      require "configs.dap"
    end
  },
  { "folke/neodev.nvim",
    opts = {},
    config = function()
      require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
      })
    end
  },
  {
    "dreamsofcode-io/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
      require("nvchad.utils").load_mappings("dap_go")
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "nvchad.configs.lspconfig"
      require "configs.lspconfig"
    end,
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
      require("nvchad.utils").load_mappings("gopher")
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
  {
    'mfussenegger/nvim-jdtls',
    dependencies = "mfussenegger/nvim-dap",
    ft = { "java" },
    config = function()
      -- require "configs.lspconfig"
      require "configs.java"
    end,
  },
  {
  "ray-x/lsp_signature.nvim",
  config = function()
    require("lsp_signature").setup()
  end,
  },
  -- {
  -- "nvim-telescope/telescope.nvim",
  -- opts = function(_, opts)
  --   opts.defaults.vimgrep_arguments = {
  --     "rg",
  --     "-L",
  --     "-w",               -- <- only match whole words
  --     "--color=never",
  --     "--no-heading",
  --     "--with-filename",
  --     "--line-number",
  --     "--column",
  --     "--smart-case",
  --   }
  -- end,
  -- },
  {
    'cameron-wags/rainbow_csv.nvim',
    config = true,
    ft = {
        'csv',
        'tsv',
        'csv_semicolon',
        'csv_whitespace',
        'csv_pipe',
        'rfc_csv',
        'rfc_semicolon'
    },
    cmd = {
        'RainbowDelim',
        'RainbowDelimSimple',
        'RainbowDelimQuoted',
        'RainbowMultiDelim'
    }
  },
  {
    "RaafatTurki/hex.nvim",
    lazy = false,
    config = function()
      require("hex").setup {
        dump_cmd = "xxd -g 1 -u",
        assemble_cmd = "xxd -r",

        -- Comment these out or return a proper boolean
        -- is_file_binary_pre_read = function() return true end,
        -- is_file_binary_post_read = function() return true end,
      }
    end,
  }
}

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
-- }
