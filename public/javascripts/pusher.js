// Enable pusher logging - don't include this in production
Pusher.log = function(message) {
  if (window.console && window.console.log) window.console.log(message);
};

// Flash fallback logging - don't include this in production
WEB_SOCKET_DEBUG = true;


var pusher = new Pusher('f24df420389ffcc1ab0e');
var channel = pusher.subscribe('ldworlds_places');
channel.bind('get', function(data) {
  console.log("got places: "+data)
  
});