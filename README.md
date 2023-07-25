# coderun-nvim

A Neovim plugin to run code fast in terminals [**nvterm**](https://github.com/NvChad/nvterm)

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
