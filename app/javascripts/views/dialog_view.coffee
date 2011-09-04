class DialogView
  constructor: (@map, @marker) ->
    @dialog = null
    @marker.dialog_view = this
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
      maxWidth: 700,
      minHeight: 400,
      maxHeight: 700
    })

    this.render()
    
  render: ->
    content = @marker.dialog.render().el

    if @marker.type == "city"
      @dialog.addTab('Overview', content, "city")
      
      # TODO: city.owned?(current_player) # => boolean
      is_owned_by_current_player = true
      loading_text = "loading..."
      if is_owned_by_current_player
        @dialog.addTab('Structures', loading_text, "city_structs")
        @dialog.addTab('Units',      loading_text, "city_units")
        @dialog.addTab('Upgrades',   loading_text, "city_techs")
    else  
      @dialog.addTab('Army', content, "army")
      
    @dialog.addTab('Debug', "I will be useful...", "debug")

  # actions
  
  switchTab: (tab) ->
    $(".bubble .tabs .#{tab}").trigger "click"
    
  
  
# original InfoWindow notes
#    
# dialog = new google.maps.InfoWindow({
#   content: content_string
# })
# dialog.open(@map, marker)