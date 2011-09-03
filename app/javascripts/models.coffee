
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




class Definition
  constructor: (definitions) ->
    @definitions = this.load(definitions)
    # console.log @definitions
    
  load: (definitions) ->
    defs = []
    for definition in definitions[@type.pluralize()]
      defs.push definition["definition"]
    defs
      
    
class StructDef extends Definition  
  constructor: (objects) ->
    @type = "struct"
    super objects
  
    
class TechDef extends Definition
  constructor: (objects) ->
    @type = "tech"
    super objects
      
class UnitDef extends Definition  
  constructor: (objects) ->
    @type = "unit"
    super objects