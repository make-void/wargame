set :application, "wargame"

set :domain,      "makevoid.com"

set :repository,  "svn://#{domain}/svn/#{application}"
set :user,        "www-data"


set :deploy_to,   "/www/#{application}"

set :use_sudo,    false


set :scm_username, "makevoid"
set :scm_password, File.read("/Users/makevoid/.password").strip

role :app, domain
role :web, domain
role :db,  domain, :primary => true




after :deploy, "deploy:cleanup"
# after :deploy, "deploy:link_uploads"
after :deploy, "db:rename_db_configs"

namespace :deploy do
  
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  
  
  
  desc "Link uploads"
  task :link_uploads do
    run "mkdir -p #{current_path}/public/uploads"
    upload_dir = "work_images"
    run "cd #{current_path}; ln -s #{deploy_to}/shared/#{upload_dir} public/uploads/#{upload_dir}"
    upload_dir = "articles"
    run "cd #{current_path}; ln -s #{deploy_to}/shared/#{upload_dir} public/uploads/#{upload_dir}"
    upload_dir = "projects"
    run "cd #{current_path}; ln -s #{deploy_to}/shared/#{upload_dir} public/uploads/#{upload_dir}"
    upload_dir = "thumbnails"
    run "cd #{current_path}; ln -s #{deploy_to}/shared/#{upload_dir} public/uploads/#{upload_dir}"
    upload_dir = "plates/actives"
    run "cd #{current_path}; mkdir -p public/uploads/plates"
    run "cd #{current_path}; ln -s #{deploy_to}/shared/#{upload_dir} public/uploads/#{upload_dir}"
  end


end

namespace :db do
  
  desc "rename database_deploy.yml"
  task :rename_db_configs do
    run "cd #{current_path}/config; mv database_deploy.yml database.yml"
  end

  desc "Create database"
  task :create do
    run "mysql -u root --password=final33man -e 'CREATE DATABASE IF NOT EXISTS #{application}_production;'"
  end
  
  desc "refine database"
  task :refine do
    run "cd #{current_path}; ruby db/refine.rb production"
  end
  
  desc "Seed database"
  task :seeds do
    run "cd #{current_path}; RAILS_ENV=production rake db:seeds"
  end
  
  desc "Send the local db to production server"
  task :toprod do
    # `rake db:seeds`
    `mysqldump -u root #{application}_development > db/#{application}_development.sql`
    upload "db/#{application}_development.sql", "#{current_path}/db", via: :scp
    run "mysql -u root --password=final33man #{application}_production < #{current_path}/db/#{application}_development.sql"
  end
  
  desc "Get the remote copy of production db"
  task :todev do
    run "mysqldump -u root --password=final33man #{application}_production > #{current_path}/db/#{application}_production.sql"
    download "#{current_path}/db/#{application}_production.sql", "db/#{application}_production.sql"
    local_path = `pwd`.strip
    cmd = "mysql -u root #{application}_development < #{local_path}/db/#{application}_production.sql"
    puts "executing: #{cmd}"
    `#{cmd}`
  end
end


# ...

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end
  
  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} && bundle install --without test"
  end
  
  task :lock, :roles => :app do
    run "cd #{current_release} && bundle lock;"
  end
  
  task :unlock, :roles => :app do
    run "cd #{current_release} && bundle unlock;"
  end
end

# HOOKS
after "deploy:update_code" do
  bundler.bundle_new_release
  # ...
end

