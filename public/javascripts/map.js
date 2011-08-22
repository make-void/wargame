(function() {
  var LLRange, Map;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Map = (function() {
    function Map() {
      this.dialogs = [];
    }
    Map.prototype.get_center_and_zoom = function() {
      if (localStorage.center_lat && localStorage.center_lng) {
        this.center_lat = parseFloat(localStorage.center_lat);
        this.center_lng = parseFloat(localStorage.center_lng);
      } else {
        this.center_lat = 22;
        this.center_lng = 0;
        localStorage.center_lat = this.center_lat;
        localStorage.center_lng = this.center_lng;
      }
      if (localStorage.zoom) {
        return this.zoom = parseInt(localStorage.zoom);
      } else {
        this.zoom = 2;
        return localStorage.zoom = this.zoom;
      }
    };
    Map.prototype.draw = function() {
      var mapDiv;
      this.get_center_and_zoom();
      mapDiv = document.getElementById('map_canvas');
      if (!this.center_lat) {
        this.center_lat = 0;
      }
      if (!this.center_lng) {
        this.center_lng = 22;
      }
      return this.map = new google.maps.Map(mapDiv, {
        center: new google.maps.LatLng(this.center_lat, this.center_lng),
        zoom: this.zoom,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        disableDefaultUI: true
      });
    };
    Map.prototype.resize = function() {
      var height;
      height = $("body").height() - $("h1").height() - 30;
      return $("#container, #map_canvas").height(height);
    };
    Map.prototype.loadMarkers = function(callback) {
      var center;
      center = this.map.getCenter();
      console.log(center);
      return $.get("/markers/" + center.Oa + "/" + center.Pa, __bind(function(datas) {
        var id, loc, marker, markers, name, _i, _len, _ref;
        datas = eval(datas);
        markers = [];
        console.log(datas.markers.length);
        _ref = datas.markers;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          marker = _ref[_i];
          id = marker._id.$oid;
          loc = marker.loc;
          name = marker.name;
          markers.push({
            id: id,
            loc: loc,
            name: name,
            likes: marker.likes,
            fb_id: marker.fb_id
          });
        }
        this.markers = markers;
        this.timer = new Date();
        return this.callback();
      }, this));
    };
    Map.prototype.drawSimpleMarker = function(lat, lng) {
      var image, latLng, marker;
      latLng = new google.maps.LatLng(lat, lng);
      image = "http://localhost:3000/imgs/cross_blue.png";
      return marker = new google.maps.Marker({
        position: latLng,
        map: this.map,
        icon: image
      });
    };
    Map.prototype.drawMarker = function(data) {
      var image, latLng, marker, that;
      latLng = new google.maps.LatLng(data.loc[0], data.loc[1]);
      image = "http://localhost:3000/imgs/cross_red.png";
      marker = new google.maps.Marker({
        position: latLng,
        map: this.map,
        icon: image
      });
      marker.fb_id = data.fb_id;
      marker.name = data.name;
      marker.likes = data.likes;
      that = this;
      return google.maps.event.addListener(marker, 'click', function() {
        var dia, dialog, _i, _len, _ref;
        _ref = that.dialogs;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          dia = _ref[_i];
          dia.close();
        }
        dialog = new google.maps.InfoWindow({
          content: "<a href='http://www.facebook.com/pages/a/" + this.fb_id + "'>" + this.name + "</a><br>likes: " + this.likes
        });
        dialog.open(this.map, this);
        return that.dialogs.push(dialog);
      });
    };
    Map.prototype.callback = function() {
      var marker, _i, _len, _ref, _results;
      _ref = this.markers;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        marker = _ref[_i];
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
    Map.prototype.listen = function() {
      this.listen_to_bounds();
      return google.maps.event.addListener(this.map, 'zoom_changed', __bind(function() {
        var zoom;
        zoom = this.map.getZoom();
        localStorage.zoom = zoom;
        return $(window).trigger("boundszoom_changed");
      }, this));
    };
    Map.prototype.overlay = function() {
      var boundaries, overlay;
      boundaries = new google.maps.LatLngBounds(new google.maps.LatLng(43.273978, 10.25124454498291), new google.maps.LatLng(44.273978, 12.25124454498291));
      overlay = new google.maps.GroundOverlay("/imgs/overlay.png", boundaries);
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
      var self;
      self = this;
      this.timer = new Date();
      return $(window).bind("boundszoom_changed", function() {
        var time;
        time = new Date() - self.timer;
        if (time > 2000) {
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
  $(function() {
    var map;
    map = new Map;
    map.draw();
    map.loadMarkers();
    map.listen();
    map.drawLines();
    map.startFetchingMarkers();
    map.resize();
    return $(window).resize(function() {
      return map.resize();
    });
  });
}).call(this);
