
Location  = Backbone.Model.extend {}
Army      = Location.extend {}
City      = Location.extend {}
Player    = Backbone.Model.extend {}
Upgrade   = Backbone.Model.extend {}
Alliance  = Backbone.Model.extend {}

class Structs extends Backbone.Model
  
Units = Backbone.Model.extend {}
Techs = Backbone.Model.extend {}

Struct = Backbone.Model.extend {}
Unit = Backbone.Model.extend {}
Tech = Backbone.Model.extend {}

class Queue extends Backbone.Model
class StructsQueue extends Queue
class UnitsQueue extends Queue
class TechsQueue extends Queue


