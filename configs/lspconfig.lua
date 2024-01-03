local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local util = require "lspconfig/util"

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

-- Update the path to the jdtls executable
local jdtls_path = 'path/to/jdt-language-server/bin/jdtls'

-- Setup for jdtls
lspconfig.jdtls.setup {
    cmd = {jdtls_path},
    root_dir = function(fname)
        return util.root_pattern(".git", "pom.xml", ".editorconfig", ".clang-format")(fname)
    end,
}

