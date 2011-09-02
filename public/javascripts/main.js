var Alliance, Army, ArmyDialog, AttackState, City, CityDialog, CityMarkerIcon, Dialog, DialogView, Game, GameState, LLRange, Location, Map, MapAction, MapAttack, MapMove, MapView, MarkerView, MarkersUpdater, MoveState, Player, PlayerView, Upgrade, Utils, console;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
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
PlayerView = Backbone.View.extend({
  render: function() {
    var content, haml;
    haml = Haml($("#playerView-tmpl").html());
    content = haml(this.model.attributes);
    $(this.el).html(content);
    return this;
  }
});
MapView = (function() {
  function MapView(map) {
    this.map = map;
    this.controller = null;
    this.markerZoomMin = 8;
    this.defaultZoom = 5;
  }
  MapView.prototype.draw = function() {
    this.get_center_and_zoom();
    this.doDrawing();
    this.listen_to_bounds();
    return this.autoSize();
  };
  MapView.prototype.doDrawing = function() {
    var mapDiv;
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
    this.map.controller = this.controller;
    return this.map.view = this;
  };
  MapView.prototype.get_center_and_zoom = function() {
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
      this.zoom = this.map.defaultZoom;
      return localStorage.zoom = this.zoom;
    }
  };
  MapView.prototype.set_default_coords = function() {
    this.center_lat = this.default_center_lat = 47.2;
    return this.center_lng = this.default_center_lng = 14.4;
  };
  MapView.prototype.listen_to_bounds = function() {
    this.listen();
    return google.maps.event.addListener(this.map, 'zoom_changed', __bind(function() {
      return this.zoom_changed();
    }, this));
  };
  MapView.prototype.listen = function() {
    return google.maps.event.addListenerOnce(this.map, "bounds_changed", __bind(function() {
      var center;
      center = this.map.getCenter();
      localStorage.center_lat = center.lat();
      localStorage.center_lng = center.lng();
      return setTimeout(__bind(function() {
        this.listen();
        return $(window).trigger("boundszoom_changed");
      }, this), 50);
    }, this));
  };
  MapView.prototype.zoom_changed = function() {
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
      return this.controller.clearMarkers();
    }
  };
  MapView.prototype.autoSize = function() {
    this.resize();
    return $(window).resize(__bind(function() {
      return this.resize();
    }, this));
  };
  MapView.prototype.resize = function() {
    var height;
    height = $("body").height() - $("h1").height() - 30;
    return $("#container, #map_canvas").height(height);
  };
  return MapView;
})();
DialogView = (function() {
  function DialogView(map, marker) {
    this.map = map;
    this.marker = marker;
    this.dialog = null;
    this.build();
    this.open();
  }
  DialogView.prototype.open = function() {
    return this.dialog.open(this.map, this.marker);
  };
  DialogView.prototype.build = function() {
    this.dialog = new InfoBubble({
      shadowStyle: 1,
      padding: 12,
      backgroundColor: "#EEE",
      borderRadius: 10,
      arrowSize: 20,
      borderWidth: 3,
      borderColor: '#666',
      disableAutoPan: false,
      hideCloseButton: false,
      arrowPosition: 30,
      backgroundClassName: 'bubbleBg',
      arrowStyle: 2,
      minWidth: 200,
      maxWidth: 700
    });
    return this.render();
  };
  DialogView.prototype.render = function() {
    var content, is_owned_by_current_player;
    content = this.marker.dialog.render().el;
    if (this.marker.type === "city") {
      this.dialog.addTab('Overview', content);
      is_owned_by_current_player = true;
      if (is_owned_by_current_player) {
        this.dialog.addTab('Structures', "faaaarming");
        this.dialog.addTab('Units', "faaaarming");
        this.dialog.addTab('Upgrades', "faaaarming");
      }
    } else {
      this.dialog.addTab('Army', content);
    }
    return this.dialog.addTab('Debug', "I will be useful...");
  };
  return DialogView;
})();
MarkerView = (function() {
  function MarkerView(map, data) {
    this.map = map;
    this.data = data;
    this.marker = null;
  }
  MarkerView.prototype.draw = function() {
    var anchor, army_icon, army_image, icon, latLng, marker, zIndex;
    if (!this.data.latitude) {
      console.log("ERROR: marker without lat,lng");
    }
    latLng = new google.maps.LatLng(this.data.latitude, this.data.longitude);
    if (this.data.city !== void 0) {
      this.data.type = "city";
    } else {
      this.data.type = "army";
    }
    army_image = "http://" + window.http_host + "/images/map_icons/army_ally.png";
    zIndex = this.data.type === "army" ? -1 : -2;
    this.marker = marker = new google.maps.Marker({
      position: latLng,
      map: this.map.map,
      player: this.data.player,
      zIndex: zIndex
    });
    marker.location_id = this.data.id;
    if (this.data.type === "city") {
      marker.type = "city";
      marker.name = this.data.city.name;
      marker.city = this.data.city;
      marker.army = void 0;
      icon = new CityMarkerIcon(this.data.city.pts, "enemy");
      marker.icon = icon.draw();
    } else {
      marker.type = "army";
      marker.name = "Army";
      marker.army = this.data.army;
      marker.city = void 0;
      anchor = new google.maps.Point(25, 20);
      army_icon = new google.maps.MarkerImage(army_image, null, null, anchor, null);
      marker.icon = army_icon;
    }
    marker.view = self;
    marker.model = null;
    marker.dialog = null;
    if (this.data.type === "army") {
      marker.model = new Army(this.data);
      marker.dialog = new ArmyDialog({
        model: marker.model
      });
    } else {
      marker.model = new City(this.data);
      marker.dialog = new CityDialog({
        model: marker.model
      });
    }
    google.maps.event.addListener(marker, 'click', __bind(function() {
      return this.map.attachDialog(marker);
    }, this));
    return this;
  };
  return MarkerView;
})();
CityMarkerIcon = (function() {
  function CityMarkerIcon(pts) {
    this.pts = pts;
  }
  CityMarkerIcon.prototype.draw = function() {
    var anchor, city_image, height, scale, size, width;
    scale = Utils.city_scale(this.pts);
    width = 90 * scale;
    height = 59 * scale;
    anchor = new google.maps.Point(width / 2, height / 2);
    size = new google.maps.Size(width, height);
    city_image = "http://" + window.http_host + "/images/map_icons/city_enemy.png";
    return new google.maps.MarkerImage(city_image, null, null, anchor, size);
  };
  return CityMarkerIcon;
})();
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
      icon = new CityMarkerIcon(this.data.city.pts, "selected");
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
      icon: "http://" + window.http_host + "/images/map_icons/point_red.png"
    });
  };
  return MapMove;
})();
MarkersUpdater = (function() {
  function MarkersUpdater(map) {
    this.map = map;
    this.tickLast = __bind(this.tickLast, this);
    this.tick = __bind(this.tick, this);
  }
  MarkersUpdater.prototype.start = function() {
    this.time2 = new Date();
    this.timer = new Date();
    $(window).bind("boundszoom_changed", __bind(function() {
      return this.tick();
    }, this));
    return $(window).everyTime(1500, __bind(function() {
      return this.tickLast(this.time2);
    }, this));
  };
  MarkersUpdater.prototype.tick = function() {
    var time;
    time = new Date() - this.timer;
    this.time2 = new Date();
    if (time > 1000) {
      this.map.loadMarkers();
      this.time2 = new Date();
      return this.timer = new Date();
    }
  };
  MarkersUpdater.prototype.tickLast = function(external_time) {
    var time;
    time = new Date() - external_time;
    if (time > 1000 && time < 2000) {
      return this.map.loadMarkers();
    }
  };
  return MarkersUpdater;
})();
if (!console) {
  console = {};
  console.log = {};
}
Utils = {};
Utils.parseCoords = function(string) {
  var split;
  split = string.replace(/\s/, '').split(",");
  return [split[0], split[1]];
};
Utils.nthroot = function(x, n) {
  return Math.pow(x, 1 / n);
};
Utils.city_scale = function(pop, kind) {
  return Utils.nthroot(pop / 40000, 5);
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
    this.max_simultaneous_markers = 600;
    this.dialogs = [];
    this.markers = [];
    this.map = null;
  }
  Map.prototype.draw = function() {
    var mapView;
    mapView = new MapView();
    mapView.controller = this;
    mapView.draw();
    return this.map = mapView.map;
  };
  Map.prototype.markersUpdateStart = function() {
    var markersUpdater;
    markersUpdater = new MarkersUpdater(this);
    return markersUpdater.start();
  };
  Map.prototype.center = function(lat, lng) {
    var latLng;
    latLng = new google.maps.LatLng(lat, lng);
    return this.map.panTo(latLng);
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
  Map.prototype.loadMarkers = function() {
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
      return this.drawMarkers(markers);
    }, this));
  };
  Map.prototype.attachDialog = function(marker) {
    var dia, is_army, lastMark, mark, marker_id, nextMarker, _i, _j, _len, _len2, _ref, _ref2;
    _ref = this.dialogs;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      dia = _ref[_i];
      dia.dialog.close();
    }
    if (this.dialogs.length !== 0) {
      lastMark = _.last(this.dialogs).marker;
    }
    if (this.dialogs.length === 0 || lastMark.location_id !== marker.location_id) {
      return this.openDialog(marker);
    } else {
      nextMarker = marker;
      is_army = function(m) {
        return !m.model.attributes.city;
      };
      marker_id = function(m) {
        if (is_army(m)) {
          return "" + m.type + "_" + m.model.attributes.army.id;
        } else {
          return "" + m.type + "_" + m.model.attributes.city.id;
        }
      };
      _ref2 = this.markers;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        mark = _ref2[_j];
        if (lastMark.location_id === mark.location_id && marker_id(mark) !== marker_id(lastMark)) {
          nextMarker = mark;
        }
      }
      return this.openDialog(nextMarker);
    }
  };
  Map.prototype.openDialog = function(marker) {
    return setTimeout(__bind(function() {
      var dialog;
      dialog = new DialogView(this.map, marker);
      return this.dialogs.push(dialog);
    }, this), 10);
  };
  Map.prototype.drawMarkers = function(markers) {
    var marker, _i, _len, _results;
    this.timer = new Date();
    _results = [];
    for (_i = 0, _len = markers.length; _i < _len; _i++) {
      marker = markers[_i];
      _results.push(this.drawMarker(marker));
    }
    return _results;
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
  Map.prototype.doMarkerDrawing = function(data) {
    var marker, markerView;
    markerView = new MarkerView(this, data);
    marker = markerView.draw().marker;
    this.markers.push(marker);
    return marker.setMap(this.map);
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
  Map.prototype.clickInfo = function() {
    return google.maps.event.addListener(this.map, 'click', function(evt) {});
  };
  Map.prototype.raise = function(message) {
    return console.log("Exception: ", message);
  };
  return Map;
})();
Game = (function() {
  function Game() {
    this.map = new Map;
    this.current_player = null;
    this.current_playerView = null;
  }
  Game.prototype.initMap = function() {
    this.map.draw();
    this.map.loadMarkers();
    return this.map.markersUpdateStart();
  };
  Game.prototype.getPlayerView = function() {
    return $.getJSON("/players/me", __bind(function(player) {
      return this.initPlayerView(player);
    }, this));
  };
  Game.prototype.initPlayerView = function(player) {
    this.current_player = new Player(player);
    this.current_playerView = new PlayerView({
      model: this.current_player
    });
    return $("#player").append(this.current_playerView.render().el);
  };
  Game.prototype.initNav = function() {
    return $("#nav li").hover(function() {
      return $(this).find("div").show();
    }, function() {
      return $(this).find("div").hide();
    });
  };
  return Game;
})();
$(function() {
  var g;
  g = window;
  g.game = new Game;
  game.initMap();
  game.getPlayerView();
  return game.initNav();
});
$("#latLng").bind("submit", function() {
  var coords;
  coords = $(this).find("input").val();
  coords = Utils.parseCoords(coords);
  map.center(coords[0], coords[1]);
  return false;
});