local source = require("runner-nvim.source")

local M = {}
Default_config = {
	terminal = "horizontal",
	clearprevious = false,
	autoremove = false,
	commands = {
		javascript = { cmd = "node $realPath" },
		java = { cmd = "cd $dir && javac $fileName && java $fileNameWithoutExt" },
		c = { cmd = "cd $dir && gcc $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt" },
		zig = { cmd = "zig run $realPath" },
		cpp = { cmd = "cd $dir && g++ $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt" },
		php = { cmd = "php $realPath" },
		python = { cmd = "python -u $realPath" },
		perl = { cmd = "perl $realPath" },
		perl6 = { cmd = "perl6 $realPath" },
		ruby = { cmd = "ruby $realPath" },
		go = { cmd = "go run $realPath" },
		lua = { cmd = "lua $realPath" },
		groovy = { cmd = "groovy $realPath" },
		powershell = { cmd = "powershell -ExecutionPolicy ByPass -File $realPath" },
		bat = { cmd = "cmd /c $realPath" },
		shellscript = { cmd = "bash $realPath" },
		fsharp = { cmd = "fsi $realPath" },
		csharp = { cmd = "scriptcs $realPath" },
		vbscript = { cmd = "cscript //Nologo $realPath" },
		typescript = { cmd = "ts-node $realPath" },
		coffeescript = { cmd = "coffee $realPath" },
		scala = { cmd = "scala $realPath" },
		swift = { cmd = "swift $realPath" },
		julia = { cmd = "julia $realPath" },
		crystal = { cmd = "crystal $realPath" },
		ocaml = { cmd = "ocaml $realPath" },
		r = { cmd = "Rscript $realPath" },
		applescript = { cmd = "osascript $realPath" },
		clojure = { cmd = "lein exec $realPath" },
		haxe = { cmd = "haxe --cwd $dirWithoutTrailingSlash --run $fileNameWithoutExt" },
		rust = { cmd = "cd $dir && rustc $fileName && $dir$fileNameWithoutExt" },
		racket = { cmd = "racket $realPath" },
		scheme = { cmd = "csi -script $realPath" },
		ahk = { cmd = "autohotkey $realPath" },
		autoit = { cmd = "autoit3 $realPath" },
		dart = { cmd = "dart $realPath" },
		pascal = { cmd = "cd $dir && fpc $fileName && $dir$fileNameWithoutExt" },
		d = { cmd = "cd $dir && dmd $fileName && $dir$fileNameWithoutExt" },
		haskell = { cmd = "runghc $realPath" },
		nim = { cmd = "nim compile --verbosity:0 --hints:off --run $realPath" },
		lisp = { cmd = "sbcl --script $realPath" },
		kit = { cmd = "kitc --run $realPath" },
		v = { cmd = "v run $realPath" },
		sass = { cmd = "sass --style expanded $realPath" },
		scss = { cmd = "scss --style expanded $realPath" },
		less = { cmd = "cd $dir && lessc $fileName $fileNameWithoutExt.css" },
		FortranFreeForm = { cmd = "cd $dir && gfortran $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt" },
		fortran_modern = { cmd = "cd $dir && gfortran $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt" },
		fortran_fixed_form = { cmd = "cd $dir && gfortran $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt" },
		fortran = { cmd = "cd $dir && gfortran $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt" },
		sml = { cmd = "cd $dir && sml $fileName" },
	},
}
local function show_error_message(message)
	vim.notify(message, vim.log.levels.ERROR, { title = "RUNNER-NVIM" })
end

local function show_warm_message(message)
	vim.notify(message, vim.log.levels.WARN, { title = "RUNNER-NVIM" })
end

local function makefile(config, current_file)
	if Default_config.clearprevious then
		local get_os = source.detect_operating_system()
		if get_os == "Linux" or get_os == "macOS" then
			require("nvterm.terminal").send("clear", Default_config.terminal)
		elseif get_os == "Windows" then
			require("nvterm.terminal").send("cls", Default_config.terminal)
		else
			show_error_message("can't clear terminal")
		end
	end
	require("nvterm.terminal").send("cd " .. current_file .. " && " .. config.Makefile, Default_config.terminal)
end

local function get_filetype()
	local bufnr = vim.api.nvim_get_current_buf()
	local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
	return filetype
end

function M.Runnercode()
	local current_filetype = get_filetype()
	local current_filename = vim.fn.fnamemodify(vim.fn.expand("%"), ":t")
	local current_filepath = vim.fn.expand("%:p:h")
	local current_withoutext = current_filename:gsub("%..*$", "")
	local realPath = vim.fn.expand("%:p") -- duong dan tuyệt doi
	local get_name = Default_config.commands[current_filetype]
	if vim.g.toggleMakefile and get_name and get_name.Makefile then
		if source.checkMakefile(current_filepath) == true then
			makefile(get_name, current_filepath)
		else
			show_warm_message("Makefile not found: " .. current_filepath)
		end
	else
		if get_name and get_name.cmd then
			local get_cmd =
				source.changeCmd(current_filetype, current_withoutext, realPath, current_filepath, current_filename)
			if Default_config.clearprevious then
				local get_os = source.detect_operating_system()
				if get_os == "Linux" or get_os == "macOS" then
					require("nvterm.terminal").send("clear", Default_config.terminal)
				elseif get_os == "Windows" then
					require("nvterm.terminal").send("cls", Default_config.terminal)
				else
					show_error_message("can't clear terminal")
				end
			end
			require("nvterm.terminal").send(get_cmd, Default_config.terminal)
			if Default_config.autoremove then
				local fileNameWithoutExt = vim.fn.expand("%:p:r")
				source.async_remove_file(fileNameWithoutExt)
			end
		else
			show_warm_message("No command configured for this filetype.")
		end
	end
end

M.Runnerfast = function()
	local current_file = vim.fn.expand("%:p") -- Lấy đường dẫn tuyệt đối của tệp hiện tại
	local current_filename = vim.fn.fnamemodify(current_file, ":t") -- Lấy tên tệp từ đường dẫn
	local create_file_select = current_file:gsub(current_filename, "temprunner" .. current_filename)
	-- print("filepath: " .. create_file_select)
	local get_select_vistual = source.get_visual_selection()

	local file = io.open(create_file_select, "w")
	if file then
		file:write(get_select_vistual)
		file:close()
		local current_filetype = get_filetype()
		local filename_tmp = vim.fn.fnamemodify(create_file_select, ":t")
		local current_filepath = vim.fn.expand("%:p:h")
		local current_withoutext_tmp = filename_tmp:gsub("%..*$", "")
		local realPath = create_file_select

		local get_name = Default_config.commands[current_filetype]
		if get_name and get_name.cmd then
			local get_cmd =
				source.changeCmd(current_filetype, current_withoutext_tmp, realPath, current_filepath, filename_tmp)
			require("nvterm.terminal").send(get_cmd, Default_config.terminal)
		end
	else
		show_error_message("cannot open file for write")
	end
	source.async_remove_file(create_file_select)
end

M.setup = function(config)
	Default_config = vim.tbl_deep_extend("force", Default_config, config)
end

vim.cmd("command! Runnercode lua require'runner-nvim'.Runnercode()")
vim.cmd("command! -range Runnerfast lua require'runner-nvim'.Runnerfast()")
vim.cmd("command! Runnermakefile lua require'runner-nvim.source'.toggleMakefile()")
return M
