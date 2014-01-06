
requirejs.config

  paths:
    jquery: "vendor/jquery/jquery"
    foundation: 'vendor/foundation/foundation'
    leaflet: "vendor/leaflet/leaflet"

  shim:
    'foundation':
      deps: ['jquery']


require ["jquery", "foundation"], ($) ->
  $(document).foundation()

require ["jquery", "leaflet"], ()->
  map = L.map('map').setView([33.20, -97.12], 15)
  # console.log map


  L.tileLayer("http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
    attribution: "Map data &copy; <a href=\"http://openstreetmap.org\">OpenStreetMap</a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"http://cloudmade.com\">CloudMade</a>"
    maxZoom: 18
  ).addTo map

  map.locate({setView: true, maxZoom: 15})

  onLocationFound = (e) ->
    radius = e.accuracy / 2
    L.marker(e.latlng).addTo(map).bindPopup("You are within " + radius + " meters from this point").openPopup()
    L.circle(e.latlng, radius).addTo map
  map.on "locationfound", onLocationFound

  onLocationError = (e) ->
    alert e.message
  map.on "locationerror", onLocationError