module TasksUtils

  def mysql_env
    ENV["RACK_ENV"] || "development"
  end
  
  def mysql_pass
    db_config = YAML.load( File.open("#{Rails.root}/config/database.yml") )[mysql_env]
    db_config["password"] || ""
  end

  def dump_and_bzip(table)
    exec "mysqldump -u root --password=\"#{mysql_pass}\" wargame_#{mysql_env} wg_#{table} > wargame_#{table}.sql", "db"
    exec "tar cvfj wargame_#{table}.sql.bz2 wargame_#{table}.sql", "db"
  end
  
  def unzip_and_import(table)
    exec "tar xvfj wargame_#{table}.sql.bz2", "db"
    exec "mysql -u root --password=\"#{mysql_pass}\" wargame_#{mysql_env} < wargame_#{table}.sql", "db"
  end
  
  def exec(cmd, dir=".")
    puts "executing: #{cmd}"
    puts `cd #{Rails.root}/#{dir}; #{cmd}`
  end
  
end

include TasksUtils