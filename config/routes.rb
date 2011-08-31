Wargame::Application.routes.draw do

  latlng = /-*\d+(\.\d+)*/
  get "/locations/:lat/:lng", to: "locations#index", as: :cities, constraints: { :lat => latlng, :lng => latlng }
  
  get "/players/me", to: "players#me", as: :players_me
  get "/players/me/locations/:lat/:lng", to: "players_locations#index", as: :player_locations, constraints: { :lat => latlng, :lng => latlng }
  
  
#  get "/game", to: "game#show", as: :game
  resource :game, controller: :game

  root :to => "pages#index"

end

# See how all your routes lay out with "rake routes"