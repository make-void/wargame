Dialog  = Backbone.View.extend(  
  
  initialize: ->
    @selector = "##{@type}-tmpl"
    
  afterRender: ->  
  
  render: ->
    haml = Haml $(@selector).html()
    content = haml this.model.attributes
    $(this.el).html content
    this.afterRender()
    this # returning render method scope lets you chain events (methods)
)