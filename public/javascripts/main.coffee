require 'map'

$( ->
  
  '''
  // use console.log safely
  (function(b){function c(){}for(var d="assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,timeStamp,profile,profileEnd,time,timeEnd,trace,warn".split(","),a;a=d.pop();){b[a]=b[a]||c}})((function(){try
  {console.log();return window.console;}catch(err){return window.console={};}})());
  '''
  
  # debug
  
  $("#debug").hover(function(){
      $("header").heigth(200)
    }, function() {
      $("header").heigth(30)
    }
  )
  
  
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
