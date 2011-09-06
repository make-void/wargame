StructsDialog  = GenericDialog.extend(
  initialize: ->
    @type = "city_structs"
    GenericDialog.prototype.initialize @type# how to call super in js
)