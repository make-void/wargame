# GenericDialog - use this dialog by extending it
#
# @type required

GenericDialog  = Backbone.View.extend(  
  
  initialize: (@type) ->
    @selector = "##{@type}Dialog-tmpl"
    
  afterRender: ->  
    this.initializeTabs() if this.initializeTabs
    this.initializeOverview() if this.initializeOverview
    
  getContent: ->
    if @rendered
      this.el
    else
      this.render().el
    
  render: ->  
    console.log "ERROR: can't create dialog with null selector" unless @selector
    haml = Haml $(@selector).html()
    # console.log("model: ", @selector, " - ", @model)
    content = haml this.model.attributes
    @rendered = true
    $(this.el).html content
    this # returning render method scope lets you chain events (methods)
    
)