# foodViewModel.coffee


define ["knockout", "leaflet"], (ko, L)->
  foodViewModel = (food)->
    self = this
    self.name = ko.observable food.name
    self.tags = ko.observableArray food.tags_array
    self.coordinates = ko.observableArray food.coordinates
    self.marker = ko.computed ()->
      coordinates = self.coordinates()
      latlng = L.latLng( coordinates[1], coordinates[0])
      L.marker(latlng)

    self
