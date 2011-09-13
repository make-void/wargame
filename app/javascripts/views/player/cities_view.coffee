class CitiesView extends Backbone.View 
  
  initialize: ->
    Cities.bind('add',   this.addOne, this)
    Cities.bind('reset', this.addAll, this)

  render: ->
    this
    
  addOne: (city) ->
    view = new CityView model: city
    content = view.render().el
    this.$(".cities ul").append content
  
  addAll: ->
    Cities.each this.addOne