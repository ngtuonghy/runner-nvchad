# coderun-nvim

A Neovim plugin to run code fast in terminals [**nvterm**](https://github.com/NvChad/nvterm)

## Installation

- install the plugin with lazy.nvim as you would for any other:

```lua

https://github.com/ngtuonghy/runner-nvim/assets/116539745/82c649d0-cffc-4231-9cb1-a9425a5d499f


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
