vim.g.mapleader = " "
-- vim.g.maplocalleader = " "

local keymap = vim.keymap -- for conciseness
local opts = { noremap = true, silent = true }

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- resize window
keymap.set("n", "<A-Up>", ":resize -1<CR>", { desc = "Resize current window" })
keymap.set("n", "<A-Down>", ":resize +1<CR>", { desc = "Resize current window" })
keymap.set("n", "<A-Left>", ":vertical resize -1<CR>", { desc = "Resize current window" })
keymap.set("n", "<A-Right>", ":vertical resize +1<CR>", { desc = "Resize current window" })

-- tabs
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- buffers
keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Go to next buffer" }) --  go to next buffer
keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Go to previous buffer" }) --  go to previous buffer
keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete current buffer" }) --  delete current buffer

--  move text up and down
keymap.set("n", "<leader>k", ":move-2<CR>", { desc = "Move text up" })
keymap.set("n", "<leader>j", ":move+1<CR>", { desc = "Move text down" })
keymap.set("v", "<leader>k", ":move '<-2<CR>gv", { desc = "Move text up" })
keymap.set("v", "<leader>j", ":move '>+1<CR>gv", { desc = "Move text down" })
