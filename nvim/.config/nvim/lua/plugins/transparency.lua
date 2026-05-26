return {
  {
    "LazyVim/LazyVim",
    opts = {
      -- Floating windows için kenarlık stilini değiştirebiliriz
      -- "rounded" güzel durur ama siyahlık yapıyorsa "none" denenebilir
      -- diagnostics = {
      --   border = "rounded",
      -- },
    },
  },
  {
    "nvim-lua/plenary.nvim", -- Sadece config'i tetiklemek için bir eklenti
    config = function()
      local function fix_transparency()
        local groups = {
          "Normal",
          "NormalNC",
          "NormalFloat",
          "FloatBorder",
          "StatusLine",
          "StatusLineNC",
          "SignColumn",
          "LineNr",
          "CursorLineNr",
          "FoldColumn",
          "Pmenu",
          "PmenuSel",
          "TelescopeNormal",
          "TelescopeBorder",
          "NoiceFormatProgressDone",
          "NoiceFormatProgressTodo",
          "NeoTreeNormal",
          "NeoTreeNormalNC",
          "MsgArea", -- Alt taraftaki komut alanı
        }
        for _, group in ipairs(groups) do
          vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
        end
      end

      -- Tema her değiştiğinde şeffaflığı zorla
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = fix_transparency,
      })

      -- İlk açılışta uygula
      fix_transparency()
    end,
  },
}
