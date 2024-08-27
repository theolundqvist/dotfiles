require "nvchad.mappings"

-- add yours here


local map = vim.keymap.set
local nomap = vim.keymap.del


-- map("i", "jk", "<ESC>")

-- Disable multiple mappings in normal mode
local disabled_mappings = {
  -- "<leader>ff", "<leader>fa", "<leader>fb", "<leader>fh", "<leader>fo", "<leader>fw",
  -- "<leader>fm", "<leader>fz", "<leader>v", "<leader>h", "<leader>n",
  -- "<leader>cc", "<leader>ch",
  -- "<leader>rn", "<leader>pt", "<C-n>"
  "<C-h>", "<C-j>", "<C-k>", "<C-l>",
}

for _, key in pairs(disabled_mappings) do
  nomap("n", key)
end



-- Normal mode
map("n", "<Esc>", ":noh <CR>", { desc = "Clear highlights" })
map("n", "<C-M>", "<cmd> lua vim.lsp.buf.code_action()<CR>", { desc = "LSP Code Action" })

map("n", "<C-s>", "<cmd> w <CR>", { desc = "Save file" })
map("n", "<C-c>", "<cmd> %y+ <CR>", { desc = "Copy whole file" })
map("n", "<leader>nt", "<cmd> set nu! <CR>", { desc = "Toggle line number" })
map("n", "<leader>nr", "<cmd> set rnu! <CR>", { desc = "Toggle relative number" })
map("n", "<leader>lf", "<cmd> lua vim.lsp.buf.format() <CR>", { desc = "Format document" })
map("n", "<leader>lr", "<cmd> lua vim.lsp.buf.rename() <CR>", { desc = "Rename variable" })


-- Line movement
map("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
map("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
map("n", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
map("n", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })

map("n", "<leader>b", "<cmd> enew <CR>", { desc = "New buffer" })
map("n", "<leader>ch", "<cmd> NvCheatsheet <CR>", { desc = "Mapping cheatsheet" })






-- Terminal mode
map("t", "<esc>", vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), { desc = "Escape terminal mode" })
map("t", "<C-w>h", vim.api.nvim_replace_termcodes("<C-\\><C-n><C-w>h", true, true, true))
map("t", "<C-w>j", vim.api.nvim_replace_termcodes("<C-\\><C-n><C-w>j", true, true, true))
map("t", "<C-w>k", vim.api.nvim_replace_termcodes("<C-\\><C-n><C-w>k", true, true, true))
map("t", "<C-w>l", vim.api.nvim_replace_termcodes("<C-\\><C-n><C-w>l", true, true, true))
map("t", "<C-w>q", vim.api.nvim_replace_termcodes("<C-\\><C-n><C-w>q", true, true, true))
map("t", "<C-w>", vim.api.nvim_replace_termcodes("<C-\\><C-n><C-w>", true, true, true), { desc = "window" })


-- NvimTreeToggle --
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window", remap=true })
map("n", "<leader>o", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window", remap=true })







-- Visual mode
map("v", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
map("v", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })





-- Select mode
map("x", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
map("x", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
map("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = "Dont copy replaced text", silent = true })

