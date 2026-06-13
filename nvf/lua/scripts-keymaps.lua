local function get_dotfiles_root()
  local uv = vim.uv or vim.loop
  local config_path = uv.fs_realpath(vim.fn.stdpath("config")) or vim.fn.stdpath("config")
  return vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(config_path)))
end

local function get_wiki_root()
  local uv = vim.uv or vim.loop
  local dotfiles_root = get_dotfiles_root()
  local candidates = {
    vim.fn.expand("~/wiki"),
    dotfiles_root .. "/wiki/wiki",
    vim.fn.expand("~/vimwiki"),
    dotfiles_root .. "/wiki/vimwiki",
  }

  for _, wiki_root in ipairs(candidates) do
    if vim.fn.isdirectory(wiki_root) == 1 then
      if uv.fs_stat(wiki_root .. "/index.norg") or uv.fs_stat(wiki_root .. "/index.wiki") then
        return wiki_root
      end
    end
  end

  for _, wiki_root in ipairs(candidates) do
    if vim.fn.isdirectory(wiki_root) == 1 then
      return wiki_root
    end
  end

  return vim.fn.expand("~/wiki")
end

local function open_wiki_index()
  local uv = vim.uv or vim.loop
  local wiki_root = get_wiki_root()
  local candidates = {
    wiki_root .. "/index.norg",
    wiki_root .. "/index.wiki",
    wiki_root .. "/README.md",
  }

  for _, path in ipairs(candidates) do
    if uv.fs_stat(path) then
      vim.cmd.edit(vim.fn.fnameescape(path))
      return
    end
  end

  vim.notify("No wiki index file found in " .. wiki_root, vim.log.levels.WARN)
end

function _G.GetJsonPath()
  local node = vim.treesitter.get_node()
  if not node then
    print("No node found!")
    return
  end

  local path = {}
  while node do
    if node:type() == "pair" then
      local key_node = node:child(0)
      if key_node and key_node:type() == "string" then
        local key_text = vim.treesitter.get_node_text(key_node, 0)
        table.insert(path, 1, key_text)
      end
    end
    node = node:parent()
  end

  print("JSON Path: " .. table.concat(path, "."))
end

function _G.NvfOpenWikiIndex()
  open_wiki_index()
end

function _G.NvfWikiFiles()
  require("telescope.builtin").find_files({
    prompt_title = "Wiki Files",
    cwd = get_wiki_root(),
    follow = true,
    hidden = true,
  })
end

function _G.NvfWikiGrep()
  require("telescope.builtin").live_grep({
    prompt_title = "Wiki Grep",
    search_dirs = { get_wiki_root() },
  })
end

function _G.NvfWikiGrepWord()
  require("telescope.builtin").grep_string({
    prompt_title = "Wiki word",
    search = vim.fn.expand("<cword>"),
    search_dirs = { get_wiki_root() },
  })
end

local diffview_open = false

function _G.NvfDiffviewFileHistory()
  if diffview_open then
    require("diffview").close()
    diffview_open = false
  else
    vim.cmd("DiffviewFileHistory %")
    diffview_open = true
  end
end

function _G.NvfDiffviewToggle()
  if diffview_open then
    require("diffview").close()
    diffview_open = false
  else
    require("diffview").open({})
    diffview_open = true
  end
end

function _G.NvfToggleSupermaven()
  local ok, api = pcall(require, "supermaven-nvim.api")
  if not ok then
    vim.notify("SuperMaven is not installed", vim.log.levels.WARN)
    return
  end
  api.toggle()
  vim.notify("SuperMaven " .. (api.is_running() and "on" or "off"), vim.log.levels.INFO)
end

pcall(function()
  require("bufferline").setup({
    options = {
      numbers = "none",
    },
  })
end)
