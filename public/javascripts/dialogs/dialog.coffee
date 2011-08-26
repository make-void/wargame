Dialog  = Backbone.View.extend(
  initialize: (nil) ->
    selector = "#dialog-tmpl"
    this.template = Haml($(selector).html())
    
  render: ->
    content = this.template this.model.attributes
    $(this.el).html(content)
    this # returning render method scope lets you chain events (methods)
)