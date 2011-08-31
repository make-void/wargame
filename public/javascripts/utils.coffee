#use console.log safely
unless console
  console = {} 
  console.log = {}


# map utils

Utils = {}

Utils.parseCoords = (string) ->
  split = string.replace(/\s/, '').split(",")
  return [split[0], split[1]]

# move in city model (or ancestor)
Utils.city_image = (pop, kind) ->
  kind = "enemy" unless kind
  sizes = [
    150000,
    50000, 
    30000,
    12000,
    0 # 6000
  ]
  size = sizes[-1]
  
  for size in sizes
    if pop >= size
      final_size = _.indexOf(sizes, size)
      break
  
  "http://" + http_host + "/images/map_icons/city_#{kind}#{final_size}.png"


Utils.clone_object = (object) ->
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