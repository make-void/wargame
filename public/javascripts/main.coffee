# TODO: move utils in a separate file  

utils = {}

utils.parseCoords = (string) ->
  split = string.replace(/\s/, '').split(",")
  return [split[0], split[1]]

#use console.log safely
`
(function(b){function c(){}for(var d="assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,timeStamp,profile,profileEnd,time,timeEnd,trace,warn".split(","),a;a=d.pop();){b[a]=b[a]||c}})((function(){try
{console.log();return window.console;}catch(err){return window.console={};}})());
`

$( ->
  g = window # makes the variable global (so you can test it in console an you can call it from outside jquery domready)
  
  # --------
  # models & views
    
  g.Army      = Backbone.Model.extend {}
  g.City      = Backbone.Model.extend {}
  g.Location  = Backbone.Model.extend {}
  g.Player    = Backbone.Model.extend {}
  # Debug     = Backbone.Model.extend {}
  
  g.ArmyView  = Backbone.View.extend(
    initialize: ->
      this.template = Haml $("#army_view-tmpl").html()
      #this.template = _.template $("#army_view-tmpl").html()
      
    render: ->
      content = this.template this.model.attributes
      $(this.el).html(content)
      this # returning render method scope lets you chain events (methods)
  )
  
  g.army = new Army({ asd: "lol" })
  g.armyView = new ArmyView({model: g.army})
  $("#debug").append g.armyView.render().el

  # --------
  # nav
  
  $("#nav li").hover( ->
    $(this).find("div").show()
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
