namespace :install do
  desc "Install macOS Configurations"
  task :macos do
    section "Installing macOS Configurations"

    run %( sudo sh ./misc/macos )
  end

  desc "Install fzf bindings"
  task :fzf_bindings do
    section "Installing fzf bindings"

    run %( $(brew --prefix)/opt/fzf/install )
  end
end
