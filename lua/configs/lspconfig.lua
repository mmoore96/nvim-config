local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- `vim.lsp.config` is not a module; no need to assign it like before
-- Replace lspconfig.*.setup with vim.lsp.enable("server", {...})
local dap = require "dap"

-- Determine OS
local home = os.getenv "HOME"
if vim.fn.has "mac" == 1 then
  WORKSPACE_PATH = home .. "/workspace/"
  CONFIG = "mac"
elseif vim.fn.has "unix" == 1 then
  WORKSPACE_PATH = home .. "/workspace/"
  CONFIG = "linux"
else
  print "Unsupported system"
end

vim.lsp.enable("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = vim.fs.root(0, { "go.work", "go.mod", ".git" }),
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      formatTool = "goimports",
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
})
--
-- Auto format Go files on save using gopls (no null-ls)
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.go",
  callback = function()
    local file = vim.fn.expand "%:p"
    if string.find(file, "/vendor/") or string.find(file, "/api/") then
      return
    end
    vim.fn.jobstart({ "goimports", "-w", file }, {
      on_exit = function()
        vim.cmd "edit!"
      end,
    })
  end,
})

-- Setup for Markdown LSP
vim.lsp.enable "marksman"

-- Update the path to the jdtls executable
-- local jdtls_path = "/home/linuxbrew/.linuxbrew/bin/jdtls"
-- local bundles = {
--   vim.fn.glob(
--     home .. "/.config/nvim/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
--   ),
-- }
-- -- vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/.config/nvim/vscode-java-test/server/*.jar"), "\n"))
-- dap.adapters.java = function(callback)
--   -- FIXME:
--   -- Here a function needs to trigger the `vscode.java.startDebugSession` LSP command
--   -- The response to the command must be the `port` used below
--   callback {
--     type = "server",
--     host = "127.0.0.1",
--     port = require("dap.utils").pick_unused_port(),
--   }
-- end
-- dap.configurations.java = {
--   {
--     type = "java",
--     request = "attach",
--     name = "Debug (Attach) - Remote",
--     hostName = "127.0.0.1",
--     port = 5005,
--   },
-- }
-- -- Setup for jdtls
-- vim.lsp.enable("jdtls", {
--   cmd = { jdtls_path },
--   root_dir = vim.fs.root(0, { "build.gradle", "pom.xml", ".editorconfig", ".clang-format" }),
--   -- on_attach = require("jdtls").setup_dap { hotcodereplace = "auto" },
--   init_options = {
--     -- bundles = {},
--     bundles = bundles,
--   },
-- })

-- Setup for TypeScript LSP
vim.lsp.enable "ts_ls"

-- Setup for C# LSP
local omnisharp_bin = "/path/to/omnisharp/OmniSharp.dll"

vim.lsp.enable("omnisharp", {
  cmd = { "dotnet", omnisharp_bin },
  root_dir = vim.fs.root(0, { ".sln", ".csproj", ".git" }),

  -- Enables support for reading code style, naming convention and analyzer
  -- settings from .editorconfig.
  enable_editorconfig_support = true,

  -- If true, MSBuild project system will only load projects for files that
  -- were opened in the editor. This setting is useful for big C# codebases
  -- and allows for faster initialization of code navigation features only
  -- for projects that are relevant to code that is being edited. With this
  -- setting enabled OmniSharp may load fewer projects and may thus display
  -- incomplete reference lists for symbols.
  enable_ms_build_load_projects_on_demand = false,

  -- Enables support for roslyn analyzers, code fixes and rulesets.
  enable_roslyn_analyzers = false,

  -- Specifies whether 'using' directives should be grouped and sorted during
  -- document formatting.
  organize_imports_on_format = false,

  -- Enables support for showing unimported types and unimported extension
  -- methods in completion lists. When committed, the appropriate using
  -- directive will be added at the top of the current file. This option can
  -- have a negative impact on initial completion responsiveness,
  -- particularly for the first few completion sessions after opening a
  -- solution.
  enable_import_completion = false,

  -- Specifies whether to include preview versions of the .NET SDK when
  -- determining which version to use for project loading.
  sdk_include_prereleases = true,

  -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
  -- true
  analyze_open_documents_only = false,
})
