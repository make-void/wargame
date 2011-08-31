require "#{Rails.root}/lib/tasks_utils"

namespace :db do
  namespace :cities do
  
    task :dump do
      dump_and_bzip "cities"
      dump_and_bzip "locations"
    end
    
  end
end