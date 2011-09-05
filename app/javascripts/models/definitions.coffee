class Definitions
  constructor: ->
    
  get: (fn) ->
    $.getJSON("/definitions", (data) ->
      fn(data)
    )