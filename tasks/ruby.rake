namespace :install do
  desc "Install RVM"
  task :rvm do
    section "Installing Ruby's RVM"

    run %( curl -L https://get.rvm.io | bash -s stable --ruby )
  end
end
