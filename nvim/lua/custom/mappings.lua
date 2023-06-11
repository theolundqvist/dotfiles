---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
}



M.nvimtree = {
  n = {
    ["<leader>e"] = { "<cmd>NvimTreeToggle<CR>", "Toggle nvimtree" },
    ["<leader>o"] = { "<cmd>NvimTreeFocus<CR>", "Focus nvimtree" },
  },
}

M.mappings = {
  n = {
    ["<leader>fc"] = { "<cmd>Telescope commands<CR>", "Find commands" },
  },
}
-- more keybinds!

return M
