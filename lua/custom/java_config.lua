local java_config = {}

local mason_path = vim.fn.stdpath 'data' .. '/mason/packages'
local jdtls_path = mason_path .. '/jdtls'
local path_to_lsp_server = jdtls_path .. '/config_mac'
local path_to_plugins = jdtls_path .. '/plugins/'
local path_to_jar = vim.fn.glob(path_to_plugins .. 'org.eclipse.equinox.launcher_*.jar')
local lombok_path = jdtls_path .. '/lombok.jar'

local home = os.getenv 'HOME'
local workspace_path = home .. '/ws/jdtls_data_2/'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = workspace_path .. project_name

local _, jdtls = pcall(require, 'jdtls')
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local java_debug_adapter_path = vim.fn.glob(mason_path .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar')
local java_test_server_paths = vim.fn.glob(mason_path .. '/java-test/extension/server/*.jar')
local bundles = {
  java_debug_adapter_path,
}
vim.list_extend(bundles, vim.split(java_test_server_paths, '\n'))

java_config.cmd = {
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
}

java_config.settings = {
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
}

java_config.capabilities = extendedClientCapabilities

java_config.init_options = {
  bundles = bundles,
}

java_config.on_attach = function(client, bufnr)
  print('Attaching ' .. client.name)
  require('jdtls').setup_dap { hotcodereplace = 'auto', config_overrides = {} }
  require('jdtls.dap').setup_dap_main_class_configs()

  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  -- Mappings.
  local opts = { noremap = true, silent = true }
  buf_set_keymap('n', '<leader>tc', "<Cmd>lua require'jdtls'.test_class()<CR>", opts)
  buf_set_keymap('n', '<leader>tm', "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", opts)
  buf_set_keymap('n', '<leader>ju', "<Cmd>lua require('jdtls').update_project_config()<CR>", opts)
  buf_set_keymap('v', '<leader>cv', "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
  buf_set_keymap('n', '<leader>cv', "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
  buf_set_keymap('v', '<leader>cm', "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)
end

return java_config
