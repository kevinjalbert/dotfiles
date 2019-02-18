namespace :install do
  desc "Install OS X Configurations"
  task :osx do
    section "Installing OS X Configurations"

    run %( sudo sh ./misc/osx )
  end

  desc "Install fzf bindings"
  task :fzf_bindings do
    section "Installing fzf bindings"

    run %( $(brew --prefix)/opt/fzf/install )
  end
end
