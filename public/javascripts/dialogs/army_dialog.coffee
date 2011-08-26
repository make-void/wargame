GameState = { 
  current: "browse",
  states: ["browse", "move", "attack"]
  
  # redefine current= and act on status change
  
}

ArmyDialog  = Dialog.extend(
  initialize: ->
    selector = "#armyDialog-tmpl"
    Dialog.prototype.initialize selector # how to call super in js
  
  activateButtons: ->
    
    $(this.el).find(".move").bind('click', ->
      console.log("moving")
      GameState.current = "move"
    )
    
    $(this.el).find(".attack").bind('click', ->
      console.log("attaaaack!")
      GameState.current = "move"
    )
    


  afterRender: ->
    haml = Haml($("#armyActionsMenu-tmpl").html())
    content = haml({})
    $(this.el).find(".commands").append content
    
    
    this.activateButtons()
  
  label: ->
    player.name
)