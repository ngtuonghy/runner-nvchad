local M = {}
Default_config = {
	terminal = "horizontal",
	ClearPrevious = false,
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

if vim.g.toggleMakefile == nil then
	vim.g.toggleMakefile = true
end
if vim.g.clearcode == nil then
	vim.g.clearcode = true
end

-- Hàm để toggle chức năng
function M.toggleMakefile()
	vim.g.toggleMakefile = not vim.g.toggleMakefile
	if vim.g.toggleMakefile then
		print("Makefile prior is now enabled!")
	else
		print("Makefile prior is now disabled!")
	end
end

function M.toggleClearprev()
	vim.g.clearcode = not vim.g.clearcode
	if vim.g.clearcode then
		print("Clear Previous Output is now enabled!")
	else
		print("Clear Previous Output is now disabled!")
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
	local current_withoutext = get_current_filename():gsub("%..*$", "")
	local realPath = get_real_path()
	local getcmd = Default_config.commands[current_filetype].cmd
	getcmd = string.gsub(getcmd, "$dir$fileNameWithoutExt", "./" .. current_withoutext)
	getcmd = string.gsub(getcmd, "$fileNameWithoutExt", current_withoutext)
	getcmd = string.gsub(getcmd, "$realPath", realPath)
	getcmd = string.gsub(getcmd, "$dir", current_filepath)
	getcmd = string.gsub(getcmd, "&&", ";")
	getcmd = string.gsub(getcmd, "$fileName", current_filename)
	return getcmd
end

local function detect_operating_system()
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

local function makefile(config, current_file)
	if Default_config.ClearPrevious then
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
	if vim.g.toggleMakefile and get_name and get_name.Makefile then
		makefile(get_name, current_filepath)
	else
		if get_name and get_name.cmd then
			local get_cmd = changeCmd()
			if vim.g.clearcode and Default_config.ClearPrevious then
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
vim.cmd("command! Runnermakefile lua require'runner-nvim'.toggleMakefile()")
vim.cmd("command! Runnerclear lua require'runner-nvim'.toggleClearprev()")
return M
