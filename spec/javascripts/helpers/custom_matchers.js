(function() {
  beforeEach(function() {
    return this.addMatchers({
      toBeArray: function() {
        return typeof this.actual === "object" && typeof this.actual.length === "number";
      },
      toBeA: function(expected_klass) {
        switch (expected_klass) {
          case "Player":
            return this.actual.attributes.name === "Cor3y";
          default:
            return "Object class: " + klass + " -  not found!";
        }
      }
    });
  });
  window.http_host;
}).call(this);
