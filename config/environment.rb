# Load the rails application
require File.expand_path('../application', __FILE__)

require 'resque'

# Initialize the rails application
Wargame::Application.initialize!
