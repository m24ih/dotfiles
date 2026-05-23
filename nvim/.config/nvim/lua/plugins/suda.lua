return {
  "lambdalisue/suda.vim",
  cmd = { "SudaRead", "SudaWrite" },
  init = function()
    -- İsteğe bağlı: Sudo gerektiren bir dosya açıldığında otomatik olarak suda protokolünü kullanır.
    vim.g.suda_smart_edit = 1
  end,
}
