=begin
This Rakefile helps install prezto and vim along with any other dotfiles on to the current system.
Some of the rake tasks and methods are heavily inspired/borrowed from skwp/dotfiles off of GitHub.

Before running the Rakefile, ensure that the following are installed on your system:
  - Ruby, Vim, Zsh, Git
=end
require 'rake'
require 'pathname'

desc "Install dotfiles on current system"
task :install, [:dry_run, :super_user] do |t, args|
  # Handle arguments (i.e., rake install[dry_run,super_user]), where params are true||false
  # Running with super_user requires that you be the super_user (i.e., root)
  args.with_defaults(:dry_run => "false", :super_user => "false")
  @dry_run = args[:dry_run] == "true"
  @super_user = args[:super_user] == "true"

  puts "~> Doing a dry run" if @dry_run
  puts "~> Doing a run as super user" if @super_user

  # Symlink Vim files
  sym_link 'vim', '.vim'
  sym_link 'vimrc', '.vimrc'
  sym_link 'vimrc.bundles', '.vimrc.bundles'
  sym_link 'gvimrc', '.gvimrc'

  # Symlink Zsh/Prezto files
  sym_link 'zprezto', '.zprezto'
  sym_link 'zlogin', '.zlogin'
  sym_link 'zlogout', '.zlogout'
  sym_link 'zprofile', '.zprofile'
  sym_link 'zshenv', '.zshenv'
  sym_link 'zshrc', '.zshrc'
  sym_link 'zpreztorc', '.zpreztorc'

  # Symlink Git files
  sym_link 'git', '.git'
  sym_link 'gitconfig', '.gitconfig'
  sym_link 'gitignore_global', '.gitignore_global'

  # Symlink Ag files
  sym_link 'agignore', '.agignore'

  # Symlink Ruby files
  sym_link 'rspec', '.rspec'
  sym_link 'gemrc', '.gemrc'

  # Install brew, rvm, powerline fonts, vim vundle, and zsh prezto
  install_brew
  install_rvm
  install_fonts
  install_vim_vundle
  install_prezto
  install_osx
end
task :default => 'install'

private
def run(cmd)
  puts "Running: #{cmd}"
  system cmd unless @dry_run
end

def install_brew
  if RUBY_PLATFORM.downcase.include?("darwin") && !@super_user
    puts "\n~> Installing Homebrew for Mac"
    run %{ ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)" }
    run %{ brew install ctags }
    run %{ brew install git }
    run %{ brew install git-extras }
    run %{ brew install imagesnap }
    run %{ brew install macvim }
    run %{ brew install mercurial }
    run %{ brew install mysql }
    run %{ brew install rabbitmq }
    run %{ brew install node }
    run %{ brew install openssl }
    run %{ brew install python }
    run %{ brew install python3 }
    run %{ brew install readline }
    run %{ brew install sqlite }
    run %{ brew install subversion }
    run %{ brew install the_silver_searcher }
    run %{ brew install zsh }
    run %{ brew install z }
    run %{ brew install https://raw.github.com/Homebrew/homebrew-dupes/master/ant.rb }
  end
end

def install_rvm
  if RUBY_PLATFORM.downcase.include?("darwin") && !@super_user
    puts "\n~> Installing Ruby Version Manager (RVM)"
    run %{ curl -L https://get.rvm.io | bash -s stable --ruby }
  end
end

def install_fonts
  if RUBY_PLATFORM.downcase.include?("darwin") && !@super_user
    puts "\n~> Installing patched fonts for Powerline"
    run %{ cp -f #{ENV["PWD"]}/fonts/* $HOME/Library/Fonts }
  end
end

def install_prezto
  unless File.exists?(File.join(ENV['ZDOTDIR'] || ENV['HOME'], ".zprezto"))
    puts "\n~> Installing prezto for zsh"
    run %{ git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" }
    run %{ chsh -s /bin/zsh }
  end
end

def install_vim_vundle
  unless File.exists?(File.join(ENV['HOME'], ".vim/bundle/vundle"))
    puts "\n~> Installing vim's vundle and plugins"
    run %{ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle }
    run %{ vim +BundleInstall +qall < `tty` > `tty` }
  end
end

def install_osx
  if RUBY_PLATFORM.downcase.include?("darwin") && !@super_user
    puts "\n~> Installing OSX changes and configurations"
    run %{ ./osx }
  end
end

def sym_link(source_file, target_file)
  source = Pathname.new("#{ENV["PWD"]}/#{source_file}")
  target = Pathname.new("#{ENV["HOME"]}/#{target_file}")

  puts "\n~> Symlinking #{source_file}"
  puts "Source: #{source.to_s}"
  puts "Target: #{target.to_s}"

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
    if child.directory?
      sym_link_directory child, Pathname.new("#{target.to_s}/#{child.basename.to_s}")
    elsif child.file?
      sym_link_file child, Pathname.new("#{target.to_s}/#{child.basename.to_s}")
    end
  end
end

def sym_link_file(source, target)
  if !target.exist?
    run %{ ln -nfs "#{source.to_s}" "#{target.to_s}" }
  elsif source.realpath != target.realpath
    puts "Overwriting #{target.to_s}... leaving original at #{target.to_s}.backup..."
    run %{ mv "#{target.to_s}" "#{target.to_s}.backup" }
    run %{ ln -nfs "#{source.to_s}" "#{target.to_s}" }
  end
end
