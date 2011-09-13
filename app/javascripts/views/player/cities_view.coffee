class CitiesView extends Backbone.View 
  
  initialize: ->
    # Cities.bind('all',   this.render, this)
    Cities.bind('add',   this.addOne, this)
    Cities.bind('reset', this.addAll, this)

  render: ->
    # console.log Queue
    # haml = Haml $("#citiesView-tmpl").html()
    # content = haml({})
    # console.log("rel: ", this.el)
    # $(this.el).html content
    this
    
  addOne: (city) ->
    console.log "add city", city  
    view = new CityView model: city
    content = view.render().el
    console.log "cont", content
    this.$(".cities ul").append content
    # console.log "cont", this.$(".cities ul")
  
  addAll: ->
    Cities.each this.addOne
    