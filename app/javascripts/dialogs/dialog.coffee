Dialog  = Backbone.View.extend(  
  
  initialize: (@type) ->
    @selector = "##{@type}Dialog-tmpl"
    
  afterRender: ->  
    this.initializeTabs() if this.initializeTabs
    
  render: ->  
    console.log "ERROR: can't create dialog with null selector" unless @selector
    haml = Haml $(@selector).html()
    content = haml this.model.attributes
    $(this.el).html content
    this.afterRender()
    this # returning render method scope lets you chain events (methods)
)