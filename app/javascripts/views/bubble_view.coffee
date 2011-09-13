class BubbleView# extends Backbone.View # TODO: make it a backbone model
  constructor: (@map, @marker) ->
    @marker.bubble_view = this
    
  open: ->
    console.log @marker
    @bubble.open @map, @marker.view.markerIcon
    
  build: (content) ->
    @bubble = new InfoBubble({
      # map: map,
      # position: new google.maps.LatLng(-35, 151),
      content: content,
      shadowStyle: 1,
      padding: 12,
      backgroundColor: "#EEE",
      borderRadius: 10,
      arrowSize: 20,
      borderWidth: 3,
      borderColor: '#666',
      disableAutoPan: false,
      hideCloseButton: true,
      arrowPosition: 30,
      backgroundClassName: 'bubbleBg',
      arrowStyle: 2,
      minWidth: 420,
      maxWidth: 700,
      minHeight: 400,
      maxHeight: 700
    })

    
  doRender: ->   
    # content = @marker.dialog.getContent()
    content = @marker.dialog.render().el
    this.build(content)
    this.open()
    this.bindEvents()
    
    this

  bindEvents: ->
    $(@bubble.content).find(".closeButton").bind("click", =>
      this.close()
    )
  
  rebind: ->
    google.maps.event.addListener(@marker.view.markerIcon, 'click', =>
      this.open()
    )
      
  # actions
  
  showSwitchButton: (marker, fun, scope) ->
    $(@bubble.content).find(".switchButton").css({display: "block"})
      .html("Switch to Army")
      .bind("click", =>
        fun(marker)
      )
    
  
  close: ->
    @bubble.close()
    localStorage.last_location_id = null
    this.rebind()
  
  switchTab: (tab) ->
    $(".bubble .tabs .#{tab}").trigger "click"
    
  
  
# original InfoWindow notes
#    
# dialog = new google.maps.InfoWindow({
#   content: content_string
# })
# dialog.open(@map, marker)