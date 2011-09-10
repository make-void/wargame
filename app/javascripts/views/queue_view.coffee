class QueueView extends Backbone.View
  
  initialize: -> # remember to not call constructor for Backbone.Views
    Queue.bind('add',   this.addOne, this)
    Queue.bind('reset', this.addAll, this)

  render: ->
    haml = Haml $("#queueView-tmpl").html()
    content = haml({ errors: [] })
    $(this.el).html content

    this
    
  addOne: (queueItem) ->    
    view = new QueueItemView model: queueItem
    content = view.render()
    console.log "item: ", queueItem
    console.log "content: ", content
    this.$(".queueItems").append content    

  addAll: ->
    Queue.each this.addOne