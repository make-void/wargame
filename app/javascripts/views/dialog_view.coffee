class DialogView
  constructor: (@map, @marker) ->
    @dialog = null
    @marker.dialog_view = this
    
  open: ->
    @dialog.open @map, @marker
    
  build: (content) ->
    @dialog = new InfoBubble({
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
      hideCloseButton: false,
      arrowPosition: 30,
      backgroundClassName: 'bubbleBg',
      arrowStyle: 2,
      minWidth: 360,
      maxWidth: 700,
      minHeight: 400,
      maxHeight: 700
    })

    
  render: ->    
    content = @marker.dialog.render().el 
    this.build(content)
    this.open()
    $("#bubbleEvents").bind("dialog_content_changed", =>
      @marker.dialog.afterRender()
    )

    this

  # actions
  
  switchTab: (tab) ->
    $(".bubble .tabs .#{tab}").trigger "click"
    
  
  
# original InfoWindow notes
#    
# dialog = new google.maps.InfoWindow({
#   content: content_string
# })
# dialog.open(@map, marker)