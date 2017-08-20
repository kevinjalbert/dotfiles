namespace :install do
  desc "Install vim-plug"
  task :vim_plug do
    section "Installing NeoVim's vim-plug"
    run %( curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim )
  end
end

namespace :update do
  desc "Update NeoVim's plugins"
  task :vim do
    section "Updating NeoVim's Plugins"

    puts "Installing python compatibility for neovim"
    run %( pip2 install neovim --upgrade )
    run %( pip3 install neovim --upgrade )

    puts "Installing Plugins for NeoVim"
    run %( nvim -c "PlugInstall" -c "q" -c "q" )
  end
end
