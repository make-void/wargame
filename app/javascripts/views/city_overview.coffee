class CityOverview extends Backbone.View
  
  selector: "#cityOverview-tmpl"
  
    
  render: ->
    console.log "over: ", this.model
    content = Utils.haml this.selector, this.model
    $(this.el).html content
    this