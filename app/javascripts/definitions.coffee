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
    console.log objects
    super objects
      
class UnitDef extends Definition  
  constructor: (objects) ->
    @type = "unit"
    super objects
    
    
class AttackType
  constructor: (@type) ->
    
  toString: ->
    switch @type
      when 0 then "normal"
      when 1 then "anti-vehicle"
      when 2 then "????" 
      else  
        console.log "Error: Attack type '#{@type}' not found!"