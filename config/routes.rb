Wargame::Application.routes.draw do

  latlng = /-*\d+(\.\d+)*/
  get "/locations/:lat/:lng", to: "locations#index", as: :cities, constraints: { :lat => latlng, :lng => latlng }
  
  get "/players/me", to: "players#me", as: :players_me
  
  
  locations = LocationsController.action(:index) # TODO: handle with PlayerLocationsController
  # locations = "players_locations#index"
  get "/players/me/locations/:lat/:lng", to: locations, as: :player_locations, constraints: { :lat => latlng, :lng => latlng }
  

  get "/players/me/cities/:city_id/queues", to: "queues#index", as: :queues
  post "/players/me/cities/:city_id/queues", to: "queues#create"
  delete "/players/me/queues/:id", to: "queues#destroy"

  # resources :definitions
  get "/definitions", to: "definitions#index"
  get "/definitions/:type", to: "definitions#show"
  
#  get "/game", to: "game#show", as: :game
  resource :game, controller: :game

  root :to => "pages#index"

end

# See how all your routes lay out with "rake routes"