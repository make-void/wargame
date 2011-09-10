class QueueItem extends Backbone.Model




class QueueList extends Backbone.Collection
  city_id: 42768
  model: QueueItem
  url: "/players/me/cities/#{42768}/queues"
  
  
window.Queue = new QueueList()  