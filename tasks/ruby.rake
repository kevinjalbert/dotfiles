namespace :install do
  desc "Install RVM"
  task :rvm do
    section "Installing Ruby's RVM"

    run %( gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB )
    run %( curl -L https://get.rvm.io | bash -s stable --ruby )
  end
end
