return {
  "jvgrootveld/telescope-zoxide",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    local telescope = require("telescope")
    telescope.load_extension("zoxide")

    -- set keymaps
    local keymap = vim.keymap
    keymap.set("n", "<leader>fz", "<cmd>Telescope zoxide list<cr>", { desc = "Find directories with zoxide" })
  end,
}
