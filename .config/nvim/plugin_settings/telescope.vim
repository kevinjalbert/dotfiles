lua << EOF
local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    preview = {
      filesize_hook = function(filepath, bufnr, opts)
      local max_bytes = 10000
      local cmd = {"head", "-c", max_bytes, filepath}
      require('telescope.previewers.utils').job_maker(cmd, bufnr, opts)
    end
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    layout_config = {
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
    mappings = {
      i = {
        ["<esc>"] = actions.close
      },
    },
  }
}
EOF

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
