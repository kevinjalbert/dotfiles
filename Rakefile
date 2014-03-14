=begin
Before running the Rakefile, ensure that the following are installed on your system:
  - Ruby, Vim, Zsh

This Rakefile should not be ran with sudo, it will use sudo where nessecary.

Symlinking root files should be done last to ensure everything is setup first.

To perform tasks in a 'dry run' state append the following to your command:
  ENV[DRY_RUN]=
=end

require 'rake'
require 'pathname'

task :default => [:install]

def get_brew_taps
  return %w(
    phinze/homebrew-cask
  )
end

def get_brew_packages
  return %w(
    ack
    brew-cask
    ctags
    git
    git-extras
    htop
    imagesnap
    vim
    mercurial
    mysql
    rabbitmq
    node
    openssl
    python
    python3
    readline
    libyaml
    sqlite
    subversion
    the_silver_searcher
    zsh
    z
    https://raw.github.com/Homebrew/homebrew-dupes/master/ant.rb
  )
end

def get_brew_cask_packages
  return %w(
    alfred
    appcleaner
    bartender
    controlplane
    cyberduck
    diffmerge
    doxie
    dropbox
    eclipse-ide
    evernote
    f-lux
    firefox
    fluid
    google-chrome
    handbrake
    hip-chat
    hyper-switch
    iterm2
    macvim
    mou
    osxfuse
    postgres
    rescue-time
    sequel-pro
    shortcat
    skype
    sourcetree
    steam
    sublime-text-3
    the-unarchiver
    tuxguitar
    u-torrent
    unetbootin
    vlc
  )
end

desc "Install Everything"
task :install do
  Rake::Task['install:symlinks'].invoke
  Rake::Task['install:brew'].invoke
  Rake::Task['install:brew_packages'].invoke
  Rake::Task['install:brew_cask_packages'].invoke
  Rake::Task['install:rvm'].invoke
  Rake::Task['install:fonts'].invoke
  Rake::Task['install:vundle'].invoke
  Rake::Task['update:vim'].invoke
  Rake::Task['install:prezto'].invoke
  Rake::Task['install:osx'].invoke
  Rake::Task['install:symlinks_root'].invoke
end

desc "Update Everything"
task :update do
  Rake::Task['update:vim'].invoke
  Rake::Task['update:brew_packages'].invoke
  Rake::Task['update:brew_cask_packages'].invoke
end

desc "Uninstall Everything"
task :uninstall do
  Rake::Task['uninstall:brew_packages'].invoke
  Rake::Task['uninstall:brew_cask_packages'].invoke
end

namespace :install do
  desc "Symlink Dotfiles"
  task :symlinks do
    section "Symlinking Vim Files"
    sym_link 'vim/vim',                 '.vim'
    sym_link 'vim/vimrc',               '.vimrc'
    sym_link 'vim/gvimrc',              '.gvimrc'

    section "Symlinking Zsh Files"
    sym_link 'zsh/zprezto',             '.zprezto'
    sym_link 'zsh/zlogin',              '.zlogin'
    sym_link 'zsh/zlogout',             '.zlogout'
    sym_link 'zsh/zprofile',            '.zprofile'
    sym_link 'zsh/zshenv',              '.zshenv'
    sym_link 'zsh/zshrc',               '.zshrc'
    sym_link 'zsh/zpreztorc',           '.zpreztorc'

    section "Symlinking Git Files"
    sym_link 'git/git',                 '.git'
    sym_link 'git/gitconfig',           '.gitconfig'
    sym_link 'git/gitignore_global',    '.gitignore_global'

    section "Symlinking Ruby Files"
    sym_link 'ruby/rspec',              '.rspec'
    sym_link 'ruby/gemrc',              '.gemrc'

    section "Symlinking Misc. Files"
    sym_link 'misc/agignore',           '.agignore'
    sym_link 'misc/ctags',              '.ctags'
  end

  desc "Symlink Dotfiles (root)"
  task :symlinks_root do
    section "Symlinking Vim Files (root)"
    sym_link_for_root '.vim'
    sym_link_for_root '.vimrc'
    sym_link_for_root '.gvimrc'

    section "Symlinking Zsh Files (root)"
    sym_link_for_root '.zprezto'
    sym_link_for_root '.zlogin'
    sym_link_for_root '.zlogout'
    sym_link_for_root '.zprofile'
    sym_link_for_root '.zshenv'
    sym_link_for_root '.zshrc'
    sym_link_for_root '.zpreztorc'

    section "Symlinking Git Files (root)"
    sym_link_for_root '.git'
    sym_link_for_root '.gitconfig'
    sym_link_for_root '.gitignore_global'

    section "Symlinking Ruby Files (root)"
    sym_link_for_root '.rspec'
    sym_link_for_root '.gemrc'

    section "Symlinking Misc. Files (root)"
    sym_link_for_root '.agignore'
    sym_link_for_root '.ctags'
  end

  desc "Install Brew"
  task :brew do
    section "Installing Brew"
    install_brew
  end

  desc "Install Brew Packages"
  task :brew_packages do
    section "Installing Brew Packages"
    install_brew_packages
  end

  desc "Install Brew Cask Packages"
  task :brew_cask_packages do
    section "Installing Brew Cask Packages"
    install_brew_cask_packages
  end

  desc "Install RVM"
  task :rvm do
    section "Installing Ruby's RVM"
    install_rvm
  end

  desc "Install Fonts"
  task :fonts do
    section "Installing Fonts"
    install_fonts
  end

  desc "Install Vundle"
  task :vundle do
    section "Installing Vim's Vundle"
    install_vundle
  end

  desc "Install Prezto"
  task :prezto do
    section "Installing Zsh's Prezto"
    install_prezto
  end

  desc "Install OS X Configurations"
  task :osx do
    section "Installing OS X Configurations"
    install_osx
  end
end

namespace :update do
  desc "Update Vim's plugins"
  task :vim do
    section "Updating Vim's Plugins"
    update_vim
  end

  desc "Update Brew"
  task :brew_packages do
    section "Updating Brew Packages"
    update_brew_packages
  end

  desc "Update Brew Cask"
  task :brew_cask_packages do
    section "Updating Brew Cask Packages"
    update_brew_cask_packages
  end
end

namespace :uninstall do
  desc "Uninstall Brew Packages"
  task :brew_packages do
    section "Uninstalling Brew Packages"
    uninstall_brew_packages
  end

  desc "Uninstall Brew Cask Packages"
  task :brew_cask_packages do
    section "Uninstalling Brew Cask Packages"
    uninstall_brew_cask_packages
  end
end

def section(title, description="")
  seperator_count = (80 - title.length) / 2
  puts ("\n" + "="*seperator_count) + title.upcase + ("="*seperator_count)
  puts "~> Performing as dry run" if ENV['DRY_RUN']
  puts "~> Performing as super user" if ENV['SUDO']
end

def run(cmd)
  puts "~>#{cmd}"
  system cmd unless ENV['DRY_RUN']
end

def update_vim
  run %{ vim -c "BundleInstall" -c "q" -c "q" }
  run %{ cd ~/.vim/bundle/YouCompleteMe && sh install.sh }
end

def update_brew_packages
  run %{ brew update }
  run %{ brew upgrade }
end

def update_brew_cask_packages
  puts "~> Uninstalls and Reinstalls Brew Cask Packages"
  Rake::Task['uninstall:brew_cask_packages'].invoke
  Rake::Task['install:brew_cask_packages'].invoke
end

def uninstall_brew_packages
  run %{ brew rm #{get_brew_packages.join(" ")} }
end

def uninstall_brew_cask_packages
  run %{ brew cask uninstall #{get_brew_cask_packages.join(" ")} }
end

def install_brew
  if RUBY_PLATFORM.downcase.include?("darwin")
    run %{ ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)" }
  end
end

def install_brew_packages
  if RUBY_PLATFORM.downcase.include?("darwin")
    get_brew_taps.each do |package|
      run %{ brew tap #{package} }
    end

    get_brew_packages.each do |package|
      run %{ brew install #{package} }
    end
  end
end

def install_brew_cask_packages
  if RUBY_PLATFORM.downcase.include?("darwin")
    get_brew_cask_packages.each do |package|
      run %{ brew cask install --force #{package} }
    end
    run %{ brew cask alfred link }
  end
end

def install_rvm
  if RUBY_PLATFORM.downcase.include?("darwin")
    run %{ curl -L https://get.rvm.io | bash -s stable --ruby }
  else
    puts "~> Could not install RVM. Check if you were running as root or not using OS X."
  end
end

def install_fonts
  if RUBY_PLATFORM.downcase.include?("darwin")
    run %{ cp -f #{File.dirname(__FILE__)}/fonts/* $HOME/Library/Fonts }
  else
    puts "~> Could not install fonts. Check if you were running as root or not using OS X."
  end
end

def install_prezto
  unless File.exists?(File.join(ENV['ZDOTDIR'] || ENV['HOME'], ".zprezto"))
    run %{ git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" }
    run %{ chsh -s /bin/zsh }
    run %{ sudo chsh -s /bin/zsh }
  else
    puts "~> Could not install Zsh's Prezto. You might already have it installed."
  end
end

def install_vundle
  unless File.exists?(File.join(ENV['HOME'], ".vim/bundle/vundle"))
    run %{ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle }
    run %{ vim +BundleInstall +qall < `tty` > `tty` }
  else
    puts "~> Could not install Vim's Vundle. You might already have it installed."
  end
end

def install_osx
  if RUBY_PLATFORM.downcase.include?("darwin")
    run %{ ./misc/osx }
  else
    puts "~> Could not install OS X Configurations. Check if you were running as root or not using OS X."
  end
end

def sym_link_for_root(file)
  source = Pathname.new("#{ENV["HOME"]}/#{file}")
  target = Pathname.new("/var/root/#{file}")

  puts "\n~> Symlinking #{file}"
  puts "~> Source #{source.to_s}"
  puts "~> Target #{target.to_s}"

  # Symlink the whole directory if target is root user (keeps in sync with user), otherwise we symlink only what is necessary
  if source.directory?
    puts "~> Symlinking whole directory where possible so that root/user remain in sync with eachother"
  end
  run %{ sudo ln -nfs "#{source.to_s}" "#{target.to_s}" }
end

def sym_link(source_file, target_file)
  source = Pathname.new("#{File.dirname(__FILE__)}/#{source_file}")
  target = Pathname.new("#{ENV["HOME"]}/#{target_file}")

  puts "\n~> Symlinking #{source_file}"
  puts "~> Source #{source.to_s}"
  puts "~> Target #{target.to_s}"

  # Make target path if it does not exist and proceed to symlink
  if source.directory?
    target.mkpath unless target.exist? || target.symlink?
    sym_link_directory source, target
  elsif source.file?
    target.parent.mkpath unless target.parent.exist? || target.parent.symlink?
    sym_link_file source, target
  end
end

def sym_link_directory(source, target)
  source.each_child do |child|
    if child.basename.to_s == ".DS_Store"
      next
    end

    if child.directory?
      sym_link_directory child, Pathname.new("#{target.to_s}/#{child.basename.to_s}")
    elsif child.file?
      sym_link_file child, Pathname.new("#{target.to_s}/#{child.basename.to_s}")
    end
  end
end

def sym_link_file(source, target)
  if !target.exist?
    target.parent.mkpath unless target.parent.exist? || target.parent.symlink?
    run %{ ln -nfs "#{source.to_s}" "#{target.to_s}" }
  elsif source.realpath != target.realpath
    puts "Overwriting #{target.to_s}... leaving original at #{target.to_s}.backup..."
    run %{ mv "#{target.to_s}" "#{target.to_s}.backup" }
    run %{ ln -nfs "#{source.to_s}" "#{target.to_s}" }
  end
end
