local M = {}
Default_config = {
	terminal = "horizontal",
	commands = {
		go = {
			cmd = "go run",
		},
		cpp = {
			cmd = "g++",
		},
	},
}

if vim.g.my_feature_enabled == nil then
	vim.g.my_feature_enabled = true
end

-- Hàm để toggle chức năng
function M.toggle_my_feature()
	vim.g.my_feature_enabled = not vim.g.my_feature_enabled
	if vim.g.my_feature_enabled then
		print("Makefile is now enabled!")
	else
		print("Makefile is now disabled!")
	end
end

local function get_filetype()
	local bufnr = vim.api.nvim_get_current_buf()
	local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
	return filetype
end

local function get_current_filename()
	return vim.fn.fnamemodify(vim.fn.expand("%"), ":t")
end
local function get_current_filepath()
	return vim.fn.expand("%:p:h")
end

-- local function check_makefile()
-- 	local makefile_exists = vim.fn.filereadable("Makefile") == 1
-- 	if makefile_exists then
-- 		return "Thư mục hiện tại có tệp Makefile."
-- 	else
-- 		return "Thư mục hiện tại không có tệp Makefile."
-- 	end
-- end

local function cpp(config, current_file)
	local compile_cmd = get_current_filename() .. " -o " .. get_current_filename():gsub("%.cpp", "")
	local run_cmd = get_current_filename():gsub("%.cpp", "")
	require("nvterm.terminal").send(
		"cd " .. current_file .. " && " .. config.cmd .. " " .. compile_cmd .. " && " .. "./" .. run_cmd,
		Default_config.terminal
	)
end
local function rust(config, current_file)
	local compile_cmd = get_current_filename() .. get_current_filename():gsub("%.rs", "")
	local run_cmd = get_current_filename():gsub("%.rs", "")
	require("nvterm.terminal").send(
		"cd " .. current_file .. "&&" .. config.cmd .. " " .. compile_cmd .. " && " .. run_cmd,
		Default_config.terminal
	)
end

local function makefile(config, current_file)
	require("nvterm.terminal").send("cd " .. current_file .. " && " .. config.Makefile, Default_config.terminal)
end
function M.Coderun()
	local current_filetype = get_filetype()
	local current_file = get_current_filepath()
	local config = Default_config.commands[current_filetype]

	if vim.g.my_feature_enabled and config and config.Makefile then
		makefile(config, current_file)
	else
		if config and config.cmd then
			if current_filetype == "cpp" then
				cpp(config, current_file)
			elseif current_filetype == "rust" then
				rust(config, current_file)
			else
				require("nvterm.terminal").send(
					"cd " .. current_file .. " && " .. config.cmd .. " " .. get_current_filename(),
					Default_config.terminal
				)
			end
		else
			print("No command configured for this filetype.")
		end
	end
end
M.setup = function(config)
	Default_config = vim.tbl_deep_extend("force", Default_config, config)
	return Default_config
end

vim.cmd("command! Runnercode lua require'coderun'.Coderun()")
vim.cmd("command! Runnermakefile lua require'coderun'.toggle_my_feature()")
return M
