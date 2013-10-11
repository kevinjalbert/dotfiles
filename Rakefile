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

  puts "Doing a dry run" if @dry_run
  puts "Doing a run as super user" if @super_user

  # Symlink Vim files
  file_operation(Dir.glob('vim'))
  file_operation(Dir.glob('vimrc'))
  file_operation(Dir.glob('gvimrc'))

  # Symlink Zsh/Prezto files
  file_operation(Dir.glob('zprezto/**/*'))
  file_operation(Dir.glob('zlogin'))
  file_operation(Dir.glob('zlogout'))
  file_operation(Dir.glob('zprofile'))
  file_operation(Dir.glob('zshenv'))
  file_operation(Dir.glob('zshrc'))
  file_operation(Dir.glob('zpreztorc'))

  # Symlink Git files
  file_operation(Dir.glob('git'))
  file_operation(Dir.glob('gitconfig'))
  file_operation(Dir.glob('gitignore_global'))

  # Symlink Ruby files
  file_operation(Dir.glob('rspec'))
  file_operation(Dir.glob('gemrc'))

  install_fonts
  install_vim_vundle
  install_prezto
  install_osx

end
task :default => 'install'

private
def run(cmd)
  puts "[Running] #{cmd}"
  system cmd unless @dry_run == "true"
end

def install_fonts
  if RUBY_PLATFORM.downcase.include?("darwin") && !@super_user
    puts "\n~> Installing patched fonts for Powerline."
    run %{ cp -f #{ENV["PWD"]}/fonts/* $HOME/Library/Fonts }
  end
end

def install_prezto
  unless File.exists?(File.join(ENV['ZDOTDIR'] || ENV['HOME'], ".zprezto"))
    puts "\n~> Installing prezto for zsh."
    run %{ git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" }
    run %{ chsh -s /bin/zsh }
  end
end

def install_vim_vundle
  unless File.exists?(File.join(ENV['HOME'], ".vim/bundle/vundle"))
    puts "\n~> Installing vim's vundle and plugins."
    run %{ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle }
    run %{ vim +BundleInstall +qall < `tty` > `tty` }
  end
end

def install_osx
  if RUBY_PLATFORM.downcase.include?("darwin") && !@super_user
    puts "\n~> Installing OSX changes and configurations."
    run %{ ./osx }
  end
end

def file_operation(files)
  files.each do |file|
    source = "#{ENV["PWD"]}/#{file}"
    target = "#{ENV["HOME"]}/.#{file}"

    puts "\n~> #{file}"
    puts "Source: #{source}"
    puts "Target: #{target}"

    if File.exists?(target)
      if File.directory?(source)
        puts "Ignoring existing directory at target location"
      elsif (Pathname.new(target).realpath.to_s == source || File.symlink?(target))
        puts "Ignoring target which is already symlinked"
      else
        puts "[Overwriting] #{target}...leaving original at #{target}.backup..."
        run %{ mv "$HOME/.#{file}" "$HOME/.#{file}.backup" }
        run %{ ln -nfs "#{source}" "#{target}" }
      end
    else
      run %{ ln -nfs "#{source}" "#{target}" }
    end
  end
end
