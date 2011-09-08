(function() {
  describe("Map", function() {
    it("initializes the map", function() {
      var map;
      map = new Map();
      return expect(map.markers).toBeArray();
    });
    it("loads the markers", function() {
      var map, marker, markers, _i, _len, _ref, _results;
      map = new Map();
      markers = [
        {
          "latitude": 43.75,
          "longitude": 11.183333,
          "id": 42891,
          "player": {
            "id": 1,
            "name": "Free Lands",
            "alliance": {
              "id": 1,
              "name": "No Alliance"
            }
          },
          "city": {
            "id": 42891,
            "name": "Scandicci",
            "pts": 50309,
            "ccode": "it"
          }
        }, {
          "latitude": 43.7687324,
          "longitude": 11.2569013,
          "id": 45326,
          "player": {
            "id": 3,
            "name": "makevoid",
            "alliance": {
              "id": 2,
              "name": "TheMasterers"
            }
          },
          "city": {
            "id": 45326,
            "name": "Florence",
            "pts": 65000,
            "ccode": "it"
          }
        }
      ];
      map.drawMarkers(markers);
      _ref = map.markers;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        marker = _ref[_i];
        expect(marker.model).toBeTruthy();
        _results.push(expect(marker.player).toBeTruthy());
      }
      return _results;
    });
    return it("attaches a dialog", function() {
      var map, marker, markers, _i, _len, _ref, _results;
      map = new Map();
      markers = [
        {
          "latitude": 43.75,
          "longitude": 11.183333,
          "id": 42891,
          "player": {
            "id": 1,
            "name": "Free Lands",
            "alliance": {
              "id": 1,
              "name": "No Alliance"
            }
          },
          "city": {
            "id": 42891,
            "name": "Scandicci",
            "pts": 50309,
            "ccode": "it"
          }
        }, {
          "latitude": 43.7687324,
          "longitude": 11.2569013,
          "id": 45326,
          "player": {
            "id": 3,
            "name": "makevoid",
            "alliance": {
              "id": 2,
              "name": "TheMasterers"
            }
          },
          "city": {
            "id": 45326,
            "name": "Florence",
            "pts": 65000,
            "ccode": "it"
          }
        }
      ];
      map.drawMarkers(markers);
      _ref = map.markers;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        marker = _ref[_i];
        expect(marker.model).toBeTruthy();
        _results.push(expect(marker.player).toBeTruthy());
      }
      return _results;
    });
  });
}).call(this);
