return {
  "stevearc/overseer.nvim",
  cmd = { "OverseerRun", "OverseerToggle", "OverseerRunCmd" },
  keys = {
    { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run Task" },
    { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Task List" },
    { "<leader>ol", "<cmd>OverseerRestartLast<cr>", desc = "Restart Last Task" },
  },
  config = function()
    local overseer = require("overseer")

    overseer.setup({
      task_list = {
        direction = "bottom",
        min_height = 15,
        default_detail = 2,
      },
    })

    -- Helper: run a shell pipeline as an overseer task
    local function run_pipeline(name, shell_cmd)
      local task = overseer.new_task({
        name = name,
        cmd = shell_cmd,
        strategy = { "terminal" },
      })
      task:start()
      overseer.open({ enter = false })
    end

    --------------------------------------------------------------------------
    -- 1. CLAUDE FIX TESTS
    --    pytest → capture failures → pipe to claude for diagnosis + fix
    --------------------------------------------------------------------------
    overseer.register_template({
      name = "Claude: Fix Failing Tests",
      builder = function()
        return {
          name = "claude-fix-tests",
          cmd = "bash",
          args = {
            "-c",
            [[
OUTPUT=$(pytest --tb=short -q 2>&1)
EXIT=$?
if [ $EXIT -eq 0 ]; then
  echo "All tests passed!"
  echo "$OUTPUT"
else
  echo "=== Test Failures ==="
  echo "$OUTPUT"
  echo ""
  echo "=== Sending to Claude for analysis ==="
  echo "$OUTPUT" | claude -p "These pytest failures happened in my Django project. Analyze the failures, identify root causes, and show me the exact file changes needed to fix them. Be specific with file paths and line numbers."
fi
]],
          },
        }
      end,
      desc = "Run tests → Claude fixes failures",
      tags = { "claude", "test" },
    })

    --------------------------------------------------------------------------
    -- 2. CLAUDE REVIEW CHANGES
    --    git diff → pipe to claude for code review
    --------------------------------------------------------------------------
    overseer.register_template({
      name = "Claude: Review My Changes",
      builder = function()
        return {
          name = "claude-review",
          cmd = "bash",
          args = {
            "-c",
            [[
DIFF=$(git diff HEAD 2>&1)
if [ -z "$DIFF" ]; then
  echo "No changes to review."
else
  echo "$DIFF" | claude -p "Review this diff for a Django/Python project. Check for: bugs, security issues (SQL injection, XSS), missing error handling, Django best practices violations, N+1 queries, race conditions, and anything that could break in production. Be concise and actionable. Group issues by severity."
fi
]],
          },
        }
      end,
      desc = "Review git changes with Claude",
      tags = { "claude", "git" },
    })

    --------------------------------------------------------------------------
    -- 3. CLAUDE COMMIT MESSAGE
    --    git diff --staged → claude generates conventional commit message
    --------------------------------------------------------------------------
    overseer.register_template({
      name = "Claude: Generate Commit Message",
      builder = function()
        return {
          name = "claude-commit-msg",
          cmd = "bash",
          args = {
            "-c",
            [[
DIFF=$(git diff --staged 2>&1)
if [ -z "$DIFF" ]; then
  echo "No staged changes. Stage files first with git add."
else
  echo "$DIFF" | claude -p "Generate a concise conventional commit message for these staged changes. Use format: type(scope): description. If multiple logical changes, suggest separate commits. Output ONLY the commit message(s), nothing else."
fi
]],
          },
        }
      end,
      desc = "Generate commit message from staged changes",
      tags = { "claude", "git" },
    })

    --------------------------------------------------------------------------
    -- 4. CLAUDE EXPLAIN ERROR (from clipboard)
    --    Takes clipboard content → claude explains the error
    --------------------------------------------------------------------------
    vim.api.nvim_create_user_command("ClaudeExplain", function()
      local clipboard = vim.fn.getreg("+")
      if clipboard == "" then
        vim.notify("Clipboard is empty — copy an error first", vim.log.levels.WARN)
        return
      end
      -- Write clipboard to temp file to avoid shell escaping issues
      local tmp = vim.fn.tempname()
      vim.fn.writefile(vim.split(clipboard, "\n"), tmp)
      run_pipeline("claude-explain-error", string.format(
        "bash -c 'cat %s | claude -p \"Explain this error from my project. What caused it, how to fix it, and how to prevent it. Be specific.\"; rm %s'",
        tmp, tmp
      ))
    end, { desc = "Claude explain error from clipboard" })

    --------------------------------------------------------------------------
    -- 5. DOCKER COMPOSE UP + CLAUDE TROUBLESHOOT
    --    docker compose up → if fails, send logs to claude
    --------------------------------------------------------------------------
    overseer.register_template({
      name = "Docker: Up (Claude on fail)",
      builder = function()
        return {
          name = "docker-up-claude",
          cmd = "bash",
          args = {
            "-c",
            [[
echo "=== Starting docker compose ==="
OUTPUT=$(docker compose up -d --build 2>&1)
EXIT=$?
echo "$OUTPUT"
if [ $EXIT -ne 0 ]; then
  echo ""
  echo "=== Build failed, asking Claude ==="
  LOGS=$(docker compose logs --tail=50 2>&1)
  printf "%s\n\n%s" "$OUTPUT" "$LOGS" | claude -p "Docker compose up failed. Here are the build output and recent logs. Diagnose the issue and give me the exact fix."
else
  echo ""
  echo "Docker started successfully!"
fi
]],
          },
        }
      end,
      desc = "docker compose up → Claude troubleshoots on failure",
      tags = { "claude", "docker" },
    })

    --------------------------------------------------------------------------
    -- 6. DJANGO MIGRATIONS + REVIEW
    --    makemigrations → claude reviews for data safety issues
    --------------------------------------------------------------------------
    overseer.register_template({
      name = "Django: Makemigrations + Claude Review",
      builder = function()
        return {
          name = "django-migrate-review",
          cmd = "bash",
          args = {
            "-c",
            [[
echo "=== Running makemigrations ==="
OUTPUT=$(python manage.py makemigrations 2>&1)
EXIT=$?
echo "$OUTPUT"
if [ $EXIT -ne 0 ]; then
  echo ""
  echo "=== Failed, asking Claude ==="
  echo "$OUTPUT" | claude -p "Django makemigrations failed with this output. Diagnose and tell me how to fix it."
else
  echo ""
  echo "=== Claude reviewing migration safety ==="
  # Find the newly created migration files and send them for review
  NEW_FILES=$(echo "$OUTPUT" | grep -oP '[\w/]+/migrations/\d+_\w+\.py' || true)
  if [ -n "$NEW_FILES" ]; then
    cat $NEW_FILES | claude -p "Review this Django migration for: data loss risks, irreversible operations, performance issues on large tables, missing RunPython reverse functions, and lock contention. Flag anything dangerous."
  else
    echo "$OUTPUT" | claude -p "Review this Django makemigrations output for any concerns about data safety or performance."
  fi
fi
]],
          },
        }
      end,
      desc = "makemigrations → Claude reviews for data safety",
      tags = { "claude", "django" },
    })

    --------------------------------------------------------------------------
    -- 7. LINT + CLAUDE FIX (current file)
    --    ruff check → pipe violations to claude for fixes
    --------------------------------------------------------------------------
    overseer.register_template({
      name = "Claude: Lint and Fix Current File",
      builder = function()
        local file = vim.fn.expand("%:p")
        return {
          name = "claude-lint-fix",
          cmd = "bash",
          args = {
            "-c",
            string.format(
              [[
OUTPUT=$(ruff check %s --output-format=concise 2>&1)
EXIT=$?
if [ $EXIT -eq 0 ]; then
  echo "No lint issues found in %s"
else
  echo "=== Lint Issues ==="
  echo "$OUTPUT"
  echo ""
  echo "=== Claude fixing ==="
  echo "$OUTPUT" | claude -p "Fix ALL these ruff lint violations. For each violation, show the corrected code. File: %s"
fi
]],
              file, file, file
            ),
          },
        }
      end,
      desc = "Lint current file → Claude fixes violations",
      tags = { "claude", "lint" },
    })

    --------------------------------------------------------------------------
    -- 8. GENERATE TESTS (current file)
    --    Reads current buffer → claude generates pytest tests
    --------------------------------------------------------------------------
    vim.api.nvim_create_user_command("ClaudeTests", function()
      local file = vim.fn.expand("%:p")
      local tmp = vim.fn.tempname()
      vim.fn.writefile(vim.api.nvim_buf_get_lines(0, 0, -1, false), tmp)
      run_pipeline("claude-gen-tests", string.format(
        "bash -c 'claude -p \"Generate comprehensive pytest tests for this Django/Python file. Include edge cases, error paths, and mock external dependencies. Use pytest fixtures. File: %s\" < %s; rm %s'",
        file, tmp, tmp
      ))
    end, { desc = "Claude generate tests for current file" })

    --------------------------------------------------------------------------
    -- 9. PR DESCRIPTION
    --    git log + diff stat → claude writes PR description
    --------------------------------------------------------------------------
    overseer.register_template({
      name = "Claude: Generate PR Description",
      builder = function()
        return {
          name = "claude-pr-desc",
          cmd = "bash",
          args = {
            "-c",
            [[
COMMITS=$(git log --oneline main..HEAD 2>&1)
STATS=$(git diff main...HEAD --stat 2>&1)
DIFF=$(git diff main...HEAD 2>&1)
if [ -z "$COMMITS" ]; then
  echo "No commits ahead of main."
else
  printf "Commits:\n%s\n\nFiles changed:\n%s\n\nFull diff:\n%s" "$COMMITS" "$STATS" "$DIFF" | claude -p "Generate a GitHub PR description in markdown. Include: ## Summary (2-3 sentences), ## Changes (bullet list), ## Testing (what to verify). Be concise."
fi
]],
          },
        }
      end,
      desc = "Generate PR description from branch",
      tags = { "claude", "git" },
    })

    --------------------------------------------------------------------------
    -- 10. DOCKER LOGS (follow)
    --------------------------------------------------------------------------
    overseer.register_template({
      name = "Docker: Logs (follow)",
      params = {
        service = {
          type = "string",
          name = "Service name",
          desc = "Docker compose service to tail (empty = all)",
          optional = true,
          default = "",
        },
      },
      builder = function(params)
        local cmd = { "docker", "compose", "logs", "-f", "--tail=100" }
        if params.service and params.service ~= "" then
          table.insert(cmd, params.service)
        end
        return {
          name = "docker-logs",
          cmd = cmd,
        }
      end,
      desc = "Tail docker compose logs",
      tags = { "docker" },
    })

    --------------------------------------------------------------------------
    -- 11. CLAUDE SECURITY AUDIT (current file)
    --------------------------------------------------------------------------
    vim.api.nvim_create_user_command("ClaudeAudit", function()
      local file = vim.fn.expand("%:p")
      local tmp = vim.fn.tempname()
      vim.fn.writefile(vim.api.nvim_buf_get_lines(0, 0, -1, false), tmp)
      run_pipeline("claude-security-audit", string.format(
        "bash -c 'claude -p \"Security audit this file. Check for: SQL injection, XSS, CSRF, insecure deserialization, hardcoded secrets, path traversal, IDOR, mass assignment, and Django-specific issues (raw queries, mark_safe misuse, unvalidated redirects). Severity-ranked output. File: %s\" < %s; rm %s'",
        file, tmp, tmp
      ))
    end, { desc = "Claude security audit current file" })

    --------------------------------------------------------------------------
    -- 12. CLAUDE OPTIMIZE QUERY
    --     For SQL files - analyze and optimize the query
    --------------------------------------------------------------------------
    vim.api.nvim_create_user_command("ClaudeOptimizeSQL", function()
      local file = vim.fn.expand("%:p")
      local tmp = vim.fn.tempname()
      vim.fn.writefile(vim.api.nvim_buf_get_lines(0, 0, -1, false), tmp)
      run_pipeline("claude-optimize-sql", string.format(
        "bash -c 'claude -p \"Optimize this SQL query. Suggest index additions, query rewrites, and explain the execution plan improvements. If using Django ORM, show both raw SQL optimization and the equivalent ORM code. File: %s\" < %s; rm %s'",
        file, tmp, tmp
      ))
    end, { desc = "Claude optimize SQL query" })

    --------------------------------------------------------------------------
    -- SHORTCUT COMMANDS for templates
    --------------------------------------------------------------------------
    vim.api.nvim_create_user_command("ClaudeFixTests", function()
      overseer.run_template({ name = "Claude: Fix Failing Tests" })
    end, { desc = "Run tests and have Claude fix failures" })

    vim.api.nvim_create_user_command("ClaudeReview", function()
      overseer.run_template({ name = "Claude: Review My Changes" })
    end, { desc = "Claude review git changes" })

    vim.api.nvim_create_user_command("ClaudeCommitMsg", function()
      overseer.run_template({ name = "Claude: Generate Commit Message" })
    end, { desc = "Claude generate commit message" })

    vim.api.nvim_create_user_command("ClaudePR", function()
      overseer.run_template({ name = "Claude: Generate PR Description" })
    end, { desc = "Claude generate PR description" })

    vim.api.nvim_create_user_command("ClaudeLintFix", function()
      overseer.run_template({ name = "Claude: Lint and Fix Current File" })
    end, { desc = "Lint then Claude fix" })

    vim.api.nvim_create_user_command("DockerUp", function()
      overseer.run_template({ name = "Docker: Up (Claude on fail)" })
    end, { desc = "Docker up with Claude troubleshooting" })

    vim.api.nvim_create_user_command("DjangoMigrate", function()
      overseer.run_template({ name = "Django: Makemigrations + Claude Review" })
    end, { desc = "Makemigrations with Claude review" })
  end,
}
