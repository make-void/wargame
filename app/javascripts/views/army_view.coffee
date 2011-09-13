class ArmyView extends Backbone.View

  tagName: "li"
  
  
  events: {
    # "click div": "panMap"
  }  
  
  
  initialize: ->
    console.log "modmod: ", this.model
    @resources = new Resources this.model.attributes.resources
    @resourcesView = new ResourcesView model: @resources
  
  render: ->
    $(this.el).html Utils.haml("#armyView-tmpl", this.model) 
    this.renderStoredResources()
    this
    
  renderStoredResources: ->
    content = @resourcesView.render().el
    this.$(".resources").html content