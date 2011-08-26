ArmyDialog  = Dialog.extend(
  initialize: ->
    selector = "#armyDialog-tmpl"
    Dialog.prototype.initialize selector # how to call super in js
  
  afterRender: ->
    haml = Haml($("#armyActionsMenu-tmpl").html())
    content = haml({})
    $(this.el).find(".commands").append content
  
  label: ->
    player.name
)