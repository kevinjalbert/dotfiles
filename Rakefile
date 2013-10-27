=begin
Before running the Rakefile, ensure that the following are installed on your system:
  - Ruby, Vim, Zsh

To perform tasks in a 'dry run' state append the following to your command:
  ENV[DRY_RUN]=

To perform tasks in a 'sudo' state append the following to your command:
  ENV[SUDO]=
=end

require 'rake'
require 'pathname'

task :default => [:install]

desc "Install Everything"
task :install do
  Rake::Task['install:symlinks'].invoke
  Rake::Task['install:brew'].invoke
  Rake::Task['install:brew_packages'].invoke
  Rake::Task['install:rvm'].invoke
  Rake::Task['install:fonts'].invoke
  Rake::Task['install:vundle'].invoke
  Rake::Task['update:vim'].invoke
  Rake::Task['install:prezto'].invoke
  Rake::Task['install:osx'].invoke
end

namespace :update do
  desc "Update Vim's plugins"
  task :vim do
    section "Updating Vim's Plugins"
    run %{ vim +BundleInstall +qall < `tty` > `tty` }
    run %{ cd ~/.vim/bundle/YouCompleteMe && sh install.sh }
  end

  desc "Update Brew"
  task :brew do
    section "Updating Brew"
    run %{ brew update }
    run %{ brew upgrade }
  end
end

namespace :uninstall do
  desc "Uninstall Brew Packages"
  task :brew_packages do
    section "Uninstalling Brew Packages"
    run %{ brew rm $(brew list) }
  end
end

namespace :install do
  desc "Symlink Dotfiles"
  task :symlinks do
    section "Symlinking Vim Files"
    sym_link 'vim',                 '.vim'
    sym_link 'vimrc',               '.vimrc'
    sym_link 'vimrc.bundles',       '.vimrc.bundles'
    sym_link 'gvimrc',              '.gvimrc'

    section "Symlinking Zsh Files"
    sym_link 'zprezto',             '.zprezto'
    sym_link 'zlogin',              '.zlogin'
    sym_link 'zlogout',             '.zlogout'
    sym_link 'zprofile',            '.zprofile'
    sym_link 'zshenv',              '.zshenv'
    sym_link 'zshrc',               '.zshrc'
    sym_link 'zpreztorc',           '.zpreztorc'

    section "Symlinking Git Files"
    sym_link 'git',                 '.git'
    sym_link 'gitconfig',           '.gitconfig'
    sym_link 'gitignore_global',    '.gitignore_global'

    section "Symlinking Ag Files"
    sym_link 'agignore',            '.agignore'

    section "Symlinking Ruby Files"
    sym_link 'rspec',               '.rspec'
    sym_link 'gemrc',               '.gemrc'
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

def install_brew
  if RUBY_PLATFORM.downcase.include?("darwin") && !ENV['SUDO']
    run %{ ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)" }
  end
end

def install_brew_packages
  if RUBY_PLATFORM.downcase.include?("darwin") && !ENV['SUDO']
    run %{ brew install ctags }
    run %{ brew install git }
    run %{ brew install git-extras }
    run %{ brew install imagesnap }
    run %{ brew install vim }
    run %{ brew install macvim }
    run %{ brew install mercurial }
    run %{ brew install mysql }
    run %{ brew install rabbitmq }
    run %{ brew install node }
    run %{ brew install openssl }
    run %{ brew install python }
    run %{ brew install python3 }
    run %{ brew install readline }
    run %{ brew install libyaml }
    run %{ brew install sqlite }
    run %{ brew install subversion }
    run %{ brew install the_silver_searcher }
    run %{ brew install zsh }
    run %{ brew install z }
    run %{ brew install https://raw.github.com/Homebrew/homebrew-dupes/master/ant.rb }
  end
end

def install_rvm
  if RUBY_PLATFORM.downcase.include?("darwin") && !ENV['SUDO']
    run %{ curl -L https://get.rvm.io | bash -s stable --ruby }
  else
    puts "~> Could not install RVM. Check if you were running as root or not using OS X."
  end
end

def install_fonts
  if RUBY_PLATFORM.downcase.include?("darwin") && !ENV['SUDO']
    run %{ cp -f #{ENV["PWD"]}/fonts/* $HOME/Library/Fonts }
  else
    puts "~> Could not install fonts. Check if you were running as root or not using OS X."
  end
end

def install_prezto
  unless File.exists?(File.join(ENV['ZDOTDIR'] || ENV['HOME'], ".zprezto"))
    run %{ git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" }
    run %{ chsh -s /bin/zsh }
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
  if RUBY_PLATFORM.downcase.include?("darwin") && !ENV['SUDO']
    run %{ ./osx }
  else
    puts "~> Could not install OS X Configurations. Check if you were running as root or not using OS X."
  end
end

def sym_link(source_file, target_file)
  source = Pathname.new("#{ENV["PWD"]}/#{source_file}")
  target = Pathname.new("#{ENV["HOME"]}/#{target_file}")

  puts "\n~> Symlinking #{source_file}"
  puts "~> Source #{source.to_s}"
  puts "~> Target #{target.to_s}"

  # Make target path if it does not exist and proceed to symlink
  if source.directory?
    target.mkpath unless target.exist?
    sym_link_directory source, target
  elsif source.file?
    target.parent.mkpath unless target.parent.exist?
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
    target.parent.mkpath unless target.parent.exist?
    run %{ ln -nfs "#{source.to_s}" "#{target.to_s}" }
  elsif source.realpath != target.realpath
    puts "Overwriting #{target.to_s}... leaving original at #{target.to_s}.backup..."
    run %{ mv "#{target.to_s}" "#{target.to_s}.backup" }
    run %{ ln -nfs "#{source.to_s}" "#{target.to_s}" }
  end
end
