namespace :install do
  VIM_CONFIG = [
    { name: 'NeoVim', exec: 'nvim', location: '~/.config/nvim' },
    { name: 'Vim', exec: 'vim', location: '~/.vim' }
  ]

  desc "Install Vundle"
  task :vundle do
    VIM_CONFIG.each do |vim_config|
      section "Installing #{vim_config[:name]}'s Vundle"

      if File.exist?("#{vim_config[:location]}/bundle/Vundle.vim")
        puts "~> Could not install #{vim_config[:name]}'s Vundle. You might already have it installed."
      else
        run %( git clone https://github.com/gmarik/Vundle.vim.git #{vim_config[:location]}/bundle/Vundle.vim )
        run %( #{vim_config[:exec]} +BundleInstall +qall < `tty` > `tty` )
      end
    end
  end
end

namespace :update do
  desc "Update Vim's plugins"
  task :vim do
    VIM_CONFIG.each do |vim_config|
      section "Updating #{vim_config[:name]}'s Plugins"

      run %( #{vim_config[:exec]} -c "BundleInstall" -c "q" -c "q" )
      run %( cd #{vim_config[:location]}/bundle/YouCompleteMe && ./install.py )
    end
  end
end
