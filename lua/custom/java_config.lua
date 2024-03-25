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

return java_config
