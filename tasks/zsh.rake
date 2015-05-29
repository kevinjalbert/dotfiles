namespace :install do
  desc "Install Prezto"
  task :prezto do
    section "Installing Zsh's Prezto"

    unless File.exists?(File.join(ENV['ZDOTDIR'] || ENV['HOME'], ".zprezto"))
      run %( git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" )
      run %( chsh -s /bin/zsh )
      run %( sudo chsh -s /bin/zsh )
    else
      puts "~> Could not install Zsh's Prezto. You might already have it installed."
    end
  end
end
