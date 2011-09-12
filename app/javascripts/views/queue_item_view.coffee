class QueueItemView extends Backbone.View  
  tagName:  "li"

  events: {
    "click .removeButton": "removeItem"
  }  
  
  
  render: ->
    $(this.el).html Utils.haml("#queueItemView-tmpl", this.model) 
    this
    
    
  removeItem: ->
    console.log "removing item from queue"
    Spinner.spin()
    attrs = this.model.attributes
    console.log attrs
    post = { _method: 'delete', player_id: attrs.player_id, structure_id: attrs.structure_id, unit_id: attrs.unit_id }
    $.post("/players/me/cities/#{attrs.city_id}/queues/#{attrs.type}", post, (data)  =>
      $(this.el).parent().html ""
      Spinner.hide()
    )
    
    