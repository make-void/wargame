StructsDialog  = GenericDialog.extend(
  initialize: ->
    @type = "city_structs"
    GenericDialog.prototype.initialize @type# how to call super in js
    
  
  events: {
    "click .btn.upgrade": "upgrade"
  }  
  
  
  upgrade: ->
    console.log "upgrading"
    # Queue#fetch
    city_id = 42768
    type = "struct"
    type_id = 1
    Spinner.spin()
    $.post("/players/me/cities/#{city_id}/queues/#{type}/#{type_id}", (data) ->
      console.log data
      
      Spinner.hide()
    )
    
  
  renderCosts: ->
    console.log "costs: ", $(this.el).find(".cost")
    
)