class CityView extends Backbone.View
  
  tagName: "li"
  
  render: ->
    $(this.el).html Utils.haml("#cityView-tmpl", this.model) 
    this

  