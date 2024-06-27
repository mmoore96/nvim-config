-- https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration for more guide.
local dap = require "dap"
dap.adapters.java = function(callback)
  -- FIXME:
  -- Here a function needs to trigger the `vscode.java.startDebugSession` LSP command
  -- The response to the command must be the `port` used below
  callback({
    type = 'server';
    host = 'localhost';
    port = 5005;
  })
end
dap.configurations.java = {
  {
    name = "Launch Java",
    javaExec = "java",
    request = "launch",
    type = "java",
  },
  {
    type = 'java',
    request = 'attach',
    name = "Debug (Attach) - Remote",
    projectName= "Titanium",
    hostName = "localhost",
    port = 5005,
  },
}
