PlayerView  = Backbone.View.extend(  
  
  # initialize: (attrs) ->
  #   @selector = attrs["selector"]
  #   Backbone.View.prototype.initialize { model: attrs["model"] }
  
  render: () ->
    haml = Haml $("#playerView-tmpl").html()
    content = haml this.model.attributes
    console.log content
    $(this.el).html content

    this # returning render method scope lets you chain events (methods)
)