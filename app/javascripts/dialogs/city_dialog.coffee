CityDialog  = GenericDialog.extend(

  
  element: '#cityDialog-tmpl'
  
  initialize: ->
    @type = "city"
    # GenericDialog.prototype.initialize @type# how to call super in js
    
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
    BubbleEvents.bind("dialog_content_changed", =>
      this.initTabs()
    )
    
    
  initTabs: ->
    self = this
    
    $(this.el).find(".nav li").bind("click", ->
      type = $(this).attr("class")
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
        new DebugDialog model: @model # { attributes: {} } # @model
        
    if dialog
      content = dialog.render().el
      console.log "content: ", content
      $(".dialog").replaceWith content
      
)