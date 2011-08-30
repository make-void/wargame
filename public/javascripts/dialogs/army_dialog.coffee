ArmyDialog  = Dialog.extend(
  initialize: ->
    selector = "#armyDialog-tmpl"
    Dialog.prototype.initialize selector # how to call super in js
  
  activateButtons: ->
    model = this.model
    $(this.el).find(".move").bind('click', ->
      console.log("moving")
      map_move = new MapMove(model)
      # map_move.deactivate()
      GameState.current = "move"
    )
    
    $(this.el).find(".attack").bind('click', ->
      console.log("attaaaack!")
      map_attack = new MapAttack(model)      
      # map_attack.deactivate()
      GameState.current = "attack"
    )
    


  afterRender: ->
    haml = Haml($("#armyActionsMenu-tmpl").html())
    content = haml({})
    $(this.el).find(".commands").append content
    
    
    this.activateButtons()
  
  label: ->
    player.name
)