CityDialog  = Dialog.extend(
  initialize: ->
    @type = "city"
    Dialog.prototype.initialize @type# how to call super in js
    
  label: ->
    city.name
    
  initializeTabs: ->
    console.log "init tabs"
    console.log  $(".bubble .tabs div")
    setTimeout( =>
      self = this
      $(".bubble .tabs div").bind("click", ->
        # console.log $(this).getClass()
        type = $(this).attr("data-dialog_type")
        console.log "clicked on tab: ", type
        
        self.initTab type
      )
    , 500) # FIXME: setTimeout is bad, seearch InfoBubble code and find dialogOpenedEvent
    
  initTab: (type) ->
    dialog = switch type
      when "city_structs"
        model = new Structs { definitions: game.struct_def.definitions }
        new StructsDialog model: model
      when "city_units"
        model = new Units { definitions: game.unit_def.definitions }
        new UnitsDialog model: model
      when "city_techs"
        model = new Techs { definitions: game.tech_def.definitions }
        new TechsDialog model: model
        
    if dialog
      content = dialog.render().el
      $(".bubbleBg").html content
)