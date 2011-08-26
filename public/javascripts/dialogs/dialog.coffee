Dialog  = Backbone.View.extend(
  initialize: (selector) ->
    #selector = "#dialog-tmpl"
    this.template = Haml($(selector).html())
  
  afterRender: ->  
  
  render: ->
    content = this.template this.model.attributes
    $(this.el).html(content)
    this.afterRender()
    this # returning render method scope lets you chain events (methods)
)