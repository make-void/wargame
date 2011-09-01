beforeEach( ->
  this.addMatchers({
    toBeArray: ->
      typeof(this.actual) == "object" && typeof(this.actual.length) == "number"

    toBeA: (expected_klass) ->
      switch expected_klass
        when "Player" then this.actual.attributes.name == "Cor3y"
        else "Object class: #{klass} -  not found!"
  })
)


window.http_host