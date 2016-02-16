namespace :install do
  desc "Install zgen"
  task :zgen do
    section "Installing zgen"

    unless File.exists?(File.join(ENV['ZDOTDIR'] || ENV['HOME'], ".zsh/zgen"))
      run %( git clone --recursive https://github.com/tarjoilija/zgen.git "${ZDOTDIR:-$HOME}/.zsh/zgen" )
      run %( chsh -s /bin/zsh )
      run %( sudo chsh -s /bin/zsh )
    else
      puts "~> Could not install Zsh's antigen. You might already have it installed."
    end
  end
end
