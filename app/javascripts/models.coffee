
Location  = Backbone.Model.extend {}
Army      = Location.extend {}
City      = Location.extend {}
Player    = Backbone.Model.extend {}
Upgrade   = Backbone.Model.extend {}
Alliance  = Backbone.Model.extend {}

Structs = Backbone.Model.extend {}
Units = Backbone.Model.extend {}
Techs = Backbone.Model.extend {}

Struct = Backbone.Model.extend {}
Unit = Backbone.Model.extend {}
Tech = Backbone.Model.extend {}


class Definitions
  constructor: ->
    
  get: ->
    $.getJSON("/definitions", (data) ->
      console.log(data)
    )


class Definition
  constructor: (objects) ->
    @objects = this.load(objects)
    
  load: (objects) ->
    objects
    
class StructDef extends Definition  
class TechsDef extends Definition
class UnitsDef extends Definition  