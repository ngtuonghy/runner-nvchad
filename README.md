# runner-nvchad

A Neovim plugin to run code fast in terminals [**nvchad v2.5**](https://github.com/NvChad/NvChad)

https://github.com/ngtuonghy/runner-nvchad/assets/116539745/3f609efd-6fd8-488c-aaaa-7a21c5c3b947

## Installation

- install the plugin with lazy.nvim as you would for any other:

```lua
 require("lazy").setup({

 {
  "ngtuonghy/runner-nvchad",
  config = funtions()
  require("runner-nvchad").setup{}
},

})
```

## Configuration

- The comment plugin needs to be initialised using:

  ```lua
  require("runner-nvchad").setup{}
  ```

- However you can pass in some config options, the defaults are

```lua
require('runner-nvchad').setup{
 terminals = "horizontal", -- "horizontal|vertical|float"
 clearprevious = false, -- clear output previous run
 autoremove = flase, -- auto clear $fileNameWithoutExt
 commands = {
  lua = {
   comp = "lua run $filePath",
  },
  cpp = {
   comp  = "cd $dir && g++ $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt", --default
   dbgcomp = "cd $dir && g++ -g $fileName -o $fileNameWithoutExt", -- default
  },
 },
}
```

- Supported customized
  - $dir: The directory of the code file being run
  - $fileName: The base name of the code file being run
  - $fileNameWithoutExt: The base name of the code file being run without its extension
  - $realPath: absolute path to the current file

## Usage

- run debug before [dap](https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation)

```lua
dap.configurations.cpp = {
 {
  name = "Launch",
  type = "codelldb",
  request = "launch",
  program = function()
   local getDebug = require("runner-nvchad").runnerdbg()
   if getDebug == false then
    return
   else
    return vim.fn.fnamemodify(vim.fn.expand("%:p"), ":r")
   end
  end,
  cwd = "${workspaceFolder}",
  stopOnEntry = false,
  args = {},
 },
}
```

- command

```lua
Runner -- Run code
Runnerfast -- Run code visual select
Runnerdbg -- run code debug
```

- Custom mappings

```lua
map("n", "<leader>rc", "<cmd>Runner<CR>", { desc = "Run code" })
map("v", "<leader>rf", "<cmd>Runnerfast<CR>", { desc = "Run code select" })
```

## Thank you

- Thank's [vscode-code-runner](https://github.com/formulahendry/vscode-code-runner) the main inspiration of this plugin

- Thank's [nvchad](https://github.com/NvChad/NvChad) provide an API that implements this plugin
