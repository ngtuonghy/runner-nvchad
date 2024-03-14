# runner-nvim

A Neovim plugin to run code fast in terminals [**nvterm**](https://github.com/NvChad/nvterm)

<https://github.com/ngtuonghy/runner-nvim/assets/116539745/4b143ddd-9dc0-425c-821e-6547f3478541>

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

- Supported customized
  - $dir: The directory of the code file being run
  - $fileName: The base name of the code file being run
  - $fileNameWithoutExt: The base name of the code file being run without its extension
  - $realPath: absolute path to the current file

## Usage

- run debug before [dap](https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation)

```lua
local runner = require(runner-nvim)
dap.configurations.cpp = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = function()
      local getDebug = runner.Getdebug()
      if getDebug == nil then
        print "The language is not setting debug mode"
        return nil
      else
        vim.fn.system(getDebug)
      end
      return vim.fn.fnamemodify(vim.fn.expand "%:p", ":r")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
  },
}
```

- command

```lua
Runnercode -- Run code
Runnerfast -- Run code visual select
Runnerdebug -- mode debug
Runnermakefile -- Toggle priority run Makefile
```

- Custom mappings

```lua
M.runner = {
  n = {
    ["<leader>rc"] = { "<cmd>Runnercode<cr>", "Run code" },
    ["<leader>rm"] = { "<cmd>Runnermakefile<cr>", "Toggle priority run Makefile" },
  },
  v = {
    ["<leader>rf"] = { "<cmd>Runnerfast<cr>", "Run code select" },
  },
}
```

## Thank you

- Thank's [vscode-code-runner](https://github.com/formulahendry/vscode-code-runner) the main inspiration of this plugin
  [](https://github.com/NvChad/nvterm)

- Thank's [nvterm](https://github.com/NvChad/nvterm) provide an API that implements this plugin
