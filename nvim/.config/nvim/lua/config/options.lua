-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.spelllang = { "en", "tr" }

-- nvim (LazyVim yapısında)
vim.g.clipboard = {
  name = "wl-copy",
  copy = {
    ["+"] = "wl-copy",
    ["*"] = "wl-copy", -- '--primary' flag'ini sildik
  },
  paste = {
    ["+"] = "wl-paste",
    ["*"] = "wl-paste", -- '--primary' flag'ini sildik
  },
  cache_enabled = 1,
}
