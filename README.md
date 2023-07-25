# coderun-nvim

A Neovim plugin to run code fast in terminals [**nvterm**](https://github.com/NvChad/nvterm)


https://github.com/ngtuonghy/runner-nvim/assets/116539745/c68063e7-2e84-46a9-8021-dfcee39d7051


## Installation

- install the plugin with lazy.nvim as you would for any other:

```lua


 require("lazy").setup({
 {
  "ngtuonghy/runner-nvim",
  dependencies = {
   "nvchad/nvterm",
    require("runner-nvim").setup()
  },
 },
})

```

## Configuration

```lua
require('runner-nvim').setup(
 terminals = "horizontal",
 commands = {
  go = {
   cmd = "lua run",
  },
 },
)
```

## Usage

```cmd
Runnercode
```
