require("lazy").setup({
  "marko-cerovac/material.nvim",
}, opts)
return {
  "marko-cerovac/material.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    -- Stil seçimi. Kullanılabilir diğer seçenekler aşağıda listelenmiştir.
    vim.g.material_style = "lighter"

    require("material").setup({
      contrast = {
        terminal = false,
        sidebars = false,
        floating_windows = false,
        cursor_line = false,
        lsp_virtual_text = false,
        non_current_windows = false,
        filetypes = {},
      },
      styles = {
        comments = { italic = true },
        strings = { bold = true },
        keywords = { underline = true },
        functions = { bold = true, undercurl = true },
        variables = {},
        operators = {},
        types = {},
      },
      plugins = {
        -- Kullanılan eklentileri vurgulamak için başlarındaki yorum satırını kaldırın
        -- "blink",
        -- "coc",
        -- "colorful-winsep",
        -- "dap",
        -- "dashboard",
        -- "eyeliner",
        -- "fidget",
        -- "flash",
        -- "gitsigns",
        -- "harpoon",
        -- "hop",
        -- "illuminate",
        -- "indent-blankline",
        -- "lspsaga",
        -- "mini",
        -- "neo-tree",
        -- "neogit",
        -- "neorg",
        -- "neotest",
        -- "noice",
        -- "nvim-cmp",
        -- "nvim-navic",
        -- "nvim-notify",
        -- "nvim-tree",
        -- "nvim-web-devicons",
        -- "rainbow-delimiters",
        -- "sneak",
        -- "telescope",
        -- "trouble",
        -- "which-key",
      },
      disable = {
        colored_cursor = false,
        borders = false,
        background = false,
        term_colors = false,
        eob_lines = false,
      },
      high_visibility = {
        lighter = false,
        darker = false,
      },
      lualine_style = "default",
      async_loading = true,
      custom_colors = nil,
      custom_highlights = {},
    })

    -- Temayı Neovim'de aktif etme
    vim.cmd("colorscheme material")
  end,
}
