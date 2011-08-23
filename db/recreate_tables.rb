qs = queries = []


qs << "DROP TABLE IF EXISTS cities;"
qs << "DROP TABLE IF EXISTS locations;"
qs << "DROP TABLE IF EXISTS armies;"


qs << "
CREATE TABLE `locations` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `lat` DECIMAL(18,14) DEFAULT NULL,
  `lng` DECIMAL(18,14) DEFAULT NULL,
  
  PRIMARY KEY (`id`),
  
  UNIQUE KEY `latlng` (`lat`,`lng`)
  # TODO: not sure if we also need single lat and lng indexes
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `cities` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location_id` BIGINT UNSIGNED NOT NULL,
  `pts` int(5) DEFAULT '0', # points for city differentiation (based on population)
  `ccode` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  
  PRIMARY KEY (`id`),
  
  FOREIGN KEY (`location_id`) REFERENCES locations(`id`)
    ON DELETE RESTRICT
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"



puts "recreating tables..."
queries.each do |query|
  puts query.split(/\n/)[0..1].join + "..."  
  ActiveRecord::Base.connection.execute query
end