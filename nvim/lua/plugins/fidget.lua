return {
  "j-hui/fidget.nvim",
  tag = "legacy",
  config = function()
    require("fidget").setup({
      text = {
        spinner = "moon",
      },
      window = {
        blend = 0,
      },
      sources = {
        ["rust-analyzer"] = {
          ignore = false,
        },
      },
    })
  end
}
