class MarkersUpdater

  constructor: (@map) ->
    # google.maps.event.addListener(@map, 'tilesloaded', =>
    # )
    
  start: ->
    @time2 = new Date()
    @timer = new Date()    
    $(window).bind("boundszoom_changed", =>
      this.tick()
    )
  
    $(window).everyTime(1500, =>
      this.tickLast(@time2)
    )
    
  tick: =>
    time = new Date() - @timer   
    @time2 = new Date()
    if time > 1000
      @map.loadMarkers()
      @time2 = new Date()
      @timer = new Date()
    
  tickLast: (external_time) =>    
    time = new Date() - external_time
    if time > 1000 && time < 2000
      @map.loadMarkers()
  