class QueueView extends Backbone.View
  
  initialize: (opts) -> # remember to not call this method constructor for Backbone.Views
    @dialog = opts.dialog
    window.queueViewDialog = @dialog
    console.log "diadia: ", @dialog
    Queue.bind('add',   this.addOne, this)
    Queue.bind('reset', this.addAll, this)
    window.laurafica = this

  render: ->
    haml = Haml $("#queueView-tmpl").html()
    content = haml({ errors: [] })
    $(this.el).html content

    this
    
  addOne: (queueItem) ->    
    window.laurafica.$(".queueItems").html("")
    @dialog = window.queueViewDialog # FIXME: BAD HACK
    view = new QueueItemView model: queueItem
    content = view.render().el
    window.laurafica = this
    self = this
    $(this).find(".queueItems").load( -> # wtf?
      # console.log "elem: ", this
    )
    setTimeout( -> # FIXME: setTimeout is bad, intercept the real event (also ito doesnt works)
      self.$(".queueItems").append content
    , 1)
    @dialog.renderOverview()

  addAll: ->
    Queue.each this.addOne