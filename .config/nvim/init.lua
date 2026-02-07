-- .vimrcを読み込む
vim.cmd("source ~/.vimrc")

-- Neovim固有の設定
vim.opt.termguicolors = true
vim.opt.ambiwidth = "single"
vim.opt.signcolumn = "yes"

-- C-w h/j/k/l でvimウィンドウ端ならtmuxペインに移動
local function tmux_navigate(direction, tmux_dir)
  local win = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. direction)
  if vim.api.nvim_get_current_win() == win then
    -- ウィンドウが変わらなかった = 端にいる → tmuxに移動
    vim.fn.system("tmux select-pane -" .. tmux_dir)
  end
end
vim.keymap.set("n", "<C-w>h", function() tmux_navigate("h", "L") end)
vim.keymap.set("n", "<C-w>j", function() tmux_navigate("j", "D") end)
vim.keymap.set("n", "<C-w>k", function() tmux_navigate("k", "U") end)
vim.keymap.set("n", "<C-w>l", function() tmux_navigate("l", "R") end)

-- lazy.nvim のブートストラップ
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- プラグイン設定
require("lazy").setup({
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme nightfox")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
        },
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          follow_current_file = { enabled = true },
          use_libuv_file_watcher = true,
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
          },
        },
      })
      vim.keymap.set("n", "<C-l>", "<Cmd>Neotree toggle<CR>")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "nightfox",
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc",
          "go", "python", "ruby",
          "javascript", "typescript", "tsx",
          "json", "yaml", "toml",
          "html", "css",
          "bash", "dockerfile", "hcl", "terraform",
          "markdown", "markdown_inline",
        },
      })
    end,
  },
  -- LSP
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "ts_ls",
          "terraformls",
        },
      })

      -- LSP キーマップ（LspAttach イベントで設定）
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local opts = { buffer = args.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<Space>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<Space>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<Space>d", vim.diagnostic.open_float, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        end,
      })

      -- cmp の capabilities を全 LSP に適用
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      -- lua_ls 固有の設定
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      -- LSP サーバーを有効化
      vim.lsp.enable({ "lua_ls", "pyright", "ts_ls", "terraformls" })
    end,
  },
  -- 補完
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        performance = {
          fetching_timeout = 500,
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-x><C-o>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer", keyword_length = 3 },
          { name = "path" },
        }),
      })
    end,
  },
  -- ファジーファインダー
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<Space>ff", builtin.find_files)
      vim.keymap.set("n", "<Space>fg", builtin.live_grep)
      vim.keymap.set("n", "<Space>fb", builtin.buffers)
      vim.keymap.set("n", "<Space>fd", builtin.diagnostics)
      vim.keymap.set("n", "<Space>fr", builtin.lsp_references)
      vim.keymap.set("n", "<Space>fk", builtin.keymaps)
    end,
  },
  -- キーマップ表示
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup()
      wk.add({
        { "<Space>f", group = "Find" },
        { "<Space>ff", desc = "Files" },
        { "<Space>fg", desc = "Grep" },
        { "<Space>fb", desc = "Buffers" },
        { "<Space>fd", desc = "Diagnostics" },
        { "<Space>fr", desc = "References" },
        { "<Space>fk", desc = "Keymaps" },
        { "<Space>h", desc = "Prev buffer" },
        { "<Space>l", desc = "Next buffer" },
        { "<Space>rn", desc = "Rename" },
        { "<Space>ca", desc = "Code action" },
        { "<Space>d", desc = "Diagnostic float" },
      })
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
      })
    end,
  },
  {
    "okuuuu/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    config = function()
      require("auto-save").setup()
    end,
  },
})
