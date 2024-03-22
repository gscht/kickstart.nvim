return {
  'kdheepak/lazygit.nvim',
  config = function()
    print 'Config lazygit'
    vim.keymap.set('n', '<leader>k', ':LazyGit<cr>', { noremap = true, silent = true })
  end,
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
}
