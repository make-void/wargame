var Alliance, Army, ArmyDialog, ArmyMarker, AttackState, City, CityDialog, CityMarker, Dialog, GameState, LLRange, Location, LocationMarker, Map, MapAction, MapAttack, MapMove, MoveState, Player, Upgrade, Utils, console, utils;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
GameState = {
  "default": "browse",
  states: ["browse", "move", "attack"]
};
MoveState = {
  "default": "wait",
  states: ["wait", "choose", "selected"]
};
AttackState = {
  "default": "wait",
  states: ["wait", "choose", "selected"]
};
LocationMarker = Backbone.View.extend({
  render: function() {
    return this;
  }
});
CityMarker = LocationMarker.extend({
  initialize: function() {}
});
ArmyMarker = LocationMarker.extend();
Dialog = Backbone.View.extend({
  initialize: function() {},
  afterRender: function() {},
  render: function() {
    var content, haml;
    haml = Haml($(this.selector).html());
    content = haml(this.model.attributes);
    $(this.el).html(content);
    this.afterRender();
    return this;
  }
});
CityDialog = Dialog.extend({
  initialize: function() {
    this.selector = "#cityDialog-tmpl";
    return Dialog.prototype.initialize;
  },
  label: function() {
    return city.name;
  }
});
ArmyDialog = Dialog.extend({
  initialize: function() {
    this.selector = "#armyDialog-tmpl";
    return Dialog.prototype.initialize;
  },
  activateButtons: function() {
    var model;
    model = this.model;
    $(this.el).find(".move").bind('click', function() {
      var map_move;
      console.log("moving");
      map_move = new MapMove(model);
      return GameState.current = "move";
    });
    return $(this.el).find(".attack").bind('click', function() {
      var map_attack;
      console.log("attaaaack!");
      map_attack = new MapAttack(model);
      return GameState.current = "attack";
    });
  },
  afterRender: function() {
    var content, haml;
    haml = Haml($("#armyActionsMenu-tmpl").html());
    content = haml({});
    $(this.el).find(".commands").append(content);
    return this.activateButtons();
  },
  label: function() {
    return player.name;
  }
});
MapAction = (function() {
  function MapAction() {
    this.map = window.map.map;
  }
  return MapAction;
})();
MapAttack = (function() {
  __extends(MapAttack, MapAction);
  function MapAttack(location) {
    this.location = location;
    MapAttack.__super__.constructor.apply(this, arguments);
    this.circle = null;
    this.drawCircle();
    this.hoverCities();
  }
  MapAttack.prototype.drawCircle = function() {
    var center;
    center = new google.maps.LatLng(this.location.attributes.latitude, this.location.attributes.longitude);
    this.circle = new google.maps.Circle({
      map: this.map,
      center: center,
      radius: 5500,
      fillColor: "#FF0000",
      fillOpacity: 0.3,
      strokeColor: "#CC0000",
      strokeOpacity: 0.7,
      strokeWeight: 3
    });
    this.circle.setMap(this.map);
    return console.log(this.map);
  };
  MapAttack.prototype.hoverCities = function() {
    var marker, _i, _len, _ref, _results;
    _ref = this.map.controller.markers;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      marker = _ref[_i];
      _results.push(marker.type === "city" ? this.hoverCity(marker) : void 0);
    }
    return _results;
  };
  MapAttack.prototype.hoverCity = function(marker) {
    var addListener;
    addListener = google.maps.event.addListener;
    addListener(marker, "mouseover", __bind(function(evt) {
      var icon;
      icon = Utils.city_image(marker.data.city.pts, "selected");
      if (marker.icon !== icon) {
        marker.nonhover_icon = Utils.clone_object(marker.icon);
        marker.icon = icon;
        return marker.setMap(this.map);
      }
    }, this));
    return addListener(marker, "mouseout", __bind(function(evt) {
      if (marker.nonhover_icon) {
        marker.icon = marker.nonhover_icon;
        return marker.setMap(this.map);
      }
    }, this));
  };
  return MapAttack;
})();
MapMove = (function() {
  __extends(MapMove, MapAction);
  function MapMove(location) {
    var loc;
    this.line = null;
    this.active = true;
    this.destination = null;
    this.endMarker = null;
    MapMove.__super__.constructor.apply(this, arguments);
    loc = location.attributes;
    google.maps.event.addListener(this.map, "mousemove", __bind(function(evt) {
      return this.draw(loc, evt);
    }, this));
    this.deactivationHook();
  }
  MapMove.prototype.draw = function(loc, evt) {
    var points;
    if (this.active) {
      this.destination = evt.latLng;
      points = [new google.maps.LatLng(loc.latitude, loc.longitude), this.destination];
      if (this.line) {
        this.line.setMap(null);
      }
      this.line = new google.maps.Polyline({
        path: points,
        strokeColor: "#FF0000",
        strokeOpacity: 1.0,
        strokeWeight: 2
      });
      return this.line.setMap(this.map);
    }
  };
  MapMove.prototype.deactivationHook = function() {
    return $("#map_canvas").bind("click", __bind(function() {
      return this.deactivate();
    }, this));
  };
  MapMove.prototype.deactivate = function() {
    this.active = false;
    return this.endMarker = new google.maps.Marker({
      position: this.destination,
      map: this.map,
      icon: "http://" + http_host + "/images/map_icons/point_red.png"
    });
  };
  return MapMove;
})();
Utils = {};
Utils.city_image = function(pop, kind) {
  var final_size, size, sizes, _i, _len;
  if (!kind) {
    kind = "enemy";
  }
  sizes = [150000, 50000, 30000, 12000, 0];
  size = sizes[-1];
  for (_i = 0, _len = sizes.length; _i < _len; _i++) {
    size = sizes[_i];
    if (pop >= size) {
      final_size = _.indexOf(sizes, size);
      break;
    }
  }
  return "http://" + http_host + ("/images/map_icons/city_" + kind + final_size + ".png");
};
Utils.clone_object = function(object) {
  return eval("" + (JSON.stringify(object)));
};
LLRange = (function() {
  function LLRange(lat, lng, range, prec) {
    var t, times;
    times = range / prec;
    this.lats = [];
    this.lngs = [];
    for (t = 0; 0 <= times ? t <= times : t >= times; 0 <= times ? t++ : t--) {
      this.lats.push(lat + prec * t);
    }
    for (t = 0; 0 <= times ? t <= times : t >= times; 0 <= times ? t++ : t--) {
      this.lngs.push(lng + prec * t);
    }
  }
  LLRange.prototype.each = function(fn) {
    var lat, lng, _i, _len, _ref, _results;
    _ref = this.lats;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      lat = _ref[_i];
      _results.push((function() {
        var _j, _len2, _ref2, _results2;
        _ref2 = this.lngs;
        _results2 = [];
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          lng = _ref2[_j];
          _results2.push(fn(lat, lng));
        }
        return _results2;
      }).call(this));
    }
    return _results;
  };
  return LLRange;
})();
Location = Backbone.Model.extend({});
Army = Location.extend({});
City = Location.extend({});
Player = Backbone.Model.extend({});
Upgrade = Backbone.Model.extend({});
Alliance = Backbone.Model.extend({});
Map = (function() {
  function Map() {
    this.markerZoomMin = 7;
    this.max_simultaneous_markers = 600;
    this.dialogs = [];
    this.markers = [];
    this.defaultZoom = 5;
    this.map = null;
  }
  Map.prototype.set_default_coords = function() {
    this.center_lat = this.default_center_lat = 47.2;
    return this.center_lng = this.default_center_lng = 14.4;
  };
  Map.prototype.get_center_and_zoom = function() {
    if (localStorage.center_lat && localStorage.center_lng) {
      this.center_lat = parseFloat(localStorage.center_lat);
      this.center_lng = parseFloat(localStorage.center_lng);
    } else {
      this.set_default_coords();
      localStorage.center_lat = this.center_lat;
      localStorage.center_lng = this.center_lng;
    }
    if (localStorage.zoom) {
      return this.zoom = parseInt(localStorage.zoom);
    } else {
      this.zoom = this.defaultZoom;
      return localStorage.zoom = this.zoom;
    }
  };
  Map.prototype.center = function(lat, lng) {
    var latLng;
    latLng = new google.maps.LatLng(lat, lng);
    return this.map.panTo(latLng);
  };
  Map.prototype.draw = function() {
    var mapDiv;
    this.get_center_and_zoom();
    mapDiv = document.getElementById('map_canvas');
    if (!this.center_lat) {
      this.center_lat = this.default_center_lat;
    }
    if (!this.center_lng) {
      this.center_lng = this.default_center_lng;
    }
    this.map = new google.maps.Map(mapDiv, {
      center: new google.maps.LatLng(this.center_lat, this.center_lng),
      zoom: this.zoom,
      mapTypeId: google.maps.MapTypeId.TERRAIN,
      disableDefaultUI: true,
      navigationControl: true,
      navigationControlOptions: {
        style: google.maps.NavigationControlStyle.SMALL,
        position: google.maps.ControlPosition.RIGHT_TOP
      }
    });
    return this.map.controller = this;
  };
  Map.prototype.autoSize = function() {
    this.resize();
    return $(window).resize(__bind(function() {
      return this.resize();
    }, this));
  };
  Map.prototype.resize = function() {
    var height;
    height = $("body").height() - $("h1").height() - 30;
    return $("#container, #map_canvas").height(height);
  };
  Map.prototype.markersCleanMax = function() {
    var marker, max_markers, _i, _len, _ref;
    max_markers = this.max_simultaneous_markers;
    if (this.markers.length > max_markers) {
      _ref = this.markers.slice(0, (-max_markers + 1 + 1) || 9e9);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        marker = _ref[_i];
        marker.setMap(null);
      }
      return this.markers = this.markers.slice(-max_markers);
    }
  };
  Map.prototype.loadMarkers = function(callback) {
    var center;
    if (localStorage.zoom < this.markerZoomMin) {
      return;
    }
    this.markersCleanMax();
    center = this.map.getCenter();
    return $.getJSON("/locations/" + (center.lat()) + "/" + (center.lng()), __bind(function(data) {
      var marker, markers, _i, _len, _ref;
      markers = [];
      _ref = data.locations;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        marker = _ref[_i];
        markers.push(marker);
      }
      this.timer = new Date();
      return this.callback(markers);
    }, this));
  };
  Map.prototype.doMarkerDrawing = function(data) {
    var anchor, army_icon, army_image, latLng, marker, that;
    if (!data.latitude) {
      console.log("ERROR: marker without lat,lng");
    }
    latLng = new google.maps.LatLng(data.latitude, data.longitude);
    army_image = "http://" + http_host + "/images/map_icons/army_ally.png";
    marker = new google.maps.Marker({
      position: latLng,
      map: this.map,
      player: data.player
    });
    if (data.city !== void 0) {
      marker.name = data.city.name;
      marker.city = data.city;
      marker.army = void 0;
      marker.icon = Utils.city_image(data.city.pts);
      marker.type = "city";
      data.type = "city";
    } else {
      marker.name = "Army";
      marker.army = data.army;
      marker.city = void 0;
      anchor = new google.maps.Point(25, 20);
      army_icon = new google.maps.MarkerImage(army_image, null, null, anchor, null);
      marker.icon = army_icon;
      marker.type = "army";
      data.type = "army";
    }
    marker.data = data;
    marker.model = null;
    marker.dialog = null;
    if (marker.type === "army") {
      marker.model = new Army(data);
      marker.dialog = new ArmyDialog({
        model: marker.model
      });
    } else {
      marker.model = new City(data);
      marker.dialog = new CityDialog({
        model: marker.model
      });
    }
    this.markers.push(marker);
    that = this;
    return google.maps.event.addListener(marker, 'click', function() {
      return that.attachDialog(marker);
    });
  };
  Map.prototype.attachDialog = function(marker) {
    var content, dia, dialog, model, _i, _len, _ref;
    _ref = this.dialogs;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      dia = _ref[_i];
      dia.close();
    }
    model = null;
    content = marker.dialog.render().el;
    dialog = new InfoBubble({
      content: content,
      shadowStyle: 1,
      padding: 12,
      backgroundColor: "#EEE",
      borderRadius: 10,
      arrowSize: 20,
      borderWidth: 3,
      borderColor: '#666',
      disableAutoPan: true,
      hideCloseButton: false,
      arrowPosition: 30,
      backgroundClassName: 'bubbleBg',
      arrowStyle: 2,
      minWidth: 200,
      maxWidth: 700
    });
    dialog.open(this.map, marker);
    if (marker.type === "city") {
      dialog.addTab('Overview', content);
      dialog.addTab('Build', "faaaarming");
    }
    return this.dialogs.push(dialog);
  };
  Map.prototype.drawMarker = function(data) {
    var draw, is_a_city, mark, _i, _len, _ref;
    draw = true;
    _ref = this.markers;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      mark = _ref[_i];
      is_a_city = data.city && mark.city;
      if (is_a_city && mark.city.id === data.city.id) {
        draw = false;
      }
    }
    if (draw) {
      return this.doMarkerDrawing(data);
    }
  };
  Map.prototype.callback = function(markers) {
    var marker, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = markers.length; _i < _len; _i++) {
      marker = markers[_i];
      _results.push(this.drawMarker(marker));
    }
    return _results;
  };
  Map.prototype.listen_to_bounds = function() {
    return google.maps.event.addListenerOnce(this.map, "bounds_changed", __bind(function() {
      var center;
      center = this.map.getCenter();
      localStorage.center_lat = center.lat();
      localStorage.center_lng = center.lng();
      return setTimeout(__bind(function() {
        this.listen_to_bounds();
        return $(window).trigger("boundszoom_changed");
      }, this), 50);
    }, this));
  };
  Map.prototype.clearMarkers = function() {
    var marker, _i, _len, _ref;
    _ref = this.markers;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      marker = _ref[_i];
      marker.setMap(null);
    }
    return this.markers = [];
  };
  Map.prototype.listen = function() {
    this.listen_to_bounds();
    return google.maps.event.addListener(this.map, 'zoom_changed', __bind(function() {
      var zoom;
      zoom = this.map.getZoom();
      if (zoom < this.defaultZoom) {
        this.map.setZoom(this.defaultZoom);
        zoom = this.defaultZoom;
      }
      if (zoom > 11) {
        this.map.setZoom(11);
        zoom = 11;
      }
      localStorage.zoom = zoom;
      if (zoom < this.markerZoomMin) {
        return this.clearMarkers();
      }
    }, this));
  };
  Map.prototype.clickInfo = function() {
    return google.maps.event.addListener(this.map, 'click', function(evt) {});
  };
  Map.prototype.drawLine = function(points) {
    var line;
    line = new google.maps.Polyline({
      path: points,
      strokeColor: "#FF0000",
      strokeOpacity: 1.0,
      strokeWeight: 2
    });
    return line.setMap(this.map);
  };
  Map.prototype.startFetchingMarkers = function() {
    return google.maps.event.addListener(this.map, 'tilesloaded', __bind(function() {
      var self, time2;
      self = this;
      time2 = new Date();
      this.timer = new Date();
      $(window).bind("boundszoom_changed", function() {
        var time;
        time = new Date() - self.timer;
        time2 = new Date();
        if (time > 1000) {
          self.loadMarkers();
          time2 = new Date();
          return self.timer = new Date();
        }
      });
      return $(window).everyTime(1500, function(i) {
        var time3;
        time3 = new Date() - time2;
        if (time3 > 1000 && time3 < 2000) {
          return self.loadMarkers();
        }
      });
    }, this));
  };
  Map.prototype.debug = function(what) {
    return $(window).oneTime(1000, function() {
      var army, marker, _i, _len, _ref;
      army = null;
      _ref = map.markers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        marker = _ref[_i];
        if (marker.type === "army") {
          army = marker;
          break;
        }
      }
      window.arm = army;
      army.dialog.render();
      return $(army.dialog.el).find("." + what).trigger("click");
    });
  };
  Map.prototype.raise = function(message) {
    return console.log("Exception: ", message);
  };
  return Map;
})();
utils = {};
utils.parseCoords = function(string) {
  var split;
  split = string.replace(/\s/, '').split(",");
  return [split[0], split[1]];
};
if (!console) {
  console = {};
  console.log = {};
}
$(function() {
  var g;
  g = window;
  g.army_test = new Army({
    asd: "lol"
  });
  g.armyMarker = new ArmyMarker({
    model: army_test
  });
  $("#debug").append(armyMarker.render().el);
  $("#nav li").hover(function() {
    return $(this).find("div").show();
  }, function() {
    return $(this).find("div").hide();
  });
  $("#latLng").bind("submit", function() {
    var coords;
    coords = $(this).find("input").val();
    coords = utils.parseCoords(coords);
    map.center(coords[0], coords[1]);
    return false;
  });
  $(window).oneTime(1000, function() {
    var army, marker, _i, _len, _ref;
    army = null;
    _ref = map.markers;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      marker = _ref[_i];
      if (marker.type === "army") {
        army = marker;
        break;
      }
    }
    return window.arm = army;
  });
  g.map = new Map;
  map.draw();
  map.loadMarkers();
  map.listen();
  map.startFetchingMarkers();
  return map.autoSize();
});