local on_attach = function(bufnr)
  local opts = function(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  local api = require 'nvim-tree.api'
  vim.keymap.set('n', 'a', api.fs.create, opts 'Create')
  vim.keymap.set('n', 'd', api.fs.remove, opts 'Delete')
  vim.keymap.set('n', 'p', api.fs.paste, opts 'Paste')
  vim.keymap.set('n', 'c', api.fs.copy.node, opts 'Copy')
  vim.keymap.set('n', 'x', api.fs.cut, opts 'Cut')
  vim.keymap.set('n', 'r', api.fs.rename, opts 'Rename')
  vim.keymap.set('n', 'l', api.node.open.edit, opts 'Open')
  vim.keymap.set('n', '<CR>', api.node.open.edit, opts 'Open')
  vim.keymap.set('n', 'o', api.node.open.edit, opts 'Open')
  vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts 'Close Directory')
  vim.keymap.set('n', 'v', api.node.open.vertical, opts 'Open: Vertical Split')
end

return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    require('nvim-tree').setup() {
      respect_buf_cwd = true,
      reload_on_bufenter = true,
      on_attach = on_attach,
      renderer = {
        icons = {
          glyphs = {
            default = '',
            symlink = '',
            git = {
              unstaged = '',
              staged = 'S',
              unmerged = '',
              renamed = '➜',
              deleted = '',
              untracked = 'U',
              ignored = '◌',
            },
            folder = {
              default = '',
              open = '',
              empty = '',
              empty_open = '',
              symlink = '',
            },
          },
        },
      },
      disable_netrw = true,
      hijack_netrw = true,
      auto_reload_on_write = true,
      open_on_tab = false,
      hijack_cursor = false,
      update_cwd = false,
      diagnostics = {
        enable = true,
        icons = {
          hint = '',
          info = '',
          warning = '',
          error = '',
        },
      },
      update_focused_file = {
        enable = false,
        update_cwd = true,
        ignore_list = {},
      },
      git = {
        enable = true,
        ignore = true,
        timeout = 500,
      },
      view = {
        width = '33%',
        side = 'left',
        number = false,
        relativenumber = false,
        preserve_window_proportions = true,
      },
      actions = {
        open_file = {
          resize_window = true,
        },
      },
    }
  end,
}
