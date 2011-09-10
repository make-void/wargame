# GenericDialog - use this dialog by extending it
#
# @type required

GenericDialog  = Backbone.View.extend(    
  
  afterRender: ->  
    this.initializeTabs() if this.initializeTabs
    this.initializeOverview() if this.initializeOverview
    
  getContent: ->
    # if @rendered
    #   this.el
    # else
    this.render().el
    
  render: ->  
    @selector = "##{@type}Dialog-tmpl"
    console.log "Error: can't create dialog with null selector" unless @selector
    console.log "Error: can't create dialog with null element" if $(@selector).length == 0
    haml = Haml $(@selector).html()
    # console.log("model: ", @selector, " - ", @model, "-", @type)
    content = haml this.model.attributes
    @rendered = true
    $(this.el).html content
    this # returning render method scope lets you chain events (methods)
    
)