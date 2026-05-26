-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.env.KITTY_WINDOW_ID then
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      -- vim.notify("Setting kitty padding to 0")
      vim.fn.system({ "kitty", "@", "set-spacing", "padding=0" })
    end,
  })

  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      -- vim.notify("Restoring kitty padding to default")
      vim.fn.system({ "kitty", "@", "set-spacing", "padding=default" })
    end,
  })
end
