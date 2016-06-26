namespace :install do
  desc "Symlink Dotfiles"
  task :symlinks do
    section "Symlinking Vim Files"
    sym_link 'vim/vim',                 '.config/nvim'
    sym_link 'vim/vimrc',               '.config/nvim/init.vim'

    section "Symlinking Zsh Files"
    sym_link 'zsh/zprezto',             '.zprezto'
    sym_link 'zsh/zlogin',              '.zlogin'
    sym_link 'zsh/zlogout',             '.zlogout'
    sym_link 'zsh/zprofile',            '.zprofile'
    sym_link 'zsh/zshenv',              '.zshenv'
    sym_link 'zsh/zshrc',               '.zshrc'
    sym_link 'zsh/zpreztorc',           '.zpreztorc'
    sym_link 'zsh/zaliases',            '.zaliases'
    sym_link 'zsh/zexports',            '.zexports'

    section "Symlinking Git Files"
    sym_link 'git/git',                 '.git'
    sym_link 'git/gitconfig',           '.gitconfig'
    sym_link 'git/gitignore_global',    '.gitignore_global'

    section "Symlinking Ruby Files"
    sym_link 'ruby/rspec',              '.rspec'
    sym_link 'ruby/gemrc',              '.gemrc'
    sym_link 'ruby/rubocop.yml',        '.rubocop.yml'

    section "Symlinking Bin Files"
    sym_link 'bin',         'bin'

    section "Symlinking Misc. Files"
    sym_link 'misc/agignore',           '.agignore'
    sym_link 'misc/ctags',              '.ctags'
    sym_link 'misc/tmux.conf',          '.tmux.conf'
    sym_link 'misc/pryrc',              '.pryrc'
  end

  desc "Symlink Dotfiles (root)"
  task :symlinks_root do
    section "Symlinking Vim Files (root)"
    sym_link_for_root '.config/nvim'

    section "Symlinking Zsh Files (root)"
    sym_link_for_root '.zprezto'
    sym_link_for_root '.zlogin'
    sym_link_for_root '.zlogout'
    sym_link_for_root '.zprofile'
    sym_link_for_root '.zshenv'
    sym_link_for_root '.zshrc'
    sym_link_for_root '.zpreztorc'
    sym_link_for_root '.zaliases'
    sym_link_for_root '.zexports'

    section "Symlinking Git Files (root)"
    sym_link_for_root '.git'
    sym_link_for_root '.gitconfig'
    sym_link_for_root '.gitignore_global'

    section "Symlinking Ruby Files (root)"
    sym_link_for_root '.rspec'
    sym_link_for_root '.gemrc'
    sym_link_for_root '.rubocop.yml'

    section "Symlinking Bin Files (root)"
    sym_link_for_root 'bin'

    section "Symlinking Misc. Files (root)"
    sym_link_for_root '.agignore'
    sym_link_for_root '.ctags'
    sym_link_for_root '.tmux.conf'
    sym_link_for_root '.pryrc'
  end
end
