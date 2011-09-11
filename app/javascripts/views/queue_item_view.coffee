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