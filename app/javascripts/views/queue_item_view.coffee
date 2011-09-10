class QueueItemView extends Backbone.View  
  tagName:  "li"
  
  render: ->
    Utils.haml("#queueItemView-tmpl", this.model) 
    