describe("Map", ->
  it "initializes the map", ->
    map = new Map()
    expect(map.markers).toBeArray()
    
    
  it "loads the markers", ->
    map = new Map()
    markers = [
      { "latitude": 43.75, "longitude": 11.183333, "id":42891, 
      "player": { "id": 1, "name": "Free Lands", "alliance": {"id": 1,"name": "No Alliance"} 
      }, 
      "city": {"id": 42891, "name": "Scandicci", "pts": 50309, "ccode": "it"} },
      { "latitude": 43.7687324, "longitude": 11.2569013, "id": 45326, 
      "player": {"id": 3,"name": "makevoid", "alliance": {"id": 2,"name": "TheMasterers"} },
      "city": {"id": 45326,"name": "Florence","pts": 65000,"ccode": "it"} }]
    # console.log "markers:", markers
    map.drawMarkers(markers)
    
    for marker in map.markers
      expect(marker.dialog).toBeTruthy()
      expect(marker.model).toBeTruthy()
      expect(marker.player).toBeTruthy()
    
)

# toContain
# toThrow
# toMatch