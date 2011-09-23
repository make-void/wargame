class ArmyView extends Backbone.View

  tagName: "li"
  
  events: {
    "click div": "panMap"
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
    
  panMap: ->
    window.last_panned_loc = loc = this.model.attributes.location # FIXME: use @last_panned_loc and pass it to openDialog
    window.game.map.center(loc.latitude, loc.longitude)
    MapEvents.bind("markers_loaded", this.openDialog)
    
  openDialog: ->
    loc = window.last_panned_loc
    for marker in window.game.map.markers
      if marker.model.id == loc.id
        window.game.map.doInitDialog marker  

    MapEvents.unbind("markers_loaded", this.openDialog)