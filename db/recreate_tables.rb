qs = queries = []

qs << "DROP TABLE IF EXISTS wg_armies;"
qs << "DROP TABLE IF EXISTS wg_cities;"
qs << "DROP TABLE IF EXISTS wg_players;"
qs << "DROP TABLE IF EXISTS wg_locations;"
qs << "DROP TABLE IF EXISTS wg_alliances;"

qs << "DROP TABLE IF EXISTS wg_unit_defs;"




qs << "
CREATE TABLE `wg_alliances` (
  `alliance_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  
  PRIMARY KEY (`alliance_id`),
  
  UNIQUE KEY `ally_name` (`name`)
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `wg_players` (
  `player_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `alliance_id` BIGINT UNSIGNED NOT NULL,
  `name` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `salt` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  
  
  PRIMARY KEY (`player_id`),
  
  UNIQUE KEY `player_name` (`name`),
  UNIQUE KEY `player_email` (`email`)  
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `wg_locations` (
  `location_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `latitude` DECIMAL(18,14) NOT NULL,
  `longitude` DECIMAL(18,14) NOT NULL,
  
  PRIMARY KEY (`location_id`),
  
  UNIQUE KEY `latlng` (`latitude`,`longitude`)
  # TODO: not sure if we also need single lat and lng indexes
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `wg_cities` (
  `city_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `location_id` BIGINT UNSIGNED NOT NULL,
  `player_id` BIGINT UNSIGNED NOT NULL,

  `name` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
    
  `pts` int(5) DEFAULT '0', # points for city differentiation (based on population)
  `ccode` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  
  PRIMARY KEY (`city_id`),
  
  FOREIGN KEY (`location_id`) REFERENCES wg_locations(`location_id`)
    ON DELETE RESTRICT,
  FOREIGN KEY (`player_id`) REFERENCES wg_players(`player_id`)
    ON DELETE RESTRICT
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `wg_armies` (
  `army_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `location_id` BIGINT UNSIGNED NOT NULL,
  `player_id` BIGINT UNSIGNED NOT NULL,
  
  `is_moving` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `destination_id` BIGINT UNSIGNED,

  PRIMARY KEY (`army_id`),
  
  FOREIGN KEY (`location_id`) REFERENCES wg_locations(`location_id`)
    ON DELETE RESTRICT,
  FOREIGN KEY (`player_id`) REFERENCES wg_players(`player_id`)
    ON DELETE RESTRICT
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `wg_unit_defs` (
  `unit_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8_unicode_ci NOT NULL,

  `unit_type` char(8) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'Infantry',
  `attack_type` int(11) UNSIGNED NOT NULL DEFAULT 0,

  `power` int(11) NOT NULL,
  `defence` int(11) NOT NULL,
  `movement_speed` int(11) NOT NULL,
  `movement_cost` int(11) NOT NULL DEFAULT 0,
  `cargo_capacity` int(11) NOT NULL,
  `transport_capacity` int(11) NOT NULL DEFAULT 0,


  PRIMARY KEY (`unit_id`)
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

puts "recreating tables..."
queries.each do |query|
  puts query.split(/\n/)[0..1].join + "..."  
  ActiveRecord::Base.connection.execute query
end