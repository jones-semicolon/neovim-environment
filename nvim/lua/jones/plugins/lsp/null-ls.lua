-- -- import null-ls plugin safely
-- local setup, null_ls = pcall(require, "null-ls")
-- if not setup then
-- 	return
-- end
--
-- -- for conciseness
-- local formatting = null_ls.builtins.formatting -- to setup formatters
-- local diagnostics = null_ls.builtins.diagnostics -- to setup linters
local async_formatting = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  vim.lsp.buf_request(
    bufnr,
    "textDocument/formatting",
    vim.lsp.util.make_formatting_params({}),
    function(err, res, ctx)
      if err then
        local err_msg = type(err) == "string" and err or err.message
        -- you can modify the log message / level (or ignore it completely)
        vim.notify("formatting: " .. err_msg, vim.log.levels.WARN)
        return
      end

      -- don't apply results if buffer is unloaded or has been modified
      if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, "modified") then
        return
      end

      if res then
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or "utf-16")
        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd("silent noautocmd update")
        end)
      end
    end
  )
end
--
-- -- to setup format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
--
-- -- configure null_ls
-- null_ls.setup({
-- 	-- setup formatters & linters
-- 	sources = {
-- 		--  to disable file types use
-- 		--  "formatting.prettier.with({disabled_filetypes = {}})" (see null-ls docs)
-- 		formatting.prettier.with({
-- 			disabled_filetypes = {
-- 				"typescriptreact",
-- 			},
-- 		}),
-- 		--[[ formatting.tsstandard.with({
-- 			fileTypes = { "typescriptreact" },
-- 		}), ]]
-- 		--[[ formatting.eslint_d.with({
-- 			fileTypes = { "javascriptreact", "typescriptreact" },
-- 		}), ]]
-- 		formatting.ktlint.with({
-- 			fileTypes = { "kotlin", "kt", "kts" },
-- 			disabled_filetypes = {},
-- 		}),
-- 		diagnostics.ktlint.with({}),
--
-- 		-- formatting.stylua.with({
-- 		-- 	fileTypes = { "lua" },
-- 		-- 	disabled_filetypes = {
-- 		-- 		"javascriptreact",
-- 		-- 	},
-- 		-- }),
-- 		diagnostics.eslint_d.with({
-- 			condition = function(utils)
-- 				return utils.root_has_file(".eslintrc.js")
-- 			end,
-- 		}),
-- 	},
-- 	on_attach = function(current_client, bufnr)
-- 		if current_client.supports_method("textDocument/formatting") then
-- 			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
-- 			vim.api.nvim_create_autocmd("BufWritePre", {
-- 				group = augroup,
-- 				buffer = bufnr,
-- 				callback = function()
-- 					vim.lsp.buf.format({
-- 						filter = function(client)
-- 							-- return client.name == "null-ls"
-- 							return client.name == vim.bo.filetype
-- 						end,
-- 						bufnr = bufnr,
-- 						async_formatting(bufnr),
-- 					})
-- 				end,
-- 			})
-- 		end
-- 	end,
-- })

-- import null-ls plugin safely
local setup, null_ls = pcall(require, "null-ls")
if not setup then
  return
end

local setup_none, none_ls = pcall(require, "none-ls")
if not setup_none then
  return
end

-- import null-ls helpers
local helpers = require("null-ls.helpers")

-- create a custom source that runs shellcheck and returns diagnostics
local shellcheck = helpers.make_builtin({
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = { "sh" },
  generator_opts = {
    command = "shellcheck",
    to_stdin = true,
    format = "json",
    check_exit_code = function(code)
      return code <= 1
    end,
    on_output = function(params)
      local diagnostics = {}
      for _, diagnostic in ipairs(params.output) do
        table.insert(diagnostics, {
          row = diagnostic.line,
          col = diagnostic.column,
          message = diagnostic.message,
          severity = diagnostic.level,
          source = "shellcheck",
        })
      end
      return diagnostics
    end,
  },
  factory = helpers.generator_factory,
})

-- register sources
null_ls.register(shellcheck)
null_ls.register(null_ls.builtins.formatting.prettier.with({
  disabled_filetypes = {
    "typescriptreact",
  },
}))
null_ls.register(null_ls.builtins.formatting.ktlint.with({
  fileTypes = { "kotlin", "kt", "kts" },
}))
null_ls.register(null_ls.builtins.formatting.stylua.with({
  fileTypes = { "lua" },
}))
null_ls.register(none_ls.builtins.diagnostics.eslint_d.with({
  condition = function(utils)
    return utils.root_has_file(".eslintrc.js")
  end,
}))

-- configure null-ls
null_ls.setup({
  on_attach = function(current_client, bufnr)
    if current_client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            filter = function(client)
              return client.name == "null-ls"
              -- return client.name == vim.bo.filetype
            end,
            bufnr = bufnr,
            async_formatting(bufnr),
          })
        end,
      })
    end
  end,
})
