qs = queries = []

qs << "DROP TABLE IF EXISTS wg_army_unit;"
qs << "DROP TABLE IF EXISTS wg_armies;"
qs << "DROP TABLE IF EXISTS wg_cities;"
qs << "DROP TABLE IF EXISTS wg_players;"
qs << "DROP TABLE IF EXISTS wg_locations;"
qs << "DROP TABLE IF EXISTS wg_alliances;"
qs << "DROP TABLE IF EXISTS wg_unit_defs;"
qs << "DROP VIEW IF EXISTS wg_army_unit_view;"
qs << "DROP VIEW IF EXISTS wg_extended_locations;"

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
    ON DELETE RESTRICT,
    
  KEY armyplayer (`army_id`,`player_id`)
    
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

qs << "
CREATE TABLE `wg_army_unit` (
  `unit_id` BIGINT UNSIGNED NOT NULL,
  `army_id` BIGINT UNSIGNED NOT NULL,
  `player_id` BIGINT UNSIGNED NOT NULL,

  `number` int(11) NOT NULL,
  
  PRIMARY KEY (`unit_id`,`army_id`),
  
  FOREIGN KEY (`army_id`,`player_id`) REFERENCES wg_armies(`army_id`,`player_id`)
    ON DELETE RESTRICT,
  FOREIGN KEY (`unit_id`) REFERENCES wg_unit_defs(`unit_id`)
    ON DELETE RESTRICT
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"


#VIEWS --> LAST ITEMS
qs << "CREATE OR REPLACE VIEW wg_V_army_unit_view AS
   SELECT 
    u_aunit.unit_id AS unit_id,
    u_aunit.army_id AS army_id,
    u_aunit.player_id AS player_id,
    u_def.name AS name,
    u_def.unit_type AS unit_type,
    u_def.attack_type AS attack_type,
    u_aunit.number AS number,
    u_def.power AS power,
    u_def.defence AS defence,
    u_def.movement_speed AS speed,
    u_def.movement_cost AS cost,
    u_def.cargo_capacity AS resources_transported,
    u_def.transport_capacity AS people_transported,
    u_army.is_moving AS is_moving,
    u_army.destination_id AS destination_id,
    u_army.location_id AS location_id
  
   FROM wg_army_unit u_aunit
   LEFT OUTER JOIN wg_unit_defs u_def 
      ON  u_def.unit_id = u_aunit.unit_id
   LEFT OUTER JOIN wg_armies u_army
      ON  u_army.army_id = u_aunit.army_id
   ORDER BY army_id;
"

qs << "CREATE OR REPLACE VIEW wg_V_city_locations AS
   SELECT 
    loc.location_id AS location_id,
    loc.latitude AS latitude,
    loc.longitude AS longitude,
    city.city_id AS city_id,
    city.player_id AS player_id,
    city.name AS city_name,
    city.pts AS city_pts,
    city.ccode AS city_ccode,
    player.name AS player_name,
    player.alliance_id AS alliance_id,
    ally.name AS alliance_name
    
   FROM wg_locations loc
   LEFT OUTER JOIN wg_cities city 
      ON  loc.location_id = city.location_id
   LEFT OUTER JOIN wg_players player
      ON city.player_id = player.player_id
   LEFT OUTER JOIN wg_alliances ally
      ON player.alliance_id = ally.alliance_id
   ORDER BY location_id;
"

qs << "CREATE OR REPLACE VIEW wg_V_army_locations AS
   SELECT 
    loc.location_id AS location_id,
    loc.latitude AS latitude,
    loc.longitude AS longitude,
    army.player_id AS player_id,
    army.army_id AS army_id,
    player.name AS player_name,
    player.alliance_id AS alliance_id,
    ally.name AS alliance_name
    
   FROM wg_locations loc
   JOIN wg_armies army 
      ON  loc.location_id = army.location_id
   LEFT OUTER JOIN wg_players player
      ON army.player_id = player.player_id
   LEFT OUTER JOIN wg_alliances ally
      ON player.alliance_id = ally.alliance_id
   ORDER BY location_id;
"


puts "recreating tables..."
queries.each do |query|
  puts query.split(/\n/)[0..1].join + "..."  
  ActiveRecord::Base.connection.execute query
end