UnitsDialog  = GenericDialog.extend(
  initialize: ->
    @type = "city_units"
    GenericDialog.prototype.initialize @type# how to call super in js
)