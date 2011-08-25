var LLRange, Map, utils;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
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
      disableDefaultUI: true
    });
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
    return $.getJSON("/locations/" + center.Oa + "/" + center.Pa, __bind(function(datas) {
      var marker, markers, _i, _len, _ref;
      markers = [];
      _ref = datas.markers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        marker = _ref[_i];
        markers.push(marker);
      }
      this.timer = new Date();
      return this.callback(markers);
    }, this));
  };
  Map.prototype.drawSimpleMarker = function(lat, lng) {
    var image, latLng, marker;
    latLng = new google.maps.LatLng(lat, lng);
    image = "http://" + http_host + "/images/cross_blue.png";
    return marker = new google.maps.Marker({
      position: latLng,
      map: this.map,
      icon: image
    });
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
    if (data.city.name !== null) {
      marker.name = data.city.name;
      marker.city = data.city;
      marker.army = void 0;
      marker.icon = city_image;
    } else {
      marker.name = "Army";
      marker.army = data.army;
      marker.city = void 0;
      marker.icon = army_image;
    }
    this.markers.push(marker);
    that = this;
    return google.maps.event.addListener(marker, 'click', function() {
      var content_string, dia, dialog, _i, _len, _ref;
      _ref = that.dialogs;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        dia = _ref[_i];
        dia.close();
      }
      content_string = "      <div class='dialog'>        <p class='name'>" + this.name + "</p>        <p>player: " + this.player.name + "</p>               ";
      if (this.city) {
        content_string += "<p>population: y</p>";
      }
      content_string += "</div>";
      dialog = new google.maps.InfoWindow({
        content: content_string
      });
      dialog.open(this.map, this);
      return that.dialogs.push(dialog);
    });
  };
  Map.prototype.drawMarker = function(data) {
    var draw, is_a_city, mark, _i, _len, _ref;
    draw = true;
    _ref = this.markers;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      mark = _ref[_i];
      is_a_city = data.city && mark.city;
      if (is_a_city && mark.city.city_id === data.city.city_id) {
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
    return google.maps.event.addListener(this.map, 'click', function(evt) {
      return console.log(evt.latLng.Oa, evt.latLng.Pa);
    });
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
  Map.prototype.drawLines = function() {
    var lat, lats, lngs, range, self;
    lat = 0;
    lats = [43, 44];
    lngs = [11, 12];
    range = new LLRange(43.7, 11.2, 0.1, 0.01);
    self = this;
    return range.each(function(lat, lng) {
      return self.drawSimpleMarker(lat, lng);
    });
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
  g.Army = Backbone.Model.extend({});
  g.City = Backbone.Model.extend({});
  g.Location = Backbone.Model.extend({});
  g.Player = Backbone.Model.extend({});
  g.ArmyView = Backbone.View.extend({
    initialize: function() {
      return this.template = Haml($("#army_view-tmpl").html());
    },
    render: function() {
      var content;
      content = this.template(this.model.attributes);
      $(this.el).html(content);
      return this;
    }
  });
  g.army = new Army({
    asd: "lol"
  });
  g.armyView = new ArmyView({
    model: g.army
  });
  $("#debug").append(g.armyView.render().el);
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
  map.resize();
  return $(window).resize(function() {
    return map.resize();
  });
});