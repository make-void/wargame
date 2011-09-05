CityDialog  = Dialog.extend(
  initialize: ->
    @type = "city"
    Dialog.prototype.initialize @type# how to call super in js
    
  label: ->
    city.name
  
  # overview
  
  initializeOverview: ->
    # initQueue
    queueData = {}
    queue = new Queue queueData
    queueView = new QueueView model: queue
    content = queueView.render().el
    $(".bubbleBg .dialog .city").append content
  
  # tabs
  
  initializeTabs: ->
    this.initTabs()
    
  initTabs: ->
    self = this
    $(".bubble .nav li").bind("click", ->
      # console.log $(this).getClass()
      type = $(this).attr("class")
      # console.log "clicked on tab: ", type
      self.initTab type
    )  
  
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
      when "city_overview"
        new CityOverview model: @model
      when "debug"
        console.log "no debug atm"
        
    if dialog
      content = dialog.render().el
      $(".dialog").replaceWith content
      
)