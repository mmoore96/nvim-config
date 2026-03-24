require("dap-go").setup {
  -- Additional dap configurations can be added.
  -- dap_configurations accepts a list of tables where each entry
  -- represents a dap configuration. For more details do:
  -- :help dap-configuration
  dap_configurations = {
    {
      -- Must be "go" or it will be ignored by the plugin
      type = "go",
      name = "Attach remote",
      mode = "remote",
      request = "attach",
    },
  },
  -- delve configurations
  delve = {
    -- the path to the executable dlv which will be used for debugging.
    -- by default, this is the "dlv" executable on your PATH.
    path = "dlv",
    -- time to wait for delve to initialize the debug session.
    -- default to 20 seconds
    initialize_timeout_sec = 20,
    -- a string that defines the port to start delve debugger.
    -- default to string "${port}" which instructs nvim-dap
    -- to start the process in a random available port.
    -- if you set a port in your debug configuration, its value will be
    -- assigned dynamically.
    port = "${port}",
    -- additional args to pass to dlv
    args = {},
    -- the build flags that are passed to delve.
    -- defaults to empty string, but can be used to provide flags
    -- such as "-tags=unit" to make sure the test suite is
    -- compiled during debugging, for example.
    -- passing build flags using args is ineffective, as those are
    -- ignored by delve in dap mode.
    -- avaliable ui interactive function to prompt for arguments get_arguments
    build_flags = {},
    -- whether the dlv process to be created detached or not. there is
    -- an issue on delve versions < 1.24.0 for Windows where this needs to be
    -- set to false, otherwise the dlv server creation will fail.
    -- avaliable ui interactive function to prompt for build flags: get_build_flags
    detached = vim.fn.has "win32" == 0,
    -- the current working directory to run dlv from, if other than
    -- the current working directory.
    cwd = nil,
  },
  -- options related to running closest test
  tests = {
    -- enables verbosity when running the test.
    verbose = false,
  },
}
-- local dap_go = require "dap-go"
-- local dap = require "dap"
--
-- dap_go.setup()
-- -- For One
-- table.insert(dap.configurations.go, {
--   type = "delve",
--   name = "Debgug container",
--   mode = "remote",
--   request = "attach",
--   substitutePath = {
--     { from = "/opt/homebrew/Cellar/go/1.25.3/libexec", to = "/usr/local/go" },
--     { from = "${workspaceFolder}", to = "/path/in/container" },
--   },
-- })
--
-- -- -- For Two
-- -- table.insert(dap.configurations.go, {
-- --   type = "delvetwo",
-- --   name = "Two CONTAINER debugging",
-- --   mode = "remote",
-- --   request = "attach",
-- --   substitutePath = {
-- --     { from = "/opt/homebrew/Cellar/go/1.25.3/libexec", to = "/usr/local/go" },
-- --     { from = "${workspaceFolder}", to = "/path/in/contianer" },
-- --   },
-- -- })
--
-- -- adapters configuration
-- dap.adapters.delve = {
--   type = "server",
--   host = "127.0.0.1",
--   port = "2345",
-- }
-- --
-- -- dap.adapters.delvetwo = {
-- --   type = "server",
-- --   host = "127.0.0.1",
-- --   port = "2346",
-- -- }
--
-- -- dap_ui.setup {
-- --   layouts = {
-- --     {
-- --       elements = {
-- --         {
-- --           id = "scopes",
-- --           size = 0.35,
-- --         },
-- --         {
-- --           id = "breakpoints",
-- --           size = 0.30,
-- --         },
-- --         {
-- --           id = "repl",
-- --           size = 0.35,
-- --         },
-- --       },
-- --       position = "right",
-- --       size = 50,
-- --     },
-- --   },
-- -- }
