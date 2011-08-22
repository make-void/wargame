# WarGame 
### the return

### setup:

- install rvm: 
    execute this and follow the istructions:
      bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)

- rvm install 1.9.2
- gem i bundler
- bundle
- rake db:create
- rake db:seed
- rails server

gg!


### notes

locations:

firenze
43.7687324, 11.2569013


- http://code.google.com/apis/ajax/playground/#tile_detector
- code at the end of this file is (http://code.google.com/apis/ajax/playground/#geocoding_extraction) modified


WarGame

[europe]
- test mongodb vs mysql geocoder
- check acqua
- csv citta con population
- resque queues?
- citta' alla ogame non alla travian


-----
var map;
var geocoder;

function initialize() {
 map = new GMap2(document.getElementById("map_canvas"));
 map.setCenter(new GLatLng(34, 0), 1);
 geocoder = new GClientGeocoder();
}

// addAddressToMap() is called when the geocoder returns an
// answer.  It adds a marker to the map with an open info window
// showing the nicely formatted version of the address and the country code.
function addAddressToMap(response) {
 map.clearOverlays();
 if (!response || response.Status.code != 200) {
   alert("Sorry, we were unable to geocode that address");
 } else {
   place = response.Placemark[0];
   point = new GLatLng(place.Point.coordinates[1],
                       place.Point.coordinates[0]);
   marker = new GMarker(point);
   map.addOverlay(marker);
   marker.openInfoWindowHtml(place.address + '<br>' +
     '<b>pt:</b> ' + place.Point.coordinates[1] + ", "+place.Point.coordinates[0]);
 }
}

// showLocation() is called when you click on the Search button
// in the form.  It geocodes the address entered into the form
// and adds a marker to the map at that location.
function showLocation() {
 var address = document.forms[0].q.value;
 geocoder.getLocations(address, addAddressToMap);
}

// findLocation() is used to enter the sample addresses into the form.
function findLocation(address) {
 document.forms[0].q.value = address;
 showLocation();
}​