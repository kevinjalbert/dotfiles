namespace :install do
  desc "Symlink Dotfiles (root)"
  task :symlinks_root do
    section "Symlinking Vim Files (root)"
    sym_link_for_root '.config/nvim'

    section "Symlinking Zsh Files (root)"
    sym_link_for_root '.zlogin'
    sym_link_for_root '.zshenv'
    sym_link_for_root '.zshrc'
    sym_link_for_root '.zaliases'
    sym_link_for_root '.zexports'

    section "Symlinking Git Files (root)"
    sym_link_for_root '.git'
    sym_link_for_root '.gitconfig'
    sym_link_for_root '.gitignore_global'

    section "Symlinking Bin Files (root)"
    sym_link_for_root 'bin'

    section "Symlinking Misc. Files (root)"
    sym_link_for_root '.agignore'
  end
end
