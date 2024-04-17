local M = {}

local function file_exists(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

M.create_test_case = function()
  local current_filename = vim.api.nvim_buf_get_name(0)
  local test_filename = string.gsub(current_filename, '/src/main/java/', '/src/test/java/')
  -- Add "Test" at the end of the classname.
  -- e.g. User.java becomes UserTest.java
  test_filename, _ = string.gsub(test_filename, '[.]java', 'Test.java')
  if not file_exists(test_filename) then
    local _, last_slash = string.find(test_filename, '.*/')
    local _, package_start = string.find(test_filename, '/src/test/java/')
    local package_name = string.sub(test_filename, package_start + 1, last_slash - 1)
    package_name = string.gsub(package_name, '/', '.')

    local _, last_dot = string.find(test_filename, '.*[.]')
    local class_name = string.sub(test_filename, last_slash + 1, last_dot - 1)
    local file = io.open(test_filename, 'w')
    if file ~= nil then
      file:write('package ' .. package_name .. ';\n\nclass ' .. class_name .. ' {\n\n}')
      io.close(file)
    end
  end
  vim.api.nvim_command(':e ' .. test_filename)
end

return M
