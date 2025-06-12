return {
  'CopilotC-Nvim/CopilotChat.nvim',
  dependencies = {
    { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
    { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
  },

  build = 'make tiktoken', -- Only on MacOS or Linux
  opts = {
    -- See Configuration section for options
  },
  config = function()
    require('CopilotChat').setup {
      prompts = {
        Docs = {
          mapping = '<leader>ad',
          description = 'AI Documentation',
        },
      },
    }
    local chat = require 'CopilotChat'
    vim.keymap.set({ 'n' }, '<leader>aa', chat.toggle, { desc = 'AI Toggle' })
    vim.keymap.set({ 'v' }, '<leader>aa', chat.open, { desc = 'AI Open' })
    vim.keymap.set({ 'n' }, '<leader>ax', chat.reset, { desc = 'AI Reset' })
    vim.keymap.set({ 'n' }, '<leader>as', chat.stop, { desc = 'AI Stop' })
    vim.keymap.set({ 'n' }, '<leader>am', chat.select_model, { desc = 'AI Models' })
    vim.keymap.set({ 'n', 'v' }, '<leader>ap', chat.select_prompt, { desc = 'AI Prompts' })
    vim.keymap.set({ 'n', 'v' }, '<leader>aq', function()
      vim.ui.input({
        prompt = 'AI Question> ',
      }, function(input)
        if input ~= '' then
          chat.ask(input)
        end
      end)
    end, { desc = 'AI Question' })
  end, -- See Commands section for default commands if you want to lazy load on them
}
