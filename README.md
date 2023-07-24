# coderun-nvim

A Neovim plugin to run code fast in terminals [**nvterm**](https://github.com/NvChad/nvterm)

## Installation

- install the plugin with lazy.nvim as you would for any other:

```lua
 require("lazy").setup({
 {
  "ngtuonghy/coderun-nvim",
  dependencies = {
   "nvchad/nvterm",
    require("coderun-nvim").setup()
  },
 },
})

```

## Configuration

```lua
require('coderun').setup(
 terminals = "horizontal",
 commands = {
  go = {
   cmd = "lua run",
  },
 },
)
```

## Usage

coderun
