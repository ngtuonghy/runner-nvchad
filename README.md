# runner-nvim

A Neovim plugin to run code fast in terminals [**nvterm**](https://github.com/NvChad/nvterm)

<https://github.com/ngtuonghy/runner-nvim/assets/116539745/c68063e7-2e84-46a9-8021-dfcee39d7051>

## Installation

- install the plugin with lazy.nvim as you would for any other:

```lua
 require("lazy").setup({

 {
  "ngtuonghy/runner-nvim",
  dependencies = {"nvchad/nvterm"},
  config = funtions()
  require("runner-nvim").setup{}
},

})
```

## Configuration

- The comment plugin needs to be initialised using:

  ```lua
  require("runner-nvim").setup{}
  ```

- However you can pass in some config options, the defaults are

```lua
require('runner-nvim').setup{
 terminals = "horizontal", -- "horizontal|vertical|float"
 clearprevious = false,
 commands = {
  lua = {
   cmd = "lua run $filePath",
   Makefile = "Make" --lua always priority run makefile
  },
  cpp = {
   cmd  = "cd $dir && g++ $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt",
 },
}
```

## Usage

```lua
Runnercode -- Run code
Runnermakefile -- Toggle priority run Makefile
```

- Custom mappings

```lua
M.runner = {
  n = {
    ["<leader>rc"] = { "<cmd>Runnercode<cr>", "Run code" },
    ["<leader>rm"] = { "<cmd>Runnermakefile<cr>", "Toggle priority run Makefile" },
  },
}
```
