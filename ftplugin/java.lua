local jdtls_ok, jdtls = pcall(require, 'jdtls')
if not jdtls_ok then
  vim.notify 'JDTLS not found'
  return
end

vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.cmdheight = 2 -- more space in the neovim command line for displaying messages

local mason_path = vim.fn.stdpath 'data' .. '/mason/packages'
local jdtls_path = mason_path .. '/jdtls'
local path_to_lsp_server = jdtls_path .. '/config_mac'
local path_to_plugins = jdtls_path .. '/plugins/'
local path_to_jar = vim.fn.glob(path_to_plugins .. 'org.eclipse.equinox.launcher_*.jar')
local lombok_path = jdtls_path .. '/lombok.jar'

-- Find root of project
local root_markers = { '.git', 'mvnw' }
local root_dir = require('jdtls.setup').find_root(root_markers)
if root_dir == '' then
  return
end

local home = os.getenv 'HOME'

local workspace_path = home .. '/ws/jdtls_data_2/'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = workspace_path .. project_name
--os.execute('mkdir ' .. workspace_dir)

local java_debug_adapter_path = vim.fn.glob(mason_path .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar')
local bundles = {
  java_debug_adapter_path,
}

local java_test_server_paths = vim.fn.glob(mason_path .. '/java-test/extension/server/*.jar')
vim.list_extend(bundles, vim.split(java_test_server_paths, '\n'))

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-javaagent:' .. lombok_path,
    '-Xms1536m',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    path_to_jar,
    '-configuration',
    path_to_lsp_server,
    '-data',
    workspace_dir,
  },

  --on_attach = require('user.lsp.handlers').on_attach,
  --capabilities = require('user.lsp.handlers').capabilities,

  root_dir = root_dir,

  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = false,
      },
      referencesCodeLens = {
        enabled = false,
      },
      references = {
        includeDecompiledSources = true,
      },
      -- Set this to true to use jdtls as your formatter
      format = {
        enabled = false,
      },
    },
    signatureHelp = { enabled = true },
    completion = {
      favoriteStaticMembers = {
        'org.assertj.core.api.Assertions.*',
        'java.util.Objects.requireNonNull',
        'java.util.Objects.requireNonNullElse',
        'org.mockito.Mockito.*',
      },
    },
    contentProvider = { preferred = 'fernflower' },
    extendedClientCapabilities = extendedClientCapabilities,
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
      },
      useBlocks = true,
    },
  },

  flags = {
    allow_incremental_sync = true,
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    -- bundles = {},
    bundles = bundles,
  },
}
require('jdtls').start_or_attach(config)

-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

keymap('n', '<leader>jo', "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
keymap('n', '<leader>jv', "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
keymap('n', '<leader>jc', "<Cmd>lua require('jdtls').extract_constant()<CR>", opts)
keymap('n', '<leader>jt', "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", opts)
keymap('n', '<leader>jT', "<Cmd>lua require'jdtls'.test_class()<CR>", opts)
keymap('n', '<leader>ju', '<Cmd>JdtUpdateConfig<CR>', opts)

keymap('v', '<leader>jv', "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
keymap('v', '<leader>jc', "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", opts)
keymap('v', '<leader>jm', "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)

-- Debugging
keymap('n', '<F2>', "<Cmd>lua require('dap').toggle_breakpoint()<CR>", opts)
keymap('n', '<F3>', "<Cmd>lua require('dapui').toggle()<CR>", opts)
keymap('n', '<F5>', "<Cmd>lua require('jdtls.dap').setup_dap_main_class_configs()<CR>", opts)
keymap('n', '<F9>', "<Cmd>lua require'dap'.continue()<CR>", opts)
keymap('n', '<S-F9>', "<Cmd>lua require'dap'.run_to_cursor()<CR>", opts)
keymap('n', '<F8>', "<Cmd>lua require'dap'.step_over()<CR>", opts)
keymap('n', '<F7>', "<Cmd>lua require'dap'.step_into()<CR>", opts)
keymap('n', '<S-F7>', "<Cmd>lua require'dap'.step_out()<CR>", opts)
keymap('n', '<F12>', "<Cmd>lua require'dap'.terminate()<CR>", opts)
