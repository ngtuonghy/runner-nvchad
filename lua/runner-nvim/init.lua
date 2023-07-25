local M = {}
Default_config = {
	terminal = "horizontal",
	clear = false,
	commands = {
		go = {
			cmd = "go run $realPath",
		},
		cpp = {
			cmd = "cd $dir && g++ $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt",
			Makefile = "makefile ",
		},
		java = {
			cmd = "cd $dir && javac $fileName && java $fileNameWithoutExt",
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
		print("Makefile prior is now enabled!")
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
local function get_real_path()
	return vim.fn.expand("%:p")
end

-- end
--	cmd = "cd $dir && g++ $fileName -o $fileNameWithoutExt && $dir $fileNameWithoutExt",
local function changeCmd()
	local current_filepath = get_current_filepath()
	local current_filetype = get_filetype()
	local current_filename = get_current_filename()
	local current_withoutext = get_current_filename():gsub("%.cpp", "")
	local realPath = get_real_path()
	local getcmd = Default_config.commands[current_filetype].cmd
	getcmd = string.gsub(getcmd, "$dir$fileNameWithoutExt", "./" .. current_withoutext)
	getcmd = string.gsub(getcmd, "$realPath", realPath)
	getcmd = string.gsub(getcmd, "$fileNameWithoutExt", current_withoutext)
	getcmd = string.gsub(getcmd, "$dir", current_filepath)
	getcmd = string.gsub(getcmd, "&&", ";")
	getcmd = string.gsub(getcmd, "$fileName", current_filename)
	return getcmd
end

local function detect_operating_system()
	local uname = vim.loop.os_uname()
	if uname.sysname == "Linux" then
		return "Linux"
	elseif uname.sysname == "Darwin" then
		return "macOS"
	elseif uname.sysname == "Windows" then
		return "Windows"
	else
		return "Unknown"
	end
end

local function makefile(config, current_file)
	if Default_config.clear then
		local get_os = detect_operating_system()
		if get_os == "Linux" or get_os == "macOS" then
			require("nvterm.terminal").send("clear", Default_config.terminal)
		elseif get_os == "Windows" then
			require("nvterm.terminal").send("cls", Default_config.terminal)
		else
			print("can't clear terminal ")
		end
	end
	require("nvterm.terminal").send("cd " .. current_file .. " && " .. config.Makefile, Default_config.terminal)
end
function M.Coderun()
	local current_filetype = get_filetype()
	local current_filepath = get_current_filepath()
	local get_name = Default_config.commands[current_filetype]
	if vim.g.my_feature_enabled and get_name and get_name.Makefile then
		makefile(get_name, current_filepath)
	else
		if get_name and get_name.cmd then
			local get_cmd = changeCmd()
			if Default_config.clear then
				local get_os = detect_operating_system()
				if get_os == "Linux" or get_os == "macOS" then
					require("nvterm.terminal").send("clear", Default_config.terminal)
				elseif get_os == "Windows" then
					require("nvterm.terminal").send("cls", Default_config.terminal)
				else
					print("can't clear terminal ")
				end
			end
			require("nvterm.terminal").send(get_cmd, Default_config.terminal)
		else
			print("No command configured for this filetype.")
		end
	end
end
M.setup = function(config)
	Default_config = vim.tbl_deep_extend("force", Default_config, config)
	return Default_config
end

vim.cmd("command! Runnercode lua require'runner-nvim'.Coderun()")
vim.cmd("command! Runnermakefile lua require'runner-nvim'.toggle_my_feature()")
return M
