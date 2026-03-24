local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    java = { "google-java-format" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  format_on_save = {
    timeout_ms = 1000,
    lsp_fallback = true,
  },
}

require("conform").setup {
  formatters = {
    ["google-java-format"] = {
      command = "google-java-format",
      args = { "-i", "$FILENAME" },
      stdin = false,
    },
  },
}
local function markdownlint_cmd_for(file)
  local project_config = vim.fn.findfile(".markdownlint.jsonc", vim.fn.fnamemodify(file, ":p:h") .. ";")

  if project_config ~= "" then
    return { "markdownlint-cli2", "--config", project_config, "--fix", file }
  end

  return {
    "markdownlint-cli2",
    "--config",
    vim.fn.expand "~/repos/.markdownlint.jsonc",
    "--fix",
    file,
  }
end

-- Run pandoc + markdownlint after saving Markdown files
local function format_markdown_with_pandoc_and_lint(bufnr)
  local file = vim.api.nvim_buf_get_name(bufnr)
  if file == "" or not file:match "%.md$" then
    return
  end

  -- Exact pandoc command you provided
  local pandoc_cmd = {
    "pandoc",
    file,
    "-f",
    "markdown-implicit_figures",
    "-t",
    "gfm-implicit_figures",
    "--wrap=auto",
    "--columns=80",
    "--reference-links=true",
    "--reference-location=section",
    "-o",
    file,
  }

  local markdownlint_cmd = markdownlint_cmd_for(file)

  -- Run pandoc first
  vim.system(pandoc_cmd, { text = true }, function(pandoc_res)
    if pandoc_res.code ~= 0 then
      vim.schedule(function()
        vim.notify(("pandoc failed (%d)\n%s"):format(pandoc_res.code, pandoc_res.stderr or ""), vim.log.levels.ERROR)
      end)
      return
    end

    -- Then run markdownlint -f
    vim.system(markdownlint_cmd, { text = true }, function(lint_res)
      vim.schedule(function()
        if lint_res.code ~= 0 then
          -- markdownlint returns non-zero when it can't fix everything
          vim.notify(
            ("markdownlint finished (%d)\n%s"):format(lint_res.code, lint_res.stdout or lint_res.stderr or ""),
            vim.log.levels.WARN
          )
        end

        -- Reload buffer if file changed on disk
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.cmd("checktime " .. bufnr)
        end
      end)
    end)
  end)
end

local function format_markdown_with_lint(bufnr)
  local file = vim.api.nvim_buf_get_name(bufnr)
  if file == "" or not file:match "%.md$" then
    return
  end

  local markdownlint_cmd = markdownlint_cmd_for(file)

  vim.system(markdownlint_cmd, { text = true }, function(res)
    vim.schedule(function()
      if res.code ~= 0 then
        vim.notify(
          ("markdownlint finished (%d)\n%s"):format(res.code, res.stdout or res.stderr or ""),
          vim.log.levels.WARN
        )
      end

      -- Reload buffer if markdownlint changed the file
      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.cmd("checktime " .. bufnr)
      end
    end)
  end)
end

-- vim.api.nvim_create_augroup("MarkdownPandocFormat", { clear = true })
--
-- vim.api.nvim_create_autocmd("BufWritePost", {
--   group = "MarkdownPandocFormat",
--   pattern = "*.md",
--   callback = function(args)
--     format_markdown_with_pandoc_and_lint(args.buf)
--   end,
-- })

vim.api.nvim_create_augroup("MarkdownLintOnly", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = "MarkdownLintOnly",
  pattern = "*.md",
  callback = function(args)
    format_markdown_with_lint(args.buf)
  end,
})

return options
