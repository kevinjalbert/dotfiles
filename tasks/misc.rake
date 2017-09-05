namespace :install do
  desc "Install Fonts"
  task :fonts do
    section "Installing Fonts"

    run %( cp -f #{File.dirname(__FILE__)}/fonts/* $HOME/Library/Fonts )
  end

  desc "Install OS X Configurations"
  task :osx do
    section "Installing OS X Configurations"

    run %( sudo sh ./misc/osx )
  end

  desc "Install fzf bindings"
  task :fzf_bindings do
    section "Installing fzf bindings"

    run %( /usr/local/opt/fzf/install )
  end
end
