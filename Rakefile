=begin
This Rakefile helps install prezto and vim along with any other dotfiles on to the current system.
Some of the rake tasks and methods are heavily inspired/borrowed from skwp/dotfiles off of GitHub.

Before running the Rakefile, ensure that the following are installed on your system:
  - Ruby, Vim, Zsh, Git
=end
require 'rake'
require 'pathname'

desc "Install dotfiles on current system"
task :install, :dry_run do |t, args|
  # Handle dry_run argument to install task (i.e., rake install[true])
  args.with_defaults(:dry_run => "false")
  @dry_run = args[:dry_run]
  puts "Doing a dry run" if @dry_run

  # Symlink Vim files
  file_operation(Dir.glob('vim'))
  file_operation(Dir.glob('vimrc'))
  file_operation(Dir.glob('gvimrc'))

  # Install powerline fonts, vim vundle, and zsh prezto
  install_fonts if RUBY_PLATFORM.downcase.include?("darwin")
  install_vim_vundle
  install_prezto

  # Symlink Zsh/Prezto files
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

end
task :default => 'install'

private
def run(cmd)
  puts "[Running] #{cmd}"
  `#{cmd}` unless @dry_run == "true"
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

    # Only back it up if it's a link to a different file or just another file
    if (File.exists?(target) || File.symlink?(target)) && Pathname.new(target).realpath.to_s != source
        puts "[Overwriting] #{target}...leaving original at #{target}.backup..."
        run %{ mv "$HOME/.#{file}" "$HOME/.#{file}.backup" }
    end

    run %{ ln -nfs "#{source}" "#{target}" }
    puts "=========================================================="
    puts
  end
end
