#use console.log safely
unless console
  console = {} 
  console.log = {}
  console.debug = {}
  console.error = {}


# map utils

Utils = {}


Number::format = ->
  $.map(_(this.toString().split("")).reverse(), (d, idx) -> 
    if ((idx%3)==0 && idx!=0) then p = "." else p=""  
    return p+d
  ).join("").split("").reverse().join("")

# arrays

Array::first = ->
  this[0]
  
Array::last = ->
  this[-1]

# inflections

String::pluralize = -> 
  this+"s"
  
String::singularize = -> 
  if this[-1] && this[-1].toLowerCase() == "s" then this[0..-2] else this

# casing

String::capitalize = -> 
  "#{this[0].toUpperCase()}#{this[1..-1]}"

String::filenamize = ->
  this.toLowerCase().replace(/\s/g, '_')

# coords

Utils.geocode = (city, fn) ->
  $.get("/cities/#{city}", (data) ->
    lat = data.location.latitude
    lng = data.location.longitude
    console.log "daaa : ", data
    fn(lat, lng)
  )

Utils.parseCoords = (string) ->
  split = string.replace(/\s/, '').split(",")
  return [split[0], split[1]]

# move in city model (or ancestor)


Utils.nthroot = (x, n) ->
  Math.pow(x,1/n)

Utils.city_scale = (pop, kind) ->
  Utils.nthroot(pop/40000, 5)

# Utils.city_image = (pop, kind) ->
#   kind = "enemy" unless kind
#   sizes = [
#     150000,
#     50000, 
#     30000,
#     12000,
#     0 # 6000
#   ]
#   size = sizes[-1]
#   
#   for size in sizes
#     if pop >= size
#       final_size = _.indexOf(sizes, size)
#       break
#   
#   "http://#{window.http_host}/images/map_icons/city_#{kind}#{final_size}.png"

Utils.haml = (selector, object) ->
  haml = Haml $(selector).html()
  # console.log "haml: ", haml
  # console.log "selector: ", selector
  # console.log "rendering: ", object.attributes
  haml object.attributes
    
Utils.clone_object = (object) ->
  console.log("cloning: ", object)
  return eval("#{JSON.stringify(object)}")

class LLRange
  constructor: (lat, lng, range, prec) ->
    times = range / prec 
    @lats =  []
    @lngs = []
    for t in [0..times]
      @lats.push lat+prec*t 
    for t in [0..times]
      @lngs.push lng+prec*t 
    
  each: (fn) ->
    for lat in @lats
      for lng in @lngs
        fn(lat, lng)