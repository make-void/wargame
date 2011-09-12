class QueueView extends Backbone.View
  
  initialize: (opts) -> # remember to not call this method constructor for Backbone.Views
    @dialog = opts.dialog
    window.queueViewDialog = @dialog
    Queue.unbind('all')
    Queue.unbind('add')
    Queue.unbind('reset')
    Queue.bind('all',   this.render, this)
    Queue.bind('add',   this.addOne, this)
    Queue.bind('reset', this.addAll, this)

  render: ->
    # console.log Queue
    haml = Haml $("#queueView-tmpl").html()
    content = haml({ errors: [] })
    $(this.el).html content

    this
    
  addOne: (queueItem) ->    
    @dialog = window.queueViewDialog # FIXME: BAD HACK
    view = new QueueItemView model: queueItem
    content = view.render().el
    self = this
    $(this).find(".queueItems").load( -> # wtf?
      # console.log "elem: ", this
    )
    setTimeout( -> # FIXME: setTimeout is bad, intercept the real event (also ito doesnt works)
      self.$(".queueItems").append content
    , 1)
    @dialog.renderOverview()

  addAll: ->
    console.log "reeeset"
    this.$(".queueItems").html("")
    Queue.each this.addOne