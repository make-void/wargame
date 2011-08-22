APP_NAME = Rails.application.class.name.split("::")[0].downcase
DEVELOPER_NAME = "Francesco 'makevoid' Canessa, Daniel 'Cor3y' Belardini"


require "haml"
require "haml/template"
Haml::Template.options[:escape_html] = false
Haml::Template.options[:ugly] = false