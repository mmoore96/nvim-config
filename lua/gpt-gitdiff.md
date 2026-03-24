-- custom/lua/plugins.lua (or wherever your NvChad lazy specs live)

return {
  -- ... your other plugins ...

  {
    "robitx/gp.nvim",
    lazy = false,
    config = function()
      local gp = require("gp")

      -- Your full conventional commit spec (kept as a reusable string).
      -- This will live in the chat as the "system prompt" so you can keep
      -- asking follow-ups and it remembers the rules + prior messages.
      local COMMIT_SYSTEM_PROMPT = [[
You are my Git commit assistant.

When I ask for a commit message, generate it according to these rules:

# Conventional Commit Rules

## Header
<type>(<scope>): <summary>

- type: build|ci|docs|feat|fix|perf|refactor|style|release|test (lowercase)
- scope: one word, lowercase, no spaces
- summary:
  - imperative, present tense
  - lowercase (unless proper noun/acronym)
  - <= 72 chars
  - no trailing period

## Body
- explain why the change was made
- contrast before vs after
- technical, professional tone
- wrap all lines at 72 chars

## Output
When asked for a commit message, output ONLY the commit message.
No explanation or commentary.
]]

      -- Helper: open a persistent chat session, seed it with a user message,
      -- and get the assistant response. You can keep chatting in that same
      -- buffer afterwards and it will remember context.
      local function open_chat_and_respond(seed_text)
        -- Create a chat buffer using the system prompt (stateful session)
        -- This uses gp.nvim's chat mode rather than a one-off prompt.
        gp.cmd.ChatNew({}, COMMIT_SYSTEM_PROMPT)

        -- Put the seed text into the chat buffer as the "user" message
        vim.api.nvim_put(vim.split(seed_text, "\n"), "l", true, true)

        -- Trigger the assistant response for the chat buffer
        vim.cmd("GpChatRespond")
      end

      gp.setup({
        providers = {
          -- Example provider setup (you are using Copilot in your snippet)
          copilot = {
            disable = false,
            endpoint = "https://api.githubcopilot.com/chat/completions",
            secret = {
              "bash",
              "-c",
              "cat ~/.config/github-copilot/apps.json | sed -e 's/.*oauth_token...//;s/\".*//'",
            },
          },
          openai = {
            disable = true,
            endpoint = "https://api.openai.com/v1/chat/completions",
          },
          azure = {
            disable = true,
            endpoint = "https://$URL.openai.azure.com/openai/deployments/{{model}}/chat/completions",
            secret = os.getenv("AZURE_API_KEY"),
          },
        },

        hooks = {
          -- Keep ONE CodeReview hook (you had it duplicated)
          CodeReview = function(gp_, params)
            local template = "I have the following code from {{filename}}:\n\n"
              .. "```{{filetype}}\n{{selection}}\n```\n\n"
              .. "Please analyze for code smells and suggest improvements."
            local agent = gp_.get_chat_agent()
            gp_.Prompt(params, gp_.Target.enew("markdown"), agent, template)
          end,

          -- Stateful Commit hook:
          -- 1) grabs staged diff
          -- 2) opens a gp chat buffer seeded with diff + instructions
          -- 3) responds in that chat
          -- Then you can keep asking follow-ups in the same chat buffer.
          Commit = function(_, _)
            local diff = vim.fn.system("git diff --staged")
            if diff == nil or diff == "" then
              vim.notify(
                "No staged changes to generate a commit message for.",
                vim.log.levels.WARN
              )
              return
            end

            local seed = ([[
Generate a Git commit message from the staged diff below.

Additional constraints:
- use imperative, present tense
- wrap body at 72 chars
- output ONLY the commit message

Staged diff:

```diff
%s

]]):format(diff)

        open_chat_and_respond(seed)
      end,
    },
  })

  -- Optional: a keymap to run the Commit hook quickly
  -- (uses gp.nvim's built-in :GpChat... commands in the hook above)
  vim.keymap.set("n", "<leader>gc", function()
    -- Call the hook directly if you want, or just run :GpCommit if you
    -- wire a user command. This calls the hook by name via gp.nvim:
    vim.cmd("GpCommit")
  end, { desc = "gp: generate commit message (stateful chat)" })
end,

},
}

How you use it:

- Stage your changes (`git add ...`)
- Run `:GpCommit` (or your `<leader>gc` mapping if you keep it)
- A **chat buffer** opens, it generates the commit message
- Then keep typing questions in that same buffer and run `:GpChatRespond`
  (or `:GpChatRespond 3` to only use the last 3 exchanges as context)
