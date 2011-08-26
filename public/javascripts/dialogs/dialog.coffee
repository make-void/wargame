Dialog  = Backbone.View.extend(
  initialize: (selector) ->
    this.template = Haml($(selector).html())
    
  render: ->
    content = this.template this.model.attributes
    $(this.el).html(content)
    this # returning render method scope lets you chain events (methods)
)