var Alliance, Army, ArmyDialog, ArmyMarker, City, CityDialog, CityMarker, Dialog, GameState, LLRange, Location, LocationMarker, Map, Player, Upgrade, utils;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
LocationMarker = Backbone.View.extend({
  initialize: function() {},
  render: function() {
    return this;
  }
});
CityMarker = LocationMarker.extend({
  initialize: function() {}
});
ArmyMarker = LocationMarker.extend({
  initialize: function() {}
});
Dialog = Backbone.View.extend({
  initialize: function(selector) {
    return this.template = Haml($(selector).html());
  },
  afterRender: function() {},
  render: function() {
    var content;
    content = this.template(this.model.attributes);
    $(this.el).html(content);
    this.afterRender();
    return this;
  }
});
CityDialog = Dialog.extend({
  initialize: function() {
    var selector;
    selector = "#cityDialog-tmpl";
    return Dialog.prototype.initialize(selector);
  },
  label: function() {
    return city.name;
  }
});
GameState = {
  current: "browse",
  states: ["browse", "move", "attack"]
};
ArmyDialog = Dialog.extend({
  initialize: function() {
    var selector;
    selector = "#armyDialog-tmpl";
    return Dialog.prototype.initialize(selector);
  },
  activateButtons: function() {
    $(this.el).find(".move").bind('click', function() {
      console.log("moving");
      return GameState.current = "move";
    });
    return $(this.el).find(".attack").bind('click', function() {
      console.log("attaaaack!");
      return GameState.current = "move";
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
    return this.map = new google.maps.Map(mapDiv, {
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
    return $.getJSON("/locations/" + center.Oa + "/" + center.Pa, __bind(function(data) {
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
    var army_image, city_image, latLng, marker, that;
    if (!data.latitude) {
      console.log("ERROR: marker without lat,lng");
    }
    latLng = new google.maps.LatLng(data.latitude, data.longitude);
    city_image = "http://" + http_host + "/images/map_icons/city_enemy.png";
    army_image = "http://" + http_host + "/images/map_icons/army_ally.png";
    marker = new google.maps.Marker({
      position: latLng,
      map: this.map,
      player: data.player
    });
    window.dtt = data;
    if (data.city !== void 0) {
      marker.name = data.city.name;
      marker.city = data.city;
      marker.army = void 0;
      marker.icon = city_image;
      marker.type = "city";
      data.type = "city";
    } else {
      marker.name = "Army";
      marker.army = data.army;
      marker.city = void 0;
      marker.icon = army_image;
      marker.type = "army";
      data.type = "army";
    }
    this.markers.push(marker);
    that = this;
    return google.maps.event.addListener(marker, 'click', function() {
      that.attachDialog(marker, data);
      if (marker.type === "army") {
        return that.attachArmyActionsMenu(marker);
      }
    });
  };
  Map.prototype.attachArmyActionsMenu = function(marker) {};
  Map.prototype.attachDialog = function(marker, location) {
    var content, dia, dialog, model, _i, _len, _ref;
    _ref = this.dialogs;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      dia = _ref[_i];
      dia.close();
    }
    model = null;
    dialog = marker.type === "army" ? (model = new Army(location), new ArmyDialog({
      model: model
    })) : (model = new City(location), new CityDialog({
      model: model
    }));
    content = dialog.render().el;
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
      localStorage.center_lat = center.Oa;
      localStorage.center_lng = center.Pa;
      this.listen_to_bounds();
      return $(window).trigger("boundszoom_changed");
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
  Map.prototype.overlay = function() {
    var boundaries, overlay;
    boundaries = new google.maps.LatLngBounds(new google.maps.LatLng(43.273978, 10.25124454498291), new google.maps.LatLng(44.273978, 12.25124454498291));
    overlay = new google.maps.GroundOverlay("/images/overlay.png", boundaries);
    return overlay.setMap(this.map);
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
  };
  return Map;
})();
utils = {};
utils.parseCoords = function(string) {
  var split;
  split = string.replace(/\s/, '').split(",");
  return [split[0], split[1]];
};

(function(b){function c(){}for(var d="assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,timeStamp,profile,profileEnd,time,timeEnd,trace,warn".split(","),a;a=d.pop();){b[a]=b[a]||c}})((function(){try
{console.log();return window.console;}catch(err){return window.console={};}})());
;
$(function() {
  var g, map;
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
  map = new Map;
  map.draw();
  map.loadMarkers();
  map.listen();
  map.startFetchingMarkers();
  return map.autoSize();
});