# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110908115000) do

  create_table "bdrb_job_queues", :force => true do |t|
    t.text     "args"
    t.string   "worker_name"
    t.string   "worker_method"
    t.string   "job_key"
    t.integer  "taken"
    t.integer  "finished"
    t.integer  "timeout"
    t.integer  "priority"
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "archived_at"
    t.string   "tag"
    t.string   "submitter_info"
    t.string   "runner_info"
    t.string   "worker_key"
    t.datetime "scheduled_at"
  end

  create_table "wg_alliances", :primary_key => "alliance_id", :force => true do |t|
    t.string   "name",       :limit => 150, :null => false
    t.datetime "created_at"
  end

  add_index "wg_alliances", ["name"], :name => "ally_name", :unique => true

  create_table "wg_armies", :primary_key => "army_id", :force => true do |t|
    t.integer  "location_id",    :limit => 8,                    :null => false
    t.integer  "player_id",      :limit => 8,                    :null => false
    t.boolean  "is_moving",                   :default => false, :null => false
    t.integer  "destination_id", :limit => 8
    t.integer  "speed",                       :default => 0,     :null => false
    t.integer  "gold_stored",                 :default => 0,     :null => false
    t.integer  "steel_stored",                :default => 0,     :null => false
    t.integer  "oil_stored",                  :default => 0,     :null => false
    t.integer  "storage_space",               :default => 0,     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wg_armies", ["army_id", "player_id"], :name => "armyplayer"
  add_index "wg_armies", ["location_id"], :name => "location_id"
  add_index "wg_armies", ["player_id"], :name => "player_id"

  create_table "wg_army_unit", :id => false, :force => true do |t|
    t.integer  "unit_id",    :limit => 8, :null => false
    t.integer  "army_id",    :limit => 8, :null => false
    t.integer  "player_id",  :limit => 8, :null => false
    t.integer  "number",                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wg_army_unit", ["army_id", "player_id"], :name => "army_id"

  create_table "wg_cities", :primary_key => "city_id", :force => true do |t|
    t.integer  "location_id",         :limit => 8,                     :null => false
    t.integer  "player_id",           :limit => 8,                     :null => false
    t.string   "name",                :limit => 150,                   :null => false
    t.integer  "pts",                                :default => 0
    t.string   "ccode",               :limit => 2
    t.integer  "gold_production",                    :default => 45,   :null => false
    t.integer  "steel_production",                   :default => 35,   :null => false
    t.integer  "oil_production",                     :default => 15,   :null => false
    t.integer  "gold_stored",                        :default => 2500, :null => false
    t.integer  "steel_stored",                       :default => 2500, :null => false
    t.integer  "oil_stored",                         :default => 2500, :null => false
    t.integer  "gold_storage_space",                 :default => 2500, :null => false
    t.integer  "steel_storage_space",                :default => 2500, :null => false
    t.integer  "oil_storage_space",                  :default => 2500, :null => false
    t.datetime "last_update_at"
  end

  add_index "wg_cities", ["city_id", "player_id"], :name => "city_player"
  add_index "wg_cities", ["location_id"], :name => "location_id", :unique => true
  add_index "wg_cities", ["player_id"], :name => "player_id"

  create_table "wg_city_unit", :id => false, :force => true do |t|
    t.integer  "unit_id",    :limit => 8, :null => false
    t.integer  "city_id",    :limit => 8, :null => false
    t.integer  "player_id",  :limit => 8, :null => false
    t.integer  "number",                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wg_city_unit", ["city_id", "player_id"], :name => "city_id"

  create_table "wg_locations", :primary_key => "location_id", :force => true do |t|
    t.decimal "latitude",  :precision => 18, :scale => 14, :null => false
    t.decimal "longitude", :precision => 18, :scale => 14, :null => false
  end

  add_index "wg_locations", ["latitude", "longitude"], :name => "latlng", :unique => true

  create_table "wg_players", :primary_key => "player_id", :force => true do |t|
    t.integer  "alliance_id", :limit => 8,   :null => false
    t.string   "name",        :limit => 150, :null => false
    t.string   "email",       :limit => 150, :null => false
    t.string   "password",    :limit => 150, :null => false
    t.string   "salt",        :limit => 150, :null => false
    t.datetime "created_at"
  end

  add_index "wg_players", ["email"], :name => "player_email", :unique => true
  add_index "wg_players", ["name"], :name => "player_name", :unique => true

  create_table "wg_struct", :id => false, :force => true do |t|
    t.integer  "structure_id",        :limit => 8,                :null => false
    t.integer  "city_id",             :limit => 8,                :null => false
    t.integer  "player_id",           :limit => 8,                :null => false
    t.integer  "level",                            :default => 0, :null => false
    t.integer  "next_lev_gold_cost",                              :null => false
    t.integer  "next_lev_steel_cost",                             :null => false
    t.integer  "next_lev_oil_cost",                :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wg_struct", ["city_id", "player_id"], :name => "city_id"

  create_table "wg_struct_defs", :primary_key => "structure_id", :force => true do |t|
    t.string  "name",                  :limit => 150,                :null => false
    t.string  "description",           :limit => 250,                :null => false
    t.integer "gold_cost",                                           :null => false
    t.integer "steel_cost",                                          :null => false
    t.integer "oil_cost",                             :default => 0, :null => false
    t.integer "cost_advancement_type",                :default => 3, :null => false
    t.integer "base_production"
    t.integer "max_level",                                           :null => false
  end

  add_index "wg_struct_defs", ["name"], :name => "name", :unique => true

  create_table "wg_struct_queue", :id => false, :force => true do |t|
    t.integer  "structure_id", :limit => 8,                    :null => false
    t.integer  "city_id",      :limit => 8,                    :null => false
    t.integer  "player_id",    :limit => 8,                    :null => false
    t.integer  "level",                                        :null => false
    t.boolean  "running",                   :default => false
    t.datetime "started_at"
    t.integer  "time_needed",                                  :null => false
  end

  add_index "wg_struct_queue", ["city_id", "player_id"], :name => "city_id"
  add_index "wg_struct_queue", ["structure_id", "city_id"], :name => "structure_id"

  create_table "wg_struct_struct_req_defs", :id => false, :force => true do |t|
    t.integer "structure_id",     :limit => 8,                :null => false
    t.integer "req_structure_id", :limit => 8,                :null => false
    t.integer "level",                         :default => 0, :null => false
  end

  add_index "wg_struct_struct_req_defs", ["req_structure_id"], :name => "req_structure_id"

  create_table "wg_struct_tech_req_defs", :id => false, :force => true do |t|
    t.integer "structure_id", :limit => 8,                :null => false
    t.integer "req_tech_id",  :limit => 8,                :null => false
    t.integer "level",                     :default => 0, :null => false
  end

  add_index "wg_struct_tech_req_defs", ["req_tech_id"], :name => "req_tech_id"

  create_table "wg_tech_defs", :primary_key => "tech_id", :force => true do |t|
    t.string  "name",        :limit => 150,                :null => false
    t.string  "description", :limit => 250,                :null => false
    t.integer "gold_cost",                                 :null => false
    t.integer "steel_cost",                                :null => false
    t.integer "oil_cost",                   :default => 0, :null => false
    t.integer "max_level",                                 :null => false
  end

  add_index "wg_tech_defs", ["name"], :name => "name", :unique => true

  create_table "wg_tech_queue", :id => false, :force => true do |t|
    t.integer  "tech_id",     :limit => 8,                    :null => false
    t.integer  "city_id",     :limit => 8,                    :null => false
    t.integer  "player_id",   :limit => 8,                    :null => false
    t.integer  "level",                                       :null => false
    t.boolean  "running",                  :default => false
    t.datetime "started_at"
    t.integer  "time_needed",                                 :null => false
  end

  add_index "wg_tech_queue", ["city_id", "player_id"], :name => "city_id"
  add_index "wg_tech_queue", ["tech_id", "player_id"], :name => "tech_id"

  create_table "wg_tech_struct_req_defs", :id => false, :force => true do |t|
    t.integer "tech_id",          :limit => 8,                :null => false
    t.integer "req_structure_id", :limit => 8,                :null => false
    t.integer "level",                         :default => 0, :null => false
  end

  add_index "wg_tech_struct_req_defs", ["req_structure_id"], :name => "req_structure_id"

  create_table "wg_tech_tech_req_defs", :id => false, :force => true do |t|
    t.integer "tech_id",     :limit => 8,                :null => false
    t.integer "req_tech_id", :limit => 8,                :null => false
    t.integer "level",                    :default => 0, :null => false
  end

  add_index "wg_tech_tech_req_defs", ["req_tech_id"], :name => "req_tech_id"

  create_table "wg_techs", :id => false, :force => true do |t|
    t.integer  "tech_id",             :limit => 8,                :null => false
    t.integer  "player_id",           :limit => 8,                :null => false
    t.integer  "level",                            :default => 0, :null => false
    t.integer  "next_lev_gold_cost",                              :null => false
    t.integer  "next_lev_steel_cost",                             :null => false
    t.integer  "next_lev_oil_cost",                :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wg_techs", ["player_id"], :name => "player_id"

  create_table "wg_unit_defs", :primary_key => "unit_id", :force => true do |t|
    t.string  "name",               :limit => 150,                         :null => false
    t.string  "unit_type",          :limit => 8,   :default => "Infantry", :null => false
    t.integer "attack_type",                       :default => 0,          :null => false
    t.integer "power",                                                     :null => false
    t.integer "defence",                                                   :null => false
    t.integer "movement_speed",                                            :null => false
    t.integer "movement_cost",                     :default => 0,          :null => false
    t.integer "cargo_capacity",                                            :null => false
    t.integer "transport_capacity",                :default => 0,          :null => false
    t.integer "gold_cost",                                                 :null => false
    t.integer "steel_cost",                                                :null => false
    t.integer "oil_cost",                          :default => 0,          :null => false
  end

  add_index "wg_unit_defs", ["name"], :name => "name", :unique => true

  create_table "wg_unit_queue", :id => false, :force => true do |t|
    t.integer  "unit_id",     :limit => 8,                    :null => false
    t.integer  "city_id",     :limit => 8,                    :null => false
    t.integer  "player_id",   :limit => 8,                    :null => false
    t.integer  "number",                                      :null => false
    t.boolean  "running",                  :default => false
    t.datetime "started_at"
    t.integer  "time_needed",                                 :null => false
  end

  add_index "wg_unit_queue", ["city_id", "player_id"], :name => "city_id"
  add_index "wg_unit_queue", ["unit_id"], :name => "unit_id"

  create_table "wg_unit_struct_req_defs", :id => false, :force => true do |t|
    t.integer "unit_id",          :limit => 8,                :null => false
    t.integer "req_structure_id", :limit => 8,                :null => false
    t.integer "level",                         :default => 0, :null => false
  end

  add_index "wg_unit_struct_req_defs", ["req_structure_id"], :name => "req_structure_id"

  create_table "wg_unit_tech_req_defs", :id => false, :force => true do |t|
    t.integer "unit_id",     :limit => 8,                :null => false
    t.integer "req_tech_id", :limit => 8,                :null => false
    t.integer "level",                    :default => 0, :null => false
  end

  add_index "wg_unit_tech_req_defs", ["req_tech_id"], :name => "req_tech_id"

  create_table "wg_v_army_locations", :id => false, :force => true do |t|
    t.integer "location_id",   :limit => 8,                                   :default => 0, :null => false
    t.decimal "latitude",                     :precision => 18, :scale => 14,                :null => false
    t.decimal "longitude",                    :precision => 18, :scale => 14,                :null => false
    t.integer "player_id",     :limit => 8,                                                  :null => false
    t.integer "army_id",       :limit => 8,                                   :default => 0, :null => false
    t.string  "player_name",   :limit => 150
    t.integer "alliance_id",   :limit => 8
    t.string  "alliance_name", :limit => 150
  end

  create_table "wg_v_army_unit", :id => false, :force => true do |t|
    t.integer "unit_id",               :limit => 8,                           :null => false
    t.integer "army_id",               :limit => 8,                           :null => false
    t.integer "player_id",             :limit => 8,                           :null => false
    t.string  "name",                  :limit => 150
    t.string  "unit_type",             :limit => 8,   :default => "Infantry"
    t.integer "attack_type",                          :default => 0
    t.integer "number",                                                       :null => false
    t.integer "power"
    t.integer "defence"
    t.integer "speed"
    t.integer "cost",                                 :default => 0
    t.integer "resources_transported"
    t.integer "people_transported",                   :default => 0
    t.boolean "is_moving",                            :default => false
    t.integer "destination_id",        :limit => 8
    t.integer "location_id",           :limit => 8
  end

  create_table "wg_v_city_locations", :id => false, :force => true do |t|
    t.integer "location_id",   :limit => 8,                                   :default => 0, :null => false
    t.decimal "latitude",                     :precision => 18, :scale => 14,                :null => false
    t.decimal "longitude",                    :precision => 18, :scale => 14,                :null => false
    t.integer "city_id",       :limit => 8,                                   :default => 0
    t.integer "player_id",     :limit => 8
    t.string  "city_name",     :limit => 150
    t.integer "city_pts",                                                     :default => 0
    t.string  "city_ccode",    :limit => 2
    t.string  "player_name",   :limit => 150
    t.integer "alliance_id",   :limit => 8
    t.string  "alliance_name", :limit => 150
  end

end
