PlayerView  = Backbone.View.extend(  
  
  el: $("#player")
  # initialize: (attrs) ->
  #   @selector = attrs["selector"]
  #   Backbone.View.prototype.initialize { model: attrs["model"] }
  
  render: () ->
    haml = Haml $("#playerView-tmpl").html()
    content = haml this.model.attributes

    $(this.el).html content
    this # returning render method scope lets you chain events (methods)
)