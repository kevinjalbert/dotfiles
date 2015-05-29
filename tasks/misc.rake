namespace :install do
  desc "Install Fonts"
  task :fonts do
    section "Installing Fonts"

    run %( cp -f #{File.dirname(__FILE__)}/fonts/* $HOME/Library/Fonts )
  end

  desc "Install OS X Configurations"
  task :osx do
    section "Installing OS X Configurations"

    run %( ./misc/osx )
  end
end
