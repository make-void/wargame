var Alliance, ArmiesList, ArmiesView, Army, ArmyDialog, ArmyOverview, ArmyView, AttackState, AttackType, BubbleEvents, BubbleView, CitiesList, CitiesView, City, CityDialog, CityInfos, CityMarkerIcon, CityOverview, CityView, Debug, DebugDialog, Definition, Definitions, Game, GameState, GameView, GenericDialog, LLRange, Location, Map, MapAction, MapAttack, MapEvents, MapMove, MapView, Marker, MarkerView, MarkersUpdater, MoveState, Player, PlayerView, QueueItem, QueueItemView, QueueList, QueueView, SpinnerView, Struct, StructDef, Structs, StructsDialog, Tech, TechDef, Techs, TechsDialog, Unit, UnitDef, Units, UnitsDialog, Upgrade, Utils, console;
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
PlayerView = Backbone.View.extend({
  el: $("#player"),
  render: function() {
    var content, haml;
    haml = Haml($("#playerView-tmpl").html());
    content = haml(this.model.attributes);
    $(this.el).html(content);
    return this;
  }
});
MapView = (function() {
  __extends(MapView, Backbone.View);
  MapView.prototype.element = 'map_canvas';
  function MapView(map) {
    this.map = map;
    this.controller = null;
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
    mapDiv = document.getElementById(this.element);
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
    return this.map.controller = this.controller;
  };
  MapView.prototype.get_center_and_zoom = function() {
    if (localStorage.center_lat && localStorage.center_lng && localStorage.center_lat !== "NaN" && localStorage.center_lng !== "NaN") {
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
    if (zoom < this.controller.markerZoomMin) {
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
BubbleView = (function() {
  function BubbleView(map, marker) {
    this.map = map;
    this.marker = marker;
    this.marker.bubble_view = this;
  }
  BubbleView.prototype.open = function() {
    console.log(this.marker);
    return this.bubble.open(this.map, this.marker.view.markerIcon);
  };
  BubbleView.prototype.build = function(content) {
    return this.bubble = new InfoBubble({
      content: content,
      shadowStyle: 1,
      padding: 12,
      backgroundColor: "#EEE",
      borderRadius: 10,
      arrowSize: 20,
      borderWidth: 3,
      borderColor: '#666',
      disableAutoPan: false,
      hideCloseButton: true,
      arrowPosition: 30,
      backgroundClassName: 'bubbleBg',
      arrowStyle: 2,
      minWidth: 420,
      maxWidth: 700,
      minHeight: 400,
      maxHeight: 700
    });
  };
  BubbleView.prototype.doRender = function() {
    var content;
    content = this.marker.dialog.render().el;
    this.build(content);
    this.open();
    this.bindEvents();
    return this;
  };
  BubbleView.prototype.bindEvents = function() {
    return $(this.bubble.content).find(".closeButton").bind("click", __bind(function() {
      return this.close();
    }, this));
  };
  BubbleView.prototype.rebind = function() {
    return google.maps.event.addListener(this.marker.view.markerIcon, 'click', __bind(function() {
      return this.open();
    }, this));
  };
  BubbleView.prototype.showSwitchButton = function(marker, fun, scope) {
    return $(this.bubble.content).find(".switchButton").css({
      display: "block"
    }).html("Switch to Army").bind("click", __bind(function() {
      return fun(marker);
    }, this));
  };
  BubbleView.prototype.close = function() {
    this.bubble.close();
    localStorage.last_location_id = null;
    return this.rebind();
  };
  BubbleView.prototype.switchTab = function(tab) {
    return $(".bubble .tabs ." + tab).trigger("click");
  };
  return BubbleView;
})();
MarkerView = (function() {
  function MarkerView(map, location) {
    this.map = map;
    this.location = location;
    this.marker = null;
    this.dialog = null;
  }
  MarkerView.prototype.draw = function() {
    var anchor, army_icon, army_image, icon, latLng, loc, marker, zIndex;
    loc = this.location.attributes;
    if (!loc.latitude) {
      console.log("ERROR: marker without lat,lng");
    }
    latLng = new google.maps.LatLng(loc.latitude, loc.longitude);
    marker = new Marker();
    if (this.location.type === "city") {
      marker.type = "city";
    } else {
      marker.type = "army";
    }
    marker.attributes = this.data;
    marker.view = this;
    marker.model = this.location;
    if (this.location.type === "army") {
      this.dialog = marker.dialog = new ArmyDialog({
        model: this.location
      });
    } else {
      this.dialog = marker.dialog = new CityDialog({
        model: this.location
      });
    }
    this.marker = marker;
    zIndex = this.location.type === "army" ? -1 : -2;
    this.markerIcon = new google.maps.Marker({
      position: latLng,
      map: this.map.map,
      player: loc.player,
      zIndex: zIndex
    });
    if (this.location.type === "city") {
      icon = new CityMarkerIcon(loc.city.pts, "enemy");
      this.markerIcon.icon = icon.draw();
    } else {
      anchor = new google.maps.Point(25, 20);
      army_image = "http://" + window.http_host + "/images/map_icons/army_ally.png";
      army_icon = new google.maps.MarkerImage(army_image, null, null, anchor, null);
      this.markerIcon.icon = army_icon;
    }
    this.marker.unique_id = this.markerIcon.__gm_id;
    return this;
  };
  return MarkerView;
})();
QueueView = (function() {
  __extends(QueueView, Backbone.View);
  function QueueView() {
    QueueView.__super__.constructor.apply(this, arguments);
  }
  QueueView.prototype.initialize = function(opts) {
    this.dialog = opts.dialog;
    window.queueViewDialog = this.dialog;
    Queue.unbind('all');
    Queue.unbind('add');
    Queue.unbind('reset');
    Queue.bind('all', this.render, this);
    Queue.bind('add', this.addOne, this);
    return Queue.bind('reset', this.addAll, this);
  };
  QueueView.prototype.render = function() {
    var content, haml;
    haml = Haml($("#queueView-tmpl").html());
    content = haml({
      errors: []
    });
    $(this.el).html(content);
    return this;
  };
  QueueView.prototype.addOne = function(queueItem) {
    var content, self, view;
    this.dialog = window.queueViewDialog;
    view = new QueueItemView({
      model: queueItem
    });
    content = view.render().el;
    self = this;
    $(this).find(".queueItems").load(function() {});
    setTimeout(function() {
      return self.$(".queueItems").append(content);
    }, 1);
    return this.dialog.renderQueue();
  };
  QueueView.prototype.addAll = function() {
    this.$(".queueItems").html("");
    return Queue.each(this.addOne);
  };
  return QueueView;
})();
QueueItemView = (function() {
  __extends(QueueItemView, Backbone.View);
  function QueueItemView() {
    QueueItemView.__super__.constructor.apply(this, arguments);
  }
  QueueItemView.prototype.tagName = "li";
  QueueItemView.prototype.events = {
    "click .removeButton": "clear"
  };
  QueueItemView.prototype.initialize = function() {
    return this.model.bind('destroy', this.remove, this);
  };
  QueueItemView.prototype.render = function() {
    $(this.el).html(Utils.haml("#queueItemView-tmpl", this.model));
    return this;
  };
  QueueItemView.prototype.clear = function() {
    return this.model.destroy();
  };
  QueueItemView.prototype.remove = function() {
    var attrs, post;
    console.log("removing item from queue");
    Spinner.spin();
    attrs = this.model.attributes;
    console.log(attrs);
    post = {
      _method: 'delete',
      player_id: attrs.player_id,
      structure_id: attrs.structure_id,
      unit_id: attrs.unit_id
    };
    return $.post("/players/me/cities/" + attrs.city_id + "/queues/" + attrs.type, post, __bind(function(data) {
      $(this.el).parent().html("");
      return Spinner.hide();
    }, this));
  };
  return QueueItemView;
})();
MapAction = (function() {
  function MapAction() {
    this.map = window.game.map.map;
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
    return this;
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
      icon = new CityMarkerIcon(marker.city.pts, "selected").draw();
      console.log(marker.icon);
      if (marker.icon.url.match(/_enemy\.png/)) {
        marker.icon = icon;
        return marker.setMap(this.map);
      }
    }, this));
    return addListener(marker, "mouseout", __bind(function(evt) {
      var icon;
      icon = new CityMarkerIcon(marker.city.pts, "enemy").draw();
      if (marker.icon.url.match(/_selected\.png/)) {
        marker.icon = icon;
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
SpinnerView = (function() {
  function SpinnerView() {}
  SpinnerView.prototype.spinner = $("#spinner");
  SpinnerView.prototype.bg = $("#wrap, body");
  SpinnerView.prototype.spin = function() {
    this.spinner.fadeIn();
    return this.bg.animate({
      backgroundColor: "#999999"
    }, 300);
  };
  SpinnerView.prototype.hide = function() {
    this.spinner.fadeOut();
    return this.bg.animate({
      backgroundColor: "#DDDDDD"
    }, 300);
  };
  return SpinnerView;
})();
GameView = (function() {
  __extends(GameView, Backbone.View);
  function GameView() {
    GameView.__super__.constructor.apply(this, arguments);
  }
  GameView.prototype.initialize = function() {};
  return GameView;
})();
CityOverview = (function() {
  __extends(CityOverview, Backbone.View);
  function CityOverview() {
    CityOverview.__super__.constructor.apply(this, arguments);
  }
  CityOverview.prototype.selector = "#cityOverview-tmpl";
  CityOverview.prototype.render = function() {
    var content;
    console.log("over: ", this.model);
    content = Utils.haml(this.selector, this.model);
    $(this.el).html(content);
    return this;
  };
  return CityOverview;
})();
ArmyOverview = (function() {
  __extends(ArmyOverview, Backbone.View);
  function ArmyOverview() {
    ArmyOverview.__super__.constructor.apply(this, arguments);
  }
  ArmyOverview.prototype.initialize = function() {};
  return ArmyOverview;
})();
CityView = (function() {
  __extends(CityView, Backbone.View);
  function CityView() {
    CityView.__super__.constructor.apply(this, arguments);
  }
  CityView.prototype.tagName = "li";
  CityView.prototype.render = function() {
    $(this.el).html(Utils.haml("#cityView-tmpl", this.model));
    return this;
  };
  return CityView;
})();
ArmyView = (function() {
  __extends(ArmyView, Backbone.View);
  function ArmyView() {
    ArmyView.__super__.constructor.apply(this, arguments);
  }
  return ArmyView;
})();
CitiesView = (function() {
  __extends(CitiesView, Backbone.View);
  function CitiesView() {
    CitiesView.__super__.constructor.apply(this, arguments);
  }
  CitiesView.prototype.initialize = function() {
    Cities.bind('all', this.render, this);
    Cities.bind('add', this.addOne, this);
    return Cities.bind('reset', this.addAll, this);
  };
  CitiesView.prototype.render = function() {
    var content, haml;
    haml = Haml($("#citiesView-tmpl").html());
    content = haml({});
    console.log("rel: ", this.el);
    $(this.el).html(content);
    return this;
  };
  CitiesView.prototype.addOne = function(city) {
    var content, view;
    console.log("add city", city);
    view = new CityView({
      model: city
    });
    content = view.render().el;
    this.$(".cities ul").append(content);
    return console.log("cont", this.$(".cities ul"));
  };
  CitiesView.prototype.addAll = function() {
    return Cities.each(this.addOne);
  };
  return CitiesView;
})();
ArmiesView = (function() {
  __extends(ArmiesView, Backbone.View);
  function ArmiesView() {
    ArmiesView.__super__.constructor.apply(this, arguments);
  }
  return ArmiesView;
})();
CityMarkerIcon = (function() {
  function CityMarkerIcon(pts, type) {
    this.pts = pts;
    this.type = type;
  }
  CityMarkerIcon.prototype.draw = function() {
    var anchor, city_image, height, scale, size, width;
    scale = Utils.city_scale(this.pts);
    width = 90 * scale;
    height = 59 * scale;
    anchor = new google.maps.Point(width / 2, height / 2);
    size = new google.maps.Size(width, height);
    city_image = "http://" + window.http_host + "/images/map_icons/city_" + this.type + ".png";
    return new google.maps.MarkerImage(city_image, null, null, anchor, size);
  };
  return CityMarkerIcon;
})();
GenericDialog = Backbone.View.extend({
  afterRender: function() {
    if (this.initializeTabs) {
      return this.initializeTabs();
    }
  },
  getContent: function() {
    return this.render().el;
  },
  render: function() {
    var content, haml;
    this.selector = "#" + this.type + "Dialog-tmpl";
    if (!this.selector) {
      console.log("Error: can't create dialog with null selector");
    }
    if ($(this.selector).length === 0) {
      console.log("Error: can't create dialog with null element");
    }
    haml = Haml($(this.selector).html());
    content = haml(this.model.attributes);
    this.rendered = true;
    $(this.el).html(content);
    return this;
  }
});
CityDialog = GenericDialog.extend({
  element: '#cityDialog-tmpl',
  initialize: function() {
    this.type = "city";
    this.current_tab = null;
    return this.queueView = null;
  },
  label: function() {
    return city.name;
  },
  initializeOverview: function() {
    this.cityOverview = new CityOverview({
      model: this.model
    });
    return this.$(".overview").html(this.cityOverview.render().el);
  },
  renderQueue: function() {
    var content, queue;
    content = this.queueView.render().el;
    queue = $(this.el).find(".queue");
    return queue.html(content);
  },
  initializeQueue: function() {
    this.queueView = new QueueView({
      dialog: this
    });
    return Queue.fetch();
  },
  initializeTabs: function() {
    return BubbleEvents.bind("dialog_content_changed", __bind(function() {
      return this.initTabs();
    }, this));
  },
  initTabs: function() {
    var self;
    self = this;
    return $(this.el).find(".nav li").bind("click", function() {
      var type;
      type = $(this).attr("class");
      return self.initTab(type);
    });
  },
  initTab: function(type) {
    var content, dialog, model, over;
    dialog = (function() {
      switch (type) {
        case "city_structs":
          model = new Structs({
            definitions: game.struct_def.definitions
          });
          return this.current_tab = new StructsDialog({
            model: model
          });
        case "city_units":
          model = new Units({
            definitions: game.unit_def.definitions
          });
          return this.current_tab = new UnitsDialog({
            model: model
          });
        case "city_techs":
          model = new Techs({
            definitions: game.tech_def.definitions
          });
          return this.current_tab = new TechsDialog({
            model: model
          });
        case "city_infos":
          this.current_tab = over = new CityInfos({
            model: this.model
          });
          this.initializeOverview();
          this.initializeQueue();
          return over;
        case "debug":
          return this.current_tab = new DebugDialog({
            model: this.model
          });
      }
    }).call(this);
    if (dialog) {
      content = dialog.render().el;
      this.$(".dialog").html(content);
      return this.$(".dialog").addClass("dialog2");
    }
  }
});
ArmyDialog = GenericDialog.extend({
  initialize: function() {
    return this.type = "army";
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
CityInfos = GenericDialog.extend({
  initialize: function() {
    this.type = "city_infos";
    return GenericDialog.prototype.initialize(this.type);
  }
});
StructsDialog = GenericDialog.extend({
  initialize: function() {
    this.type = "city_structs";
    return GenericDialog.prototype.initialize(this.type);
  },
  events: {
    "click .btn.upgrade": "upgrade"
  },
  upgrade: function() {
    var city_id, type, type_id;
    console.log("upgrading");
    city_id = 42768;
    type = "struct";
    type_id = 1;
    Spinner.spin();
    return $.post("/players/me/cities/" + city_id + "/queues/" + type + "/" + type_id, function(data) {
      console.log(data);
      return Spinner.hide();
    });
  }
});
UnitsDialog = GenericDialog.extend({
  initialize: function() {
    this.type = "city_units";
    return GenericDialog.prototype.initialize(this.type);
  }
});
TechsDialog = GenericDialog.extend({
  initialize: function() {
    this.type = "city_techs";
    return GenericDialog.prototype.initialize(this.type);
  }
});
DebugDialog = GenericDialog.extend({
  initialize: function() {
    this.type = "debug";
    return GenericDialog.prototype.initialize(this.type);
  }
});
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
Number.prototype.format = function() {
  return $.map(_(this.toString().split("")).reverse(), function(d, idx) {
    var p;
    if ((idx % 3) === 0 && idx !== 0) {
      p = ".";
    } else {
      p = "";
    }
    return p + d;
  }).join("").split("").reverse().join("");
};
Array.prototype.first = function() {
  return this[0];
};
Array.prototype.last = function() {
  return this[-1];
};
String.prototype.pluralize = function() {
  return this + "s";
};
String.prototype.singularize = function() {
  if (this[-1] && this[-1].toLowerCase() === "s") {
    return this.slice(0, -1);
  } else {
    return this;
  }
};
String.prototype.capitalize = function() {
  return "" + (this[0].toUpperCase()) + this.slice(1);
};
Utils.geocode = function(city, fn) {
  return $.get("/cities/" + city, function(data) {
    var lat, lng;
    lat = data.location.latitude;
    lng = data.location.longitude;
    console.log("daaa : ", data);
    return fn(lat, lng);
  });
};
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
Utils.haml = function(selector, object) {
  var haml;
  haml = Haml($(selector).html());
  return haml(object.attributes);
};
Utils.clone_object = function(object) {
  console.log("cloning: ", object);
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
MapEvents = (function() {
  __extends(MapEvents, Backbone.Events);
  function MapEvents() {
    MapEvents.__super__.constructor.apply(this, arguments);
  }
  return MapEvents;
})();
BubbleEvents = (function() {
  __extends(BubbleEvents, Backbone.Events);
  function BubbleEvents() {
    BubbleEvents.__super__.constructor.apply(this, arguments);
  }
  return BubbleEvents;
})();
QueueItem = (function() {
  __extends(QueueItem, Backbone.Model);
  function QueueItem() {
    QueueItem.__super__.constructor.apply(this, arguments);
  }
  return QueueItem;
})();
QueueList = (function() {
  __extends(QueueList, Backbone.Collection);
  function QueueList() {
    QueueList.__super__.constructor.apply(this, arguments);
  }
  QueueList.prototype.city_id = 42768;
  QueueList.prototype.model = QueueItem;
  QueueList.prototype.url = "/players/me/cities/" + 42768 + "/queues";
  return QueueList;
})();
window.Queue = new QueueList();
Definitions = (function() {
  function Definitions() {}
  Definitions.prototype.get = function(fn) {
    return $.getJSON("/definitions", function(data) {
      return fn(data);
    });
  };
  return Definitions;
})();
Definition = (function() {
  function Definition(definitions) {
    this.definitions = definitions;
    this.definitions = this.load();
    this.type = null;
  }
  Definition.prototype.load = function() {
    var definition, defs, _i, _len, _ref;
    defs = [];
    _ref = this.definitions[this.type.pluralize()];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      definition = _ref[_i];
      defs.push(definition);
    }
    return defs;
  };
  return Definition;
})();
StructDef = (function() {
  __extends(StructDef, Definition);
  function StructDef(objects) {
    this.type = "struct";
    StructDef.__super__.constructor.call(this, objects);
  }
  return StructDef;
})();
TechDef = (function() {
  __extends(TechDef, Definition);
  function TechDef(objects) {
    this.type = "tech";
    TechDef.__super__.constructor.call(this, objects);
  }
  return TechDef;
})();
UnitDef = (function() {
  __extends(UnitDef, Definition);
  function UnitDef(objects) {
    this.type = "unit";
    UnitDef.__super__.constructor.call(this, objects);
  }
  return UnitDef;
})();
AttackType = (function() {
  function AttackType(type) {
    this.type = type;
  }
  AttackType.prototype.toString = function() {
    switch (this.type) {
      case 0:
        return "normal";
      case 1:
        return "anti-vehicle";
      case 2:
        return "anti-troop";
      default:
        return console.log("Error: Attack type '" + this.type + "' not found!");
    }
  };
  return AttackType;
})();
Location = Backbone.Model.extend({});
Army = Location.extend({
  type: "army"
});
City = Location.extend({
  type: "city"
});
Player = Backbone.Model.extend({});
Upgrade = Backbone.Model.extend({});
Alliance = Backbone.Model.extend({});
CitiesList = (function() {
  __extends(CitiesList, Backbone.Collection);
  function CitiesList() {
    CitiesList.__super__.constructor.apply(this, arguments);
  }
  CitiesList.prototype.model = City;
  CitiesList.prototype.url = "/players/me/cities";
  return CitiesList;
})();
ArmiesList = (function() {
  __extends(ArmiesList, Backbone.Collection);
  function ArmiesList() {
    ArmiesList.__super__.constructor.apply(this, arguments);
  }
  ArmiesList.prototype.model = Army;
  ArmiesList.prototype.url = "/players/me/armies";
  return ArmiesList;
})();
Structs = (function() {
  __extends(Structs, Backbone.Model);
  function Structs() {
    Structs.__super__.constructor.apply(this, arguments);
  }
  return Structs;
})();
Units = Backbone.Model.extend({});
Techs = Backbone.Model.extend({});
Struct = Backbone.Model.extend({});
Unit = Backbone.Model.extend({});
Tech = Backbone.Model.extend({});
Marker = (function() {
  __extends(Marker, Backbone.Model);
  function Marker() {
    Marker.__super__.constructor.apply(this, arguments);
  }
  return Marker;
})();
Map = (function() {
  __extends(Map, Backbone.View);
  function Map() {
    this.markerZoomMin = 8;
    this.max_simultaneous_markers = 600;
    this.current_dialog = null;
    this.last_location_id = null;
    this.locations = [];
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
  Map.prototype.loadMarkers = function() {
    var center;
    if (localStorage.zoom < this.markerZoomMin) {
      return;
    }
    this.markersCleanMax();
    center = this.map.getCenter();
    return $.getJSON("/locations/" + (center.lat()) + "/" + (center.lng()), __bind(function(data) {
      var locations;
      locations = data.locations;
      this.createLocations(locations);
      return MapEvents.trigger("markers_loaded");
    }, this));
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
  Map.prototype.restoreState = function() {
    this.last_location_id = parseInt(localStorage.last_location_id);
    if (this.last_location_id) {
      return MapEvents.bind("markers_loaded", __bind(function() {
        var marker, _i, _len, _ref, _results;
        _ref = this.markers;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          marker = _ref[_i];
          _results.push(marker.model.attributes.id === this.last_location_id ? (this.current_dialog = this.openBubbleView(marker), google.maps.event.clearListeners(marker.view.markerIcon, "click"), MapEvents.unbind("markers_loaded")) : void 0);
        }
        return _results;
      }, this));
    }
  };
  Map.prototype.saveDialogState = function(location) {
    return localStorage.last_location_id = location.attributes.id;
  };
  Map.prototype.initLocation = function(location) {
    var is_army;
    is_army = location.city === void 0;
    if (is_army) {
      return new Army(location);
    } else {
      return new City(location);
    }
  };
  Map.prototype.createLocations = function(locations) {
    var existing, loc, location, _i, _j, _len, _len2, _ref, _results;
    _results = [];
    for (_i = 0, _len = locations.length; _i < _len; _i++) {
      location = locations[_i];
      existing = false;
      _ref = this.locations;
      for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
        loc = _ref[_j];
        if (loc.attributes.id === location.id && loc.type === location.type) {
          existing = true;
        }
      }
      _results.push(!existing ? (location = this.initLocation(location), this.locations.push(location), this.markers.push(this.initMarker(location))) : void 0);
    }
    return _results;
  };
  Map.prototype.initMarker = function(location) {
    var markerIcon, markerView;
    markerView = new MarkerView(this, location);
    markerIcon = markerView.draw().markerIcon;
    markerIcon.setMap(this.map);
    this.initDialog(markerView.marker, location);
    return markerView.marker;
  };
  Map.prototype.initDialog = function(marker, location) {
    var self;
    self = this;
    return google.maps.event.addListener(marker.view.markerIcon, 'click', function() {
      var is_different_from, marker_attrs;
      marker_attrs = marker.model.attributes;
      is_different_from = function(dialog) {
        var dialog_attrs;
        dialog_attrs = dialog.marker.model.attributes;
        return dialog_attrs.id !== marker_attrs.id || dialog_attrs.id === marker_attrs.id && dialog_attrs.type !== marker.type;
      };
      if (!this.current_dialog || is_different_from(this.current_dialog)) {
        this.current_dialog = self.openBubbleView(marker);
        return self.saveDialogState(location);
      }
    });
  };
  Map.prototype.openBubbleView = function(marker) {
    var bubbleView, current_dialog, map, mark, markers, same_location, _i, _len;
    map = this.map;
    current_dialog = this.current_dialog;
    markers = this.markers;
    if (current_dialog) {
      current_dialog.close();
    }
    bubbleView = new BubbleView(map, marker);
    bubbleView.doRender();
    for (_i = 0, _len = markers.length; _i < _len; _i++) {
      mark = markers[_i];
      same_location = function(m1, m2) {
        return m1.location_id === m2.location_id;
      };
      if (!_.isEqual(marker, mark) && same_location(mark, marker)) {
        mark.markers = markers;
        bubbleView.showSwitchButton(mark, this.openBubbleView, this);
      }
    }
    marker.dialog.afterRender();
    if (marker.type === "city") {
      marker.dialog.initTab("city_infos");
    }
    return bubbleView;
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
    this.struct_def;
    this.tech_def;
    this.unit_def;
  }
  Game.prototype.debug = function() {
    var debug;
    debug = new Debug(this);
    return debug.debug();
  };
  Game.prototype.initGameView = function() {
    this.game_view = new GameView();
    return window.Spinner = new SpinnerView();
  };
  Game.prototype.initModels = function() {
    var armies_view, cities_view, definitions, g;
    definitions = new Definitions();
    definitions.get(__bind(function(defs) {
      this.struct_def = new StructDef(defs);
      this.tech_def = new TechDef(defs);
      return this.unit_def = new UnitDef(defs);
    }, this));
    g = window;
    g.Cities = new CitiesList();
    g.Armies = new ArmiesList();
    cities_view = new CitiesView();
    armies_view = new ArmiesView();
    Cities.fetch();
    $($("#nav li")[1]).find("div").show();
    return this;
  };
  Game.prototype.initMap = function() {
    this.map.draw();
    this.map.loadMarkers();
    this.map.markersUpdateStart();
    return this.map.restoreState();
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
    return this.current_playerView.render();
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
  game.initModels();
  game.initGameView();
  game.initMap();
  game.getPlayerView();
  game.initNav();
  return game.debug();
});
Debug = (function() {
  function Debug(game) {
    this.game = game;
    this.map = this.game.map;
  }
  Debug.prototype.debug = function() {};
  Debug.prototype.debugDialog = function() {
    return setTimeout(__bind(function() {
      var marker, _i, _len, _ref;
      console.log("markers: " + this.map.markers.length);
      _ref = this.map.markers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        marker = _ref[_i];
        console.log(marker.type);
        if (marker.type === "city") {
          this.map.openDialog(marker);
          BubbleEvents.bind("dialog_content_changed", function() {
            return marker.bubble_view.switchTab("city_structs");
          });
        }
        return;
      }
    }, this), 1500);
  };
  return Debug;
})();
$("#latLng").bind("submit", function() {
  var coords;
  coords = $(this).find("input").val();
  coords = Utils.parseCoords(coords);
  game.map.center(coords[0], coords[1]);
  return false;
});
$("#findCity").bind("submit", function() {
  var city;
  city = $(this).find("input").val();
  Utils.geocode(city, function(lat, lng) {
    return game.map.center(lat, lng);
  });
  return false;
});