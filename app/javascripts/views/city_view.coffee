class CityView extends Backbone.View
  
  tagName: "li"
  
  
  events: {
    "click div": "panMap"
  }  
  
  initialize: ->
    # _.bindAll this, 'renderResources'
    # this.bind('all',   this.renderResources, this)
    @stored = new Resources this.model.attributes.storage_space
    @storedView = new ResourcesView model: @stored
    @production = new Resources this.model.attributes.production
    @productionView = new ResourcesView model: @production

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

    # window.game.map.openBubbleView marker  
      
  
  render: ->
    $(this.el).html Utils.haml("#cityView-tmpl", this.model) 
    this.renderStoredResources()
    this.renderProductionResources()
    this
    
  renderStoredResources: ->
    content = @storedView.render().el
    this.$(".resources").html content
    
  renderProductionResources: ->
    content = @productionView.render().el
    this.$(".production").html content
  

  