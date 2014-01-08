
requirejs.config

  paths:
    jquery: "vendor/jquery/jquery"
    foundation: 'vendor/foundation/foundation'
    leaflet: "vendor/leaflet/leaflet"

  shim:
    'foundation':
      deps: [ 'jquery' ]


require ["jquery", "foundation"], ($) ->
  $(document).ready ()->
    $(document).foundation()

require ["jquery", "leaflet"], ()->
  $(document).ready ()->
    map = L.map('map', {dragging: false}).setView([33.215194, -97.132788], 15)

    L.tileLayer("http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
      attribution: "Map data &copy; <a href=\"http://openstreetmap.org\">OpenStreetMap</a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"http://cloudmade.com\">CloudMade</a>"
      maxZoom: 18
    ).addTo map

    map.locate({setView: true, maxZoom: 17})
    map.locate({watch: true, maximumAge: 6000, setView: true})

    circle = L.circle([0, 0], 100 ).addTo(map);

    onLocationFound = (e) ->
      radius = e.accuracy / 2
      circle.setLatLng(map.getCenter());

    map.on "locationfound", onLocationFound

    onLocationError = (e) ->
      alert e.message
    map.on "locationerror", onLocationError
