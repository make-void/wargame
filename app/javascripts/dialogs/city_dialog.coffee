CityDialog  = GenericDialog.extend(

  
  element: '#cityDialog-tmpl'
  
  initialize: ->
    @type = "city"
    # GenericDialog.prototype.initialize @type# how to call super in js
    # @tabs = ["overview", "structs", "units", "techs", "debug"]
    @current_tab = null
    
    @queueView = null
    
  label: ->
    city.name
  
  
  # overview
  
  renderOverview: ->
    content = @queueView.render().el
    queue =  $(this.el).find(".queue")
    queue.html content
      
  initializeOverview: ->
    @queueView = new QueueView( dialog: this )# model: Queue
   
    Queue.fetch()
  
  
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
        @current_tab = new StructsDialog model: model
      when "city_units"
        model = new Units { definitions: game.unit_def.definitions }
        @current_tab = new UnitsDialog model: model
      when "city_techs"
        model = new Techs { definitions: game.tech_def.definitions }
        @current_tab = new TechsDialog model: model
      when "city_overview"
        @current_tab = over = new CityOverview model: @model
        this.initializeOverview()
        over
      when "debug"
        @current_tab = new DebugDialog model: @model # { attributes: {} } # @model
        
    if dialog
      content = dialog.render().el
      this.$(".dialog").html content
      # this.$(".dialog").removeClass( (idx, cla) -> cla )
      this.$(".dialog").addClass "dialog2"
      
)