MAS_FILE = File.expand_path('../../mas.txt', __FILE__)

namespace :install do
  desc 'Install mas'
  task :mas do
    section 'Installing mac app store applications'

    mas_applications.each do |application|
      run %( mas install #{application} )
    end
  end
end

namespace :update do
  desc 'Update mac app store applications'
  task :mas do
    section 'Updating mac app store applications'

    run %( mas upgrade )
  end
end

namespace :backup do
  desc 'Backup mac app store applications'
  task :mas do
    section 'Backing up mac app store applications'

    run %( mas list > #{MAS_FILE} )
  end
end

def mas_applications
  File.readlines(MAS_FILE).map(&:split).map(&:first)
end
