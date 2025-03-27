vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
vim.keymap.set("n", "<leader>d", ":lua require'dapui'.toggle()<CR>")

vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n", "<leader>c", ":lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<leader>s1", ":lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<leader>s2", ":lua require'dap'.step_into()<CR>")
vim.keymap.set("n", "<leader>s3", ":lua require'dap'.step_out()<CR>")

local dap = require("dap")
-- dap.defaults.fallback.force_external_terminal = true
-- dap.defaults.fallback.terminal_win_cmd = '50vsplit new'
-- dap.defaults.fallback.focus_terminal = true
dap.defaults.fallback.terminal_win_cmd = 'tabnew'
-- dap.defaults.fallback.external_terminal = {
-- command = '/opt/homebrew/bin/alacritty';
-- args = {'-e'};
-- }
dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = '/Users/louis/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb',
    args = {"--port", "${port}"},
  }
}
dap.configurations.rust= {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}
