local utils = require("runner-nvchad.utils")
local listExecutorMap = require("runner-nvchad.listExecutorMap")

local M = {}
defaultConfig = {
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

function M.test()
	if defaultConfig then
		-- Kiểm tra xem executorMap có tồn tại không
		if defaultConfig.executorMap then
			-- Lấy giá trị của executorMap
			local executorMap = defaultConfig.executorMap
			-- Bây giờ bạn có thể làm việc với executorMap ở đây
			-- Ví dụ, in ra tất cả các giá trị của executorMap
			for language, config in pairs(executorMap) do
				print(language, config.comp) -- In ra comp của từng ngôn ngữ
			end
		else
			print("executorMap không tồn tại trong defaultConfig")
		end
	else
		print("defaultConfig không tồn tại")
	end
	-- print(defaultConfig.executorMap.cpp)
end
M.setup = function(config)
	config = config and vim.tbl_deep_extend("force", defaultConfig, config) or defaultConfig
end

vim.cmd("command! Runner lua require'runner-nvchad'.runner()")
vim.cmd("command! Test lua require'runner-nvchad'.test()")
-- vim.cmd("command! -range Runnerfast lua require'runner-nvim'.Runnerfast()")
vim.cmd("command! Runnerdbg lua require'runner-nvchad'.runnerdbg()")
-- vim.cmd("command! Runnermakefile lua require'runner-nvim.source'.toggleMakefile()")
return M
