qs = queries = []


qs << "DROP TABLE IF EXISTS cities;"
qs << "DROP TABLE IF EXISTS locations;"
qs << "DROP TABLE IF EXISTS armies;"


qs << "
CREATE TABLE `cities` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `pts` int(5) DEFAULT '0', # points for city differentiation (based on population)
  `ccode` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `locations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `lat` float DEFAULT NULL,
  `lng` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  # TODO: not sure if we also need single lat and lng indexes
  KEY `latlng` (`lat`,`lng`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"


puts "recreating tables..."
queries.each do |query|
  puts query.split(/\n/)[0..1].join + "..."  
  ActiveRecord::Base.connection.execute query
end