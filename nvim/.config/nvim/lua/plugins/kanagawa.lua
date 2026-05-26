return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      compile = true,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = true,
      dimInactive = false,
      terminalColors = true,
      colors = {
        palette = {},
        theme = { wave = { ui = { float = { bg = "none" } } }, all = { ui = { bg_gutter = "none" } } },
      },
      overrides = function(colors)
        return {}
      end,
      theme = "wave",
      background = {
        dark = "wave",
        light = "lotus",
      },
    },
  },
}
