DebugDialog  = GenericDialog.extend(
  initialize: ->
    @type = "debug"
    GenericDialog.prototype.initialize @type
)