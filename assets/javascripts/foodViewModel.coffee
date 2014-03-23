# foodViewModel.coffee


define ["knockout", "leaflet", 'leaflet.awesome-markers'], (ko, L)->
  foodViewModel = (food)->
    self = this
    self.name = ko.observable food.name
    self.tags = ko.observableArray food.tags_array
    self.coordinates = ko.observableArray food.coordinates
    self.marker = ko.computed ()->
      coordinates = self.coordinates()
      latlng = L.latLng( coordinates[1], coordinates[0])
      iconOptions =
        prefix: 'fa'
        icon: 'cutlery'
        markerColor: 'green'
      icon = L.AwesomeMarkers.icon iconOptions   

      marker = L.marker(latlng, icon: icon)
      marker.bindPopup("<b>"+self.name()+"</b>")

    self
