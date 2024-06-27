local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local util = require "lspconfig/util"
local dap = require('dap')

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

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {"gopls"},
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    staticcheck = true,
    },
  },
}

-- Setup for Markdown LSP
lspconfig.marksman.setup {}

-- Update the path to the jdtls executable
-- local jdtls_path = '/home/linuxbrew/.linuxbrew/bin/jdtls'
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
--   callback({
--     type = 'server';
--     host = '127.0.0.1';
--     port = 5005;
--   })
-- end
--   dap.configurations.java = {
--     {
--       type = 'java';
--       request = 'attach';
--       name = "Debug (Attach) - Remote";
--       hostName = "127.0.0.1";
--       port = 5005;
--     },
--   }
-- -- Setup for jdtls
-- lspconfig.jdtls.setup {
--     cmd = {jdtls_path},
--     root_dir = function(fname)
--         return util.root_pattern(".git", "pom.xml", ".editorconfig", ".clang-format")(fname)
--     end,
--     -- on_attach = require('jdtls').setup_dap({ hotcodereplace = 'auto' }),
--     ininit_options = {
--     -- bundles = {},
--     bundles = bundles,
--   },
-- }
-- Setup for TypeScript LSP
require'lspconfig'.tsserver.setup {}

-- Setup for C# LSP
local omnisharp_bin = '/path/to/omnisharp/OmniSharp.dll'

require'lspconfig'.omnisharp.setup {
    cmd = { "dotnet", omnisharp_bin },
    root_dir = lspconfig.util.root_pattern(".sln", ".csproj", ".git"),

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
}
