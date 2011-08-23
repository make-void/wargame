(function() {
  require('map');
  $(function() {
    '// use console.log safely\n(function(b){function c(){}for(var d="assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,timeStamp,profile,profileEnd,time,timeEnd,trace,warn".split(","),a;a=d.pop();){b[a]=b[a]||c}})((function(){try\n{console.log();return window.console;}catch(err){return window.console={};}})());';
    var map;
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
}).call(this);
