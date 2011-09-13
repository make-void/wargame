class MapView extends Backbone.View

  element: 'map_canvas'

  constructor: (@map) ->
    @controller = null
    # bounds change events
    @defaultZoom = 5
    
  draw: ->
    this.get_center_and_zoom()
    this.doDrawing()
    
    this.listen_to_bounds()
    this.autoSize()
    
  doDrawing: ->
    mapDiv = document.getElementById this.element
    # console.log "lat: ", @center_lat, "lng: ", @center_lng, "zoom: ", @zoom 
    @center_lat = @default_center_lat unless @center_lat
    @center_lng = @default_center_lng unless @center_lng
    # @zoom = 2
    @map = new google.maps.Map( mapDiv, {
      center: new google.maps.LatLng(@center_lat, @center_lng),
      zoom: @zoom,
      # mapTypeId: google.maps.MapTypeId.ROADMAP,
      mapTypeId: google.maps.MapTypeId.TERRAIN,
      disableDefaultUI: true,
      navigationControl: true,
      navigationControlOptions: {
        style: google.maps.NavigationControlStyle.SMALL,
        position: google.maps.ControlPosition.RIGHT_TOP
      }
    })
    @map.controller = @controller
  
  get_center_and_zoom: ->
    #console.log(localStorage.center_lat, localStorage.center_lng, localStorage.zoom)

    if localStorage.center_lat && localStorage.center_lng && localStorage.center_lat != "NaN" && localStorage.center_lng != "NaN" 
      @center_lat = parseFloat localStorage.center_lat
      @center_lng = parseFloat localStorage.center_lng
    else
      this.set_default_coords()
      localStorage.center_lat = @center_lat
      localStorage.center_lng = @center_lng

    if localStorage.zoom
      @zoom = parseInt localStorage.zoom
    else
      @zoom = @map.defaultZoom
      localStorage.zoom = @zoom
      
  
      
  set_default_coords: ->
    @center_lat = @default_center_lat = 47.2
    @center_lng = @default_center_lng = 14.4
    
    
  # bounds change event handling
  
  listen_to_bounds: ->
    this.listen()

    google.maps.event.addListener(@map, 'zoom_changed', =>
      this.zoom_changed()
    )

  listen: ->
    google.maps.event.addListenerOnce(@map, "bounds_changed", =>
      center = @map.getCenter()

      localStorage.center_lat = center.lat()
      localStorage.center_lng = center.lng()    
      
      setTimeout( => 
        this.listen()
        $(window).trigger "boundszoom_changed" # MarkerUpdater bind on this
      , 50)
    )  
  
  
  zoom_changed: ->
    zoom = @map.getZoom()

    if (zoom < @defaultZoom) 
      @map.setZoom(@defaultZoom)
      zoom = @defaultZoom

    if (zoom > 11) 
      @map.setZoom(11)
      zoom = 11

    localStorage.zoom = zoom   
    # $(window).trigger "boundszoom_changed" 
    if zoom < @controller.markerZoomMin
      @controller.clearMarkers()  
    
      
  # maps resize event handling
  
  autoSize: ->
    this.resize()
    $(window).resize( =>
      this.resize()
    )
  
  resize: -> 
    height = $("body").height() - $("h1").height() - 30
    $("#container, #map_canvas").height height # TODO: try if using google api is more performant