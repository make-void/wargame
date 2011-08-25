#require 'map'

utils = {}

utils.parseCoords = (string) ->
  split = string.replace(/\s/, '').split(",")
  return [split[0], split[1]]
  

$( ->
  
  # use console.log safely
  `
  (function(b){function c(){}for(var d="assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,timeStamp,profile,profileEnd,time,timeEnd,trace,warn".split(","),a;a=d.pop();){b[a]=b[a]||c}})((function(){try
  {console.log();return window.console;}catch(err){return window.console={};}})());
  `

  # --------
  # nav
  
  $("#nav li").hover( ->
    $(this).find("div").show()
    console.log("asd")
  , ->
    $(this).find("div").hide()    
  )

  # --------  
  # debug
    
  $("#latLng").bind("submit", ->
    coords = $(this).find("input").val()
    coords = utils.parseCoords(coords)
    map.center(coords[0], coords[1])
    return false
  )
  
  # --------
  # map
  
  map = new Map
  map.draw()
  
  #map.dialogs()
  map.loadMarkers()
  
  map.listen()
  
  #map.clickInfo()
  #map.drawLines()
  map.startFetchingMarkers()
  
  #map.overlay()
  
  #console.log(navigator.userAgent)
  #if navigator.userAgent.match("iPad")
  map.resize()
  $(window).resize( ->
    map.resize()
  )
)
