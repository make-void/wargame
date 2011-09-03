CityDialog  = Dialog.extend(
  initialize: ->
    @type = "city"
    Dialog.prototype.initialize @type# how to call super in js
    
  label: ->
    city.name
)