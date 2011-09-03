require "#{Rails.root}/lib/tasks_utils"

namespace :db do
  namespace :cities do
  
    task :dump do
      dump_and_bzip "cities"
      dump_and_bzip "locations"
    end
    
  end
  
  
  task :drop_some_tables => :environment do       
    require "#{Rails.root}/db/default_values"
    include DefaultValues
    drop_all_foreigns DB::Research::Requirement::Tech
  end
end