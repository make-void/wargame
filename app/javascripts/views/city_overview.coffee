class CityOverview extends Backbone.View
  
  selector: "#cityOverview-tmpl"
  
    
  render: ->
    content = Utils.haml this.selector, this.model
    $(this.el).html content
    this