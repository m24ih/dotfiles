return {
  "marko-cerovac/material.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    lualine_style = "default",
    async_loading = true,
    custom_colors = nil,
    custom_highlights = {},
  },
  config = function(_, opts)
    vim.g.material_style = "lighter"
    require("material").setup(opts)
    -- Temayı aktif etmek isterseniz aşağıdaki satırı kullanabilirsiniz:
    -- vim.cmd("colorscheme material")
  end,
}
