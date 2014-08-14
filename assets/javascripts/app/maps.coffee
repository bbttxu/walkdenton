# maps.coffee

define ["leaflet", "postal", "app/defaults"], (L, postal, defaults)->
  channel = postal.channel()

  options =
    dragging: false
    touchZoom: false
    scrollWheelZoom: false
    doubleClickZoom: false
    boxZoom: false
    zoomControl: false

  coordinates = [ defaults.location.latitude, defaults.location.longitude ]
  map = L.map('map', options).setView( coordinates, 14 )

  L.tileLayer("http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
    attribution: "Map data &copy; <a href=\"http://openstreetmap.org\">OpenStreetMap</a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"http://cloudmade.com\">CloudMade</a>"
    maxZoom: 18
  ).addTo map


  locateOptions =
    setView: false
    maxZoom: 17
    watch: true
    timeout: 6000
    maximumAge: 6000
    enableHighAccuracy: true

  map.locate locateOptions

  options =
    color: '#9f9'

  bigCircle = L.circle( coordinates, 2000, options ).addTo(map);

  options =
    color: '#00f'

  circle = L.circle( coordinates, 1000, options ).addTo(map);

  options =
    color: '#f00'

  smallCircle = L.circle( coordinates, 100, options ).addTo(map);


  currentMarkers = {}

  currentMarkerBounds = ()->
    latLngs = for key, markers of currentMarkers
      for marker in markers
        marker.getLatLng() if marker isnt undefined
    # bounds = L.latLngBounds latLngs

  onLocationFound = (e) ->

    radius = e.accuracy / 2
    radius = 1000

    circle.setLatLng e.latlng
    circle.setRadius radius

    bigCircle.setLatLng e.latlng

    smallCircle.setLatLng e.latlng

    bounds = currentMarkerBounds()
    bounds.push e.latlng

    map.fitBounds L.latLngBounds bounds

    channel.publish "map:center", e.latlng

  map.on "locationfound", onLocationFound

  onLocationError = (e) ->
    console.log e.message

  map.on "locationerror", onLocationError

  clearMarkers = (data)->
    currentMarkers = {}

  setMarkers = (data)->
    possiblyRemove = _.difference _.keys(currentMarkers), _.keys(data)
    possiblyUpdate = _.difference _.keys(data), _.keys(currentMarkers)

    latLngs = []

    # simply add new markers
    for key in _.keys data

      current = currentMarkers[key]
      updated = data[key]

      for marker in _.difference(current, updated)
        map.removeLayer marker

      for marker in _.difference(updated, current)
        marker.addTo map

    currentMarkers = data

    circle.setRadius 1000

    latLngs.push circle.getLatLng()


    bounds = currentMarkerBounds()
    bounds.push circle.getLatLng()

    map.fitBounds L.latLngBounds bounds

  channel.subscribe "clear", clearMarkers
  channel.subscribe "set.setDataset", setMarkers
