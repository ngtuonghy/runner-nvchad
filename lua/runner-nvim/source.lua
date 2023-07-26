local M = {}

function M.changeCmd(current_filetype, current_withoutext, realPath, current_filepath, current_filename)
	local getcmd = Default_config.commands[current_filetype].cmd
	getcmd = string.gsub(getcmd, "$dir$fileNameWithoutExt", "./" .. current_withoutext)
	getcmd = string.gsub(getcmd, "$fileNameWithoutExt", current_withoutext)
	getcmd = string.gsub(getcmd, "$realPath", realPath)
	getcmd = string.gsub(getcmd, "$dir", current_filepath)
	getcmd = string.gsub(getcmd, "&&", ";")
	getcmd = string.gsub(getcmd, "$fileName", current_filename)
	return getcmd
end

function M.checkMakefile(path)
	local makefile_upper = vim.fn.findfile("Makefile", path)
	local makefile_lower = vim.fn.findfile("makefile", path)
	if makefile_upper ~= "" or makefile_lower ~= "" then
		return true
	else
		return false
	end
end

function M.get_visual_selection()
	vim.api.nvim_feedkeys("\027", "xt", false)
	local s_start = vim.fn.getpos("'<")
	local s_end = vim.fn.getpos("'>")
	local n_lines = math.abs(s_end[2] - s_start[2]) + 1
	local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
	if next(lines) == nil then
		return nil
	end
	lines[1] = string.sub(lines[1], s_start[3], -1)
	if n_lines == 1 then
		lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
	else
		lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
	end
	return table.concat(lines, "\n")
end

if vim.g.toggleMakefile == nil then
	vim.g.toggleMakefile = true
end

if vim.g.clearcode == nil then
	vim.g.clearcode = true
end

function M.toggleMakefile()
	vim.g.toggleMakefile = not vim.g.toggleMakefile
	if vim.g.toggleMakefile then
		print("Makefile prior is now enabled!")
	else
		print("Makefile prior is now disabled!")
	end
end

function M.detect_operating_system()
	if vim.fn.has("win32") == 1 then
		return "Windows"
	elseif vim.fn.has("mac") == 1 then
		return "macOS"
	elseif vim.fn.has("unix") == 1 then
		return "Linux"
	else
		return "Unknown"
	end
end

function M.async_remove_file(file_path)
	Co = coroutine.create(function()
		vim.defer_fn(function()
			os.remove(file_path)

			coroutine.resume(Co)
		end, 5000)

		coroutine.yield()
	end)

	coroutine.resume(Co)
end

return M
