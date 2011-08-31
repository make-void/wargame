CityDialog  = Dialog.extend(
  initialize: ->
    @selector = "#cityDialog-tmpl"
    Dialog.prototype.initialize # how to call super in js
    
  label: ->
    city.name
)