class ResourcesView extends Backbone.View
  
  render: ->
    content = Utils.haml "#resourcesView-tmpl", this.model
    $(this.el).html content
    this