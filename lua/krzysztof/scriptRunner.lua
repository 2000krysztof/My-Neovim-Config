
local function list_scripts_in_directory(dir)
local files = vim.fn.readdir(dir)
    local scripts = {}

    for _, file in ipairs(files) do
        if file:match("%.sh$") then
            local full_path = dir .. "/" .. file
            local mod_time = vim.fn.getftime(full_path) -- Get file modification time
            table.insert(scripts, { name = file, time = mod_time })
        end
    end

    -- Sort scripts by modification time (newest first)
    table.sort(scripts, function(a, b)
        return a.time > b.time
    end)

    -- Extract sorted filenames
    local sorted_scripts = {}
    for _, script in ipairs(scripts) do
        table.insert(sorted_scripts, script.name)
    end

    return sorted_scripts
end

function getLineContent()
        local linenr = vim.api.nvim_win_get_cursor(0)[1]
        local curline = vim.api.nvim_buf_get_lines(
                0, linenr - 1, linenr, false)[1]
	return curline
end

function run_selected_script()
	local script_name = getLineContent()
    if script_name ~= "" then
        local script_path = vim.fn.expand("~/.nvimScripts/") .. script_name
        vim.cmd("split | terminal bash " .. script_path)
    else
        print("No script selected.")
    end
end

function edit_selected_script()

	local script_name = getLineContent()
    if script_name ~= "" then
        local script_path = vim.fn.expand("~/.nvimScripts/") .. script_name
		vim.api.nvim_command("vsplit "..script_path)
    else
        print("No script selected.")
    end
end

function add_script()
  local width = 40
  local height = 1
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = 'minimal',
    border = 'rounded',
  }
  local script_dir = vim.fn.expand("~/.nvimScripts")

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, opts)

  function make_script()
	local content = getLineContent()
	local script_path = script_dir.."/"..content
	vim.api.nvim_command("vsplit "..script_path)
  end

  vim.cmd("startinsert")
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':q<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', { noremap = true, silent = true })

  vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', ':lua  make_script() vim.api.nvim_win_close('..win..',true)<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'i', '<CR>', '<Esc>:lua  make_script() vim.api.nvim_win_close('..win..',true)<CR>', { noremap = true, silent = true })

end

function delete_script()
  local content = getLineContent()
  local script_dir = vim.fn.expand("~/.nvimScripts")
  local script_path = script_dir.."/"..content
  vim.fn.delete(script_path)
end


function createWindow()
local width = 40
  local height = 10
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = 'minimal',
    border = 'rounded',
  }
  local script_dir = vim.fn.expand("~/.nvimScripts")
  local scripts = list_scripts_in_directory(script_dir)

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, opts)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, scripts)

  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':q<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', ':lua  run_selected_script() vim.api.nvim_win_close('..win..',true)<CR>', { noremap = true, silent = true })

  vim.api.nvim_buf_set_keymap(buf, 'n', 'e', ':lua  edit_selected_script() vim.api.nvim_win_close('..win..',true)<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'a', ':lua  add_script() vim.api.nvim_win_close('..win..',true)<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'd', ':lua  delete_script() vim.api.nvim_win_close('..win..',true)<CR>', { noremap = true, silent = true })
end

vim.api.nvim_set_keymap('n', '<Leader>f', ':lua createWindow()<CR>', { noremap = true, silent = true })

