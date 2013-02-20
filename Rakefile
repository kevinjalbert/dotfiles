=begin
This Rakefile helps install prezto and vim along with any other dotfiles on to the current system.
Some of the rake tasks and methods are heavily inspired/borrowed from skwp/dotfiles off of GitHub.

Before running the Rakefile, ensure that the following are installed on your system:
  - Ruby, Vim, Zsh, Git
=end
require 'rake'

desc "Install dotfiles on current system"
task :install do
  install_prezto

  # Symlink Vim files
  file_operation(Dir.glob('vim'))
  file_operation(Dir.glob('vimrc'))

  # Symlink Zsh/Prezto files
  file_operation(Dir.glob('zlogin'))
  file_operation(Dir.glob('zlogout'))
  file_operation(Dir.glob('zprofile'))
  file_operation(Dir.glob('zshenv'))
  file_operation(Dir.glob('zshrc'))
  file_operation(Dir.glob('zpreztorc'))

  # Git files
  file_operation(Dir.glob('git'))
  file_operation(Dir.glob('gitconfig'))
  file_operation(Dir.glob('gitignore_global'))

  # Ruby files
  file_operation(Dir.glob('rspec'))
  file_operation(Dir.glob('gemrc'))

  install_fonts if RUBY_PLATFORM.downcase.include?("darwin")
  install_vim_vundle
end
task :default => 'install'

private
def run(cmd)
  puts "[Running] #{cmd}"
  `#{cmd}` unless ENV['DEBUG']
end

def install_fonts
  puts "======================================================"
  puts "Installing patched fonts for Powerline."
  puts "======================================================"
  run %{ cp -f $HOME/dotfiles/fonts/* $HOME/Library/Fonts }
  puts
end

def install_prezto
  unless File.exists?(File.join(ENV['ZDOTDIR'] || ENV['HOME'], ".zprezto"))
    run %{ git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" }
  end
  run %{ chsh -s /bin/zsh }
end

def install_vim_vundle
  unless File.exists?(File.join(ENV['HOME'], ".vim/bundle/vundle"))
    run %{ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle }
  end
  run %{ vim +BundleInstall +qall < `tty` > `tty` }
end

def file_operation(files)
  files.each do |f|
    file = f.split('/').last
    source = "#{ENV["PWD"]}/#{f}"
    target = "#{ENV["HOME"]}/.#{file}"

    puts "======================#{file}=============================="
    puts "Source: #{source}"
    puts "Target: #{target}"

    if File.exists?(target) || File.symlink?(target)
      puts "[Overwriting] #{target}...leaving original at #{target}.backup..."
      run %{ mv "$HOME/.#{file}" "$HOME/.#{file}.backup" }
    end

    run %{ ln -nfs "#{source}" "#{target}" }

    puts "=========================================================="
    puts
  end
end
