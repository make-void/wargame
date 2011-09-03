CityDialog  = Dialog.extend(
  initialize: ->
    @type = "city"
    Dialog.prototype.initialize # how to call super in js
    
  label: ->
    city.name
)