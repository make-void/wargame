
Location  = Backbone.Model.extend {}
Army      = Location.extend {
  type: "army"
}
City      = Location.extend {
  type: "city"
}
Player    = Backbone.Model.extend {}
Upgrade   = Backbone.Model.extend {}
Alliance  = Backbone.Model.extend {}

class CitiesList extends Backbone.Collection
  model: City
  url: "/players/me/cities"
  
class ArmiesList extends Backbone.Collection
  model: Army
  url: "/players/me/armies"

Resources  = Backbone.Model.extend {}


class Structs extends Backbone.Model
  
Units = Backbone.Model.extend {}
Techs = Backbone.Model.extend {}

Struct = Backbone.Model.extend {}
Unit = Backbone.Model.extend {}
Tech = Backbone.Model.extend {}

  
# class StructsQueue extends Queue
# class UnitsQueue extends Queue
# class TechsQueue extends Queue


class Marker extends Backbone.Model