local utils = require("runner-nvchad.utils")
local listExecutorMap = require("runner-nvchad.listExecutorMap")
local M = {}
local defaultConfig = {
	pos = "sp",
	id = "ekk",
	clear_cmd = false,
	autoremove = false,
	executorMap = listExecutorMap,
}

local function getCmd(mode)
	local current_filetype = vim.bo.filetype
	local current_filename = vim.fn.fnamemodify(vim.fn.expand("%"), ":t")
	local current_filepath = vim.fn.expand("%:p:h")
	local current_withoutext = current_filename:gsub("%..*$", "")
	local realPath = vim.fn.expand("%:p") -- duong dan tuyệt doi
	return utils.replacePlaceholder(
		mode,
		current_filetype,
		current_withoutext,
		realPath,
		current_filepath,
		current_filename
	)
end

function M.runner()
	local current_filetype = vim.bo.filetype
	local getName = defaultConfig.executorMap[current_filetype]
	local clear_cmd = ""
	if getName and getName.comp then
		local getCmdRun = getCmd("comp")
		if defaultConfig.clear_cmd then
			local get_os = utils.detect_operating_system()
			clear_cmd = get_os == "windows" and "clear" or "cls"
		end
		require("nvchad.term").runner({
			pos = defaultConfig.pos,
			cmd = getCmdRun,
			id = defaultConfig.id,
		}, clear_cmd)
		if defaultConfig.autoremove then
			local fileNameWithoutExt = vim.fn.expand("%:p:r")
			utils.async_remove_file(fileNameWithoutExt)
		end
		utils.show_warm_message("No command configured for this filetype.")
	end
end

function M.runnerdbg()
	local current_filetype = vim.bo.filetype
	local getName = defaultConfig.executorMap[current_filetype]
	if getName and getName.dbgComp then
		utils.show_info_message("Debug mode has been compiled")
		local getCmdRun = getCmd("compdbg")
		vim.fn.system(getCmdRun)
		return true
	else
		utils.show_warm_message("No command configured for this filetype.")
		return false
	end
end

M.setup = function(config)
	-- config = config and vim.tbl_deep_extend("force", defaultConfig, config) or defaultConfig
	defaultConfig = vim.tbl_deep_extend("force", defaultConfig, config)
end

vim.cmd("command! Runner lua require'runner-nvchad'.runner()")
-- vim.cmd("command! -range Runnerfast lua require'runner-nvim'.Runnerfast()")
vim.cmd("command! Runnerdbg lua require'runner-nvchad'.runnerdbg()")
return M
