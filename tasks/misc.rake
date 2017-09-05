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

  desc "Install RVM"
  task :rvm do
    section "Installing Ruby's RVM"

    run %( gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB )
    run %( curl -L https://get.rvm.io | bash -s stable --ruby )
  end

  desc "Install NVM (node)"
  task :nvm do
    section "Installing Node's NVM"

    run %( curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.4/install.sh | bash )
    run %( nvm install stable )
  end
end
