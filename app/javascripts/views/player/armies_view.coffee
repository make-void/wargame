class ArmiesView extends Backbone.View 
  
  initialize: ->
    Armies.bind('add',   this.addOne, this)
    Armies.bind('reset', this.addAll, this)

  render: ->
    this
    
  addOne: (city) ->
    view = new ArmyView model: city
    content = view.render().el
    this.$(".armies ul").append content
  
  addAll: ->
    Armies.each this.addOne