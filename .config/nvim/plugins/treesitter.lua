local status, treesitter = pcall(require, "nvim-treesitter.configs")
if (not status) then return end

treesitter.setup {
  ensure_installed = {
    "vim",
    "typescript",
    "tsx",
    "javascript",
    "json",
    "lua",
    "gitignore",
    "bash",
    "markdown",
    "css",
    "toml",
    "html"
  },
  highlight = {
    enable = true,
    disable = {},
  },
　indent ={
　　enable =true,
　},
  autotag = {
    enable = true,
  },
}

