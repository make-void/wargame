path = File.expand_path "../../", __FILE__



require "#{path}/db/default_values"
include DefaultValues

recreate_db_structure
create_default_vals


