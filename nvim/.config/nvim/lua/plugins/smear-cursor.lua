return {
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      -- Akıcı imleç animasyon parametreleri
      stiffness = 0.8, -- İmlecin hedefe ulaşma hızı (0.1 - 1.0)
      trailing_stiffness = 0.5, -- İmleç kuyruğunun takip hızı
      distance_stop_animating = 0.5,
      hide_target_hack = false,
    },
  },
}
