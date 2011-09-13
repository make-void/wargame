class QueueItemView extends Backbone.View  
  tagName:  "li"

  events: {
    "click .removeButton": "clear"
  }  
  
  initialize: ->
    this.model.bind 'destroy', this.remove, this
  
  render: ->
    $(this.el).html Utils.haml("#queueItemView-tmpl", this.model) 
    this
    
  clear: ->
    this.model.destroy()
    
  remove: ->
    console.log "removing item from queue"
    Spinner.spin()
    attrs = this.model.attributes
    console.log attrs
    # TODO: check if it's a structure or not and assign id
    object_id = attrs.structure_id
    post = { _method: 'delete', player_id: attrs.player_id, object_id: object_id, unit_id: attrs.unit_id }
    $.post("/players/me/cities/#{attrs.city_id}/queues/#{attrs.type}", post, (data)  =>
      $(this.el).parent().html ""
      Spinner.hide()
    )
    
        