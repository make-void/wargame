class DialogView
  constructor: (@map, @marker) ->
    @dialog = null
    this.build()
    this.open()
    
  open: ->
    @dialog.open @map, @marker
    
  build: ->
    @dialog = new InfoBubble({
      # map: map,
      # position: new google.maps.LatLng(-35, 151),
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
      minWidth: 200,
      maxWidth: 700
    })

    this.render()
    
  render: ->
    content = @marker.dialog.render().el

    if @marker.type == "city"
      @dialog.addTab('Overview', content)
      
      # TODO: city.owned?(current_player) # => boolean
      is_owned_by_current_player = true
      if is_owned_by_current_player
        @dialog.addTab('Structures', "faaaarming")
        @dialog.addTab('Units',      "faaaarming")
        @dialog.addTab('Upgrades',   "faaaarming")
    else  
      @dialog.addTab('City', content)
      
    @dialog.addTab('Debug', "I will be useful...")
    
    
# original InfoWindow notes
#    
# dialog = new google.maps.InfoWindow({
#   content: content_string
# })
# dialog.open(@map, marker)