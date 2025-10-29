local dapui = require("dapui")
		dapui.setup({
			icons = {
				expanded = "▾",
				collapsed = "▸",
			},
			mappings = {
				-- Use a table to apply multiple mappings
				expand = { "<CR>", "<2-LeftMouse>" },
				open = "o",
				remove = "d",
				edit = "e",
				repl = "r",
			},
			layouts = {
				{
					elements = { -- Elements can be strings or table with id and size keys.
						{
							id = "scopes",
							size = 0.25,
						},
						"breakpoints",
						"stacks",
						"watches",
					},
					size = 40,
					position = "left",
				},
				{
					elements = { "repl", "console" },
					size = 10,
					position = "bottom",
				},
			},
			floating = {
				max_height = nil, -- These can be integers or a float between 0 and 1.
				max_width = nil, -- Floats will be treated as percentage of your screen.
				border = "single", -- Border style. Can be "single", "double" or "rounded"
				mappings = {
					close = { "q", "<Esc>" },
				},
			},
			windows = {
				indent = 1,
			},
			controls = {
				enabled = true,
				-- Display controls in this element
				element = "repl",
				icons = {
					pause = "⏸︎",
					play = "⏵︎",
					step_into = "↓",
					step_over = "⤼",
					step_out = "↑",
					step_back = "←",
					run_last = "↻",
					terminate = "⏹︎",
				},
			},
		})
		local dap = require("dap")

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
    require "configs.java-debug"
dap.adapters.go = {
  type = "executable",
  command = "dlv",
  args = { "dap" },
}

dap.configurations.go = {
  {
    type = "go",
    name = "Debug Main",
    request = "launch",
    program = "${workspaceFolder}/cmd/api-server",  -- your main package
  },
  {
    type = "go",
    name = "Debug Current File",
    request = "launch",
    program = "${file}",  -- this lets you run any file directly
  },
  {
    type = "go",
    name = "Attach to Remote",
    mode = "remote",
    request = "attach",
    connect = {
      host = "127.0.0.1", -- or remote IP if not using port forwarding
      port = 4000
    },
    cwd = "${workspaceFolder}", -- ensure source files are accessible
  },
}
