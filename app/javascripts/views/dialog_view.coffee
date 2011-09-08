class DialogView
  constructor: (@map, @marker) ->
    @diag = @marker.dialog
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
    content = @diag.getContent()
    this.build(content)
    this.open()
    this.bindEvents()
    
    this

  bindEvents: ->
    $(@dialog.content).find(".closeButton").bind("click", =>
      this.close()
      this.rebind()
    )
  
  rebind: ->
    google.maps.event.addListener(@marker, 'click', =>
      this.open()
    )
      
  # actions
  
  showSwitchButton: (marker, fun) ->
    $(@dialog.content).find(".switchButton").css({display: "block"})
      .html("Switch to Army")
      .bind("click", ->
        fun(marker)
      )
    
  
  close: ->
    @dialog.close()
  
  switchTab: (tab) ->
    $(".bubble .tabs .#{tab}").trigger "click"
    
  
  
# original InfoWindow notes
#    
# dialog = new google.maps.InfoWindow({
#   content: content_string
# })
# dialog.open(@map, marker)