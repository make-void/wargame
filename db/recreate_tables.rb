qs = queries = []


qs << "DROP TABLE IF EXISTS bdrb_job_queues;"
qs << "DROP TABLE IF EXISTS wg_struct_queue;"         
qs << "DROP TABLE IF EXISTS wg_tech_queue;"            
qs << "DROP TABLE IF EXISTS wg_unit_queue;"            
qs << "DROP TABLE IF EXISTS wg_tech_tech_req_defs;"    
qs << "DROP TABLE IF EXISTS wg_tech_struct_req_defs;"  
qs << "DROP TABLE IF EXISTS wg_unit_tech_req_defs;"    
qs << "DROP TABLE IF EXISTS wg_unit_struct_req_defs;"  
qs << "DROP TABLE IF EXISTS wg_struct_tech_req_defs;"  
qs << "DROP TABLE IF EXISTS wg_struct_struct_req_defs;"
qs << "DROP TABLE IF EXISTS wg_city_unit;"             
qs << "DROP TABLE IF EXISTS wg_army_unit;"             
qs << "DROP TABLE IF EXISTS wg_armies;"                
qs << "DROP TABLE IF EXISTS wg_struct;"                
qs << "DROP TABLE IF EXISTS wg_techs;"                 
qs << "DROP TABLE IF EXISTS wg_cities;"                
qs << "DROP TABLE IF EXISTS wg_players;"               
qs << "DROP TABLE IF EXISTS wg_locations;"             
qs << "DROP TABLE IF EXISTS wg_alliances;"             
qs << "DROP TABLE IF EXISTS wg_unit_defs;"             
qs << "DROP TABLE IF EXISTS wg_struct_defs;"           
qs << "DROP TABLE IF EXISTS wg_tech_defs;"             

qs << "DROP VIEW IF EXISTS wg_v_army_unit;"
qs << "DROP VIEW IF EXISTS wg_v_city_locations;"
qs << "DROP VIEW IF EXISTS wg_v_army_locations;"


qs << "
CREATE TABLE `wg_alliances` (
  `alliance_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  
   /* ENTRY DATA */
  `created_at` datetime DEFAULT NULL,
  
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
  
  
   /* ENTRY DATA */
  `created_at` datetime DEFAULT NULL,
  
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
  `location_id` BIGINT UNSIGNED NOT NULL UNIQUE,
  `player_id` BIGINT UNSIGNED NOT NULL,

  `name` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
    
  `pts` int(5) DEFAULT '0', # points for city differentiation (based on population)
  `ccode` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  
  `gold_production` int(11) NOT NULL DEFAULT 45,
  `steel_production` int(11) NOT NULL DEFAULT 35,
  `oil_production` int(11) NOT NULL DEFAULT 15,
  
  `gold_stored` int(11) NOT NULL DEFAULT 2500,
  `steel_stored` int(11) NOT NULL DEFAULT 2500,
  `oil_stored` int(11) NOT NULL DEFAULT 2500,

  `gold_storage_space` int(11) NOT NULL DEFAULT 2500,
  `steel_storage_space` int(11) NOT NULL DEFAULT 2500,
  `oil_storage_space` int(11) NOT NULL DEFAULT 2500,
  
  /* HELPER FOR RESOURCES CALCULATION */
  `last_update_at` datetime DEFAULT NULL,

  
  PRIMARY KEY (`city_id`),
  
  FOREIGN KEY (`location_id`) REFERENCES wg_locations(`location_id`)
    ON DELETE RESTRICT,
  FOREIGN KEY (`player_id`) REFERENCES wg_players(`player_id`)
    ON DELETE RESTRICT,
    
  KEY city_player (`city_id`,`player_id`)
        
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `wg_armies` (
  `army_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `location_id` BIGINT UNSIGNED NOT NULL,
  `player_id` BIGINT UNSIGNED NOT NULL,
  
  `is_moving` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `destination_id` BIGINT UNSIGNED,
  
  `speed` int(11) NOT NULL DEFAULT 0,
  
  `gold_stored` int(11) NOT NULL DEFAULT 0,
  `steel_stored` int(11) NOT NULL DEFAULT 0,
  `oil_stored` int(11) NOT NULL DEFAULT 0,

  `storage_space` int(11) NOT NULL DEFAULT 0,
  
   /* ENTRY DATA */
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,

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
  `name` varchar(150) COLLATE utf8_unicode_ci NOT NULL UNIQUE,

  `unit_type` char(8) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'Infantry',
  `attack_type` int(11) UNSIGNED NOT NULL DEFAULT 0,

  `power` int(11) NOT NULL,
  `defense` int(11) NOT NULL,
  `movement_speed` int(11) NOT NULL,
  `movement_cost` int(11) NOT NULL DEFAULT 0,
  `cargo_capacity` int(11) NOT NULL,
  `transport_capacity` int(11) NOT NULL DEFAULT 0,
  
  `gold_cost` int(11) NOT NULL,
  `steel_cost` int(11) NOT NULL,
  `oil_cost` int(11) NOT NULL DEFAULT 0,


  PRIMARY KEY (`unit_id`),
  
  KEY (`unit_id`, `unit_type`)
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `wg_army_unit` (
  `unit_id` BIGINT UNSIGNED NOT NULL,
  `army_id` BIGINT UNSIGNED NOT NULL,
  `player_id` BIGINT UNSIGNED NOT NULL,

  `number` int(11) NOT NULL,
  
   /* ENTRY DATA */
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  
  PRIMARY KEY (`unit_id`,`army_id`),
  
  FOREIGN KEY (`army_id`,`player_id`) REFERENCES wg_armies(`army_id`,`player_id`)
    ON DELETE RESTRICT,
  FOREIGN KEY (`unit_id`) REFERENCES wg_unit_defs(`unit_id`)
    ON DELETE RESTRICT
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `wg_city_unit` (
  `unit_id` BIGINT UNSIGNED NOT NULL,
  `city_id` BIGINT UNSIGNED NOT NULL,
  `player_id` BIGINT UNSIGNED NOT NULL,

  `number` int(11) NOT NULL,
  
   /* ENTRY DATA */
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  
  PRIMARY KEY (`unit_id`,`city_id`),
  
  FOREIGN KEY (`city_id`,`player_id`) REFERENCES wg_cities(`city_id`,`player_id`)
    ON DELETE RESTRICT,
  FOREIGN KEY (`unit_id`) REFERENCES wg_unit_defs(`unit_id`)
    ON DELETE RESTRICT
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `wg_struct_defs` (
  `structure_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8_unicode_ci NOT NULL UNIQUE,

  `description` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  
  `gold_cost` int(11) NOT NULL,
  `steel_cost` int(11) NOT NULL,
  `oil_cost` int(11) NOT NULL DEFAULT 0,
  
  `cost_advancement_type` int(5) NOT NULL DEFAULT 3,
  
  `base_production` int(10),
  
  `max_level` int(10) NOT NULL,
  
  PRIMARY KEY (`structure_id`)
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `wg_struct` (
  `structure_id` BIGINT UNSIGNED NOT NULL,
  `city_id` BIGINT UNSIGNED NOT NULL,
  `player_id` BIGINT UNSIGNED NOT NULL,

  `level` int(11) NOT NULL DEFAULT 0,
  
  `next_lev_gold_cost` int(11) NOT NULL,
  `next_lev_steel_cost` int(11) NOT NULL,
  `next_lev_oil_cost` int(11) NOT NULL DEFAULT 0,
  
   /* ENTRY DATA */
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,

  PRIMARY KEY (`structure_id`,`city_id`),
  
  FOREIGN KEY (`structure_id`) REFERENCES wg_struct_defs(`structure_id`) 
    ON DELETE RESTRICT,
  
  FOREIGN KEY (`city_id`,`player_id`) REFERENCES wg_cities(`city_id`,`player_id`)
    ON DELETE RESTRICT  
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `wg_tech_defs` (
  `tech_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8_unicode_ci NOT NULL UNIQUE,

  `description` varchar(250) COLLATE utf8_unicode_ci NOT NULL,

  `gold_cost` int(11) NOT NULL,
  `steel_cost` int(11) NOT NULL,
  `oil_cost` int(11) NOT NULL DEFAULT 0,
  
  `max_level` int(10) NOT NULL,
  
  PRIMARY KEY (`tech_id`)
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `wg_techs` (
  `tech_id` BIGINT UNSIGNED NOT NULL,
  `player_id` BIGINT UNSIGNED NOT NULL,

  `level` int(11) NOT NULL DEFAULT 0,
  
  `next_lev_gold_cost` int(11) NOT NULL,
  `next_lev_steel_cost` int(11) NOT NULL,
  `next_lev_oil_cost` int(11) NOT NULL DEFAULT 0,
  
   /* ENTRY DATA */
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,

  PRIMARY KEY (`tech_id`,`player_id`),
  
  FOREIGN KEY (`tech_id`) REFERENCES wg_tech_defs(`tech_id`) 
    ON DELETE RESTRICT,
    
  FOREIGN KEY (`player_id`) REFERENCES wg_players(`player_id`)
    ON DELETE RESTRICT  
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `wg_tech_tech_req_defs` (
  /* TABLE FOR TECH TECH REQUIREMENTS */
  
  `tech_id` BIGINT UNSIGNED NOT NULL,
  `req_tech_id` BIGINT UNSIGNED NOT NULL,

  `level` int(11) NOT NULL DEFAULT 0,

  PRIMARY KEY (`tech_id`,`req_tech_id`),
  
  FOREIGN KEY (`tech_id`) REFERENCES wg_tech_defs(`tech_id`) 
    ON DELETE CASCADE,
    
  FOREIGN KEY (`req_tech_id`) REFERENCES wg_tech_defs(`tech_id`) 
    ON DELETE CASCADE  
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `wg_tech_struct_req_defs` (
  /* TABLE FOR TECH STRUCTURES REQUIREMENTS */
  
  `tech_id` BIGINT UNSIGNED NOT NULL,
  `req_structure_id` BIGINT UNSIGNED NOT NULL,

  `level` int(11) NOT NULL DEFAULT 0,

  PRIMARY KEY (`tech_id`,`req_structure_id`),
  
  FOREIGN KEY (`tech_id`) REFERENCES wg_tech_defs(`tech_id`) 
    ON DELETE CASCADE,
    
  FOREIGN KEY (`req_structure_id`) REFERENCES wg_struct_defs(`structure_id`) 
    ON DELETE CASCADE  
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `wg_struct_tech_req_defs` (
  /* TABLE FOR STRUCTURE TECH REQUIREMENTS */
  
  `structure_id` BIGINT UNSIGNED NOT NULL,
  `req_tech_id` BIGINT UNSIGNED NOT NULL,

  `level` int(11) NOT NULL DEFAULT 0,

  PRIMARY KEY (`structure_id`,`req_tech_id`),
  
  FOREIGN KEY (`structure_id`) REFERENCES wg_struct_defs(`structure_id`) 
    ON DELETE CASCADE,
    
  FOREIGN KEY (`req_tech_id`) REFERENCES wg_tech_defs(`tech_id`) 
    ON DELETE CASCADE  
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `wg_struct_struct_req_defs` (
  /* TABLE FOR STRUCTURE STRUCTURES REQUIREMENTS */
  
  `structure_id` BIGINT UNSIGNED NOT NULL,
  `req_structure_id` BIGINT UNSIGNED NOT NULL,

  `level` int(11) NOT NULL DEFAULT 0,

  PRIMARY KEY (`structure_id`,`req_structure_id`),
  
  FOREIGN KEY (`structure_id`) REFERENCES wg_struct_defs(`structure_id`) 
    ON DELETE CASCADE,
    
  FOREIGN KEY (`req_structure_id`) REFERENCES wg_struct_defs(`structure_id`) 
    ON DELETE CASCADE  
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `wg_unit_tech_req_defs` (
  /* TABLE FOR UNIT TECH REQUIREMENTS */
  
  `unit_id` BIGINT UNSIGNED NOT NULL,
  `req_tech_id` BIGINT UNSIGNED NOT NULL,

  `level` int(11) NOT NULL DEFAULT 0,

  PRIMARY KEY (`unit_id`,`req_tech_id`),
  
  FOREIGN KEY (`unit_id`) REFERENCES wg_unit_defs(`unit_id`) 
    ON DELETE CASCADE,
    
  FOREIGN KEY (`req_tech_id`) REFERENCES wg_tech_defs(`tech_id`) 
    ON DELETE CASCADE  
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"
qs << "
CREATE TABLE `wg_unit_struct_req_defs` (
  /* TABLE FOR UNIT STRUCTURES REQUIREMENTS */
  
  `unit_id` BIGINT UNSIGNED NOT NULL,
  `req_structure_id` BIGINT UNSIGNED NOT NULL,

  `level` int(11) NOT NULL DEFAULT 0,

  PRIMARY KEY (`unit_id`,`req_structure_id`),
  
  FOREIGN KEY (`unit_id`) REFERENCES wg_unit_defs(`unit_id`) 
    ON DELETE CASCADE,
    
  FOREIGN KEY (`req_structure_id`) REFERENCES wg_struct_defs(`structure_id`) 
    ON DELETE CASCADE  
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `wg_unit_queue` (
  /* TABLE FOR UNIT BUILD QUEUE IMPLEMENTATION */
  `unit_queue_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, /* No Unique Key at All */
  
  `unit_id` BIGINT UNSIGNED NOT NULL,
  `city_id` BIGINT UNSIGNED NOT NULL,
  `player_id` BIGINT UNSIGNED NOT NULL,
  
  `unit_type` char(8) COLLATE utf8_unicode_ci NOT NULL,
  
  `number` int(11) NOT NULL,
  `running` tinyint(1) UNSIGNED DEFAULT 0,
  `finished` tinyint(1) UNSIGNED DEFAULT 0,

   /* ENTRY DATA */
  `started_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `time_needed` int(11) NOT NULL,
  
  PRIMARY KEY (`unit_queue_id`),
  
  FOREIGN KEY (`unit_id`, `unit_type`) REFERENCES wg_unit_defs(`unit_id`, `unit_type`) 
    ON DELETE RESTRICT,
    
  FOREIGN KEY (`city_id`,`player_id`) REFERENCES wg_cities(`city_id`,`player_id`) 
    ON DELETE RESTRICT  
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `wg_tech_queue` (
  /* TABLE FOR TECH BUILD QUEUE IMPLEMENTATION */
  
  `tech_id` BIGINT UNSIGNED NOT NULL,
  `city_id` BIGINT UNSIGNED NOT NULL,
  `player_id` BIGINT UNSIGNED NOT NULL,

  `level` int(11) NOT NULL,
  `running` tinyint(1) UNSIGNED DEFAULT 0,
  `finished` tinyint(1) UNSIGNED DEFAULT 0,
  
   /* ENTRY DATA */
  `started_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `time_needed` int(11) NOT NULL,
  
  PRIMARY KEY (`player_id`,`tech_id`,`level`), /* You can research globally only onceper lever a tech */
  
  FOREIGN KEY (`tech_id`,`player_id`) REFERENCES wg_techs(`tech_id`,`player_id`) 
    ON DELETE RESTRICT,
    
  FOREIGN KEY (`city_id`,`player_id`) REFERENCES wg_cities(`city_id`,`player_id`) 
    ON DELETE RESTRICT  
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "
CREATE TABLE `wg_struct_queue` (
  /* TABLE FOR STRUCTURE BUILD QUEUE IMPLEMENTATION */
  
  `structure_id` BIGINT UNSIGNED NOT NULL,
  `city_id` BIGINT UNSIGNED NOT NULL,
  `player_id` BIGINT UNSIGNED NOT NULL,

  `level` int(11) NOT NULL,
  `running` tinyint(1) UNSIGNED DEFAULT 0,
  `finished` tinyint(1) UNSIGNED DEFAULT 0,

   /* ENTRY DATA */
  `started_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `time_needed` int(11) NOT NULL,
  
  PRIMARY KEY (`player_id`,`structure_id`,`city_id`,`level`), /* You can build a struct only once per level in every city */
  
  FOREIGN KEY (`structure_id`,`city_id`) REFERENCES wg_struct(`structure_id`,`city_id`)
    ON DELETE RESTRICT,
    
  FOREIGN KEY (`city_id`,`player_id`) REFERENCES wg_cities(`city_id`,`player_id`) 
    ON DELETE RESTRICT  
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
"

qs << "CREATE TABLE `bdrb_job_queues` (

  /* TABLE USED BY BackgrounDRB gem */
  
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `args` text COLLATE utf8_unicode_ci,
  `worker_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `worker_method` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `job_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `taken` int(11) DEFAULT NULL,
  `finished` int(11) DEFAULT NULL,
  `timeout` int(11) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `submitted_at` datetime DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  `archived_at` datetime DEFAULT NULL,
  `tag` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `submitter_info` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `runner_info` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `worker_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `scheduled_at` datetime DEFAULT NULL,
  
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;"

     ####################################
     #             VIEWS                #
     ####################################

qs << "CREATE OR REPLACE VIEW wg_v_army_unit AS
   SELECT 
    u_aunit.unit_id AS unit_id,
    u_aunit.army_id AS army_id,
    u_aunit.player_id AS player_id,
    u_def.name AS name,
    u_def.unit_type AS unit_type,
    u_def.attack_type AS attack_type,
    u_aunit.number AS number,
    u_def.power AS power,
    u_def.defense AS defense,
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


qs << "CREATE OR REPLACE VIEW wg_v_city_locations AS
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
   WHERE pts > #{PTS_FILTER}
   ORDER BY location_id;
"

qs << "CREATE OR REPLACE VIEW wg_v_army_locations AS
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
   ORDER BY location_id, army_id;
"

# qs << "CREATE OR REPLACE VIEW wg_lol AS
#     SELECT sd.*, 
#           rst.name AS RequiredStructName,
#           ssd.level AS RequiredStructLevel,
#           td.name AS RequiredTechName,
#           std.level AS RequiredTechLevel
#     FROM wg_struct_defs sd 
#     LEFT JOIN wg_struct_struct_req_defs ssd 
#       ON sd.structure_id = ssd.structure_id
#     LEFT JOIN wg_struct_defs rst 
#       ON rst.structure_id = ssd.req_structure_id
#     LEFT JOIN wg_struct_tech_req_defs std
#       ON sd.structure_id = std.structure_id
#     LEFT JOIN wg_tech_defs td 
#       ON std.req_tech_id = td.tech_id;
# "


if !defined?(Rails) || Rails.env != "test"
  puts "recreating tables..."
  queries.each do |query|
    puts query.split(/\n/)[0..1].join + "..."  
    ActiveRecord::Base.connection.execute query
  end
else
  qs
end
