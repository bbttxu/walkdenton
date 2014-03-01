requirejs.config

  paths:
    jquery: "vendor/jquery/jquery"
    foundation: 'vendor/foundation/foundation'
    leaflet: "vendor/leaflet/leaflet"
    sammy: "vendor/sammy/sammy"
    knockout: "vendor/knockout/knockout"
    underscore: "vendor/underscore/underscore"

  shim:
    'foundation':
      deps: [ 'jquery' ]

    underscore:
      exports: "_"

require ["jquery", "foundation"], ($) ->
  $(document).ready ()->
    $(document).foundation()

require ["routes"], (app)->
  app.run "#/vision"

require ["jquery", "knockout", "underscore", "leaflet", "tagViewModel", "foodViewModel", "foodsViewModel"], ($, ko, _, L, tagViewModel, foodViewModel, foodsViewModel)->
  options =
    dragging: false
    touchZoom: false
    scrollWheelZoom: false
    doubleClickZoom: false
    boxZoom: false
    zoomControl: false
  map = L.map('map', options).setView([33.215194, -97.132788], 14)

  L.tileLayer("http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
    attribution: "Map data &copy; <a href=\"http://openstreetmap.org\">OpenStreetMap</a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"http://cloudmade.com\">CloudMade</a>"
    maxZoom: 18
  ).addTo map

  map.locate({setView: true, maxZoom: 17})
  map.locate({watch: true, maximumAge: 6000, setView: true})

  options =
    color: '#00f'
  circle = L.circle([0, 0], 100, options ).addTo(map);

  currentMarkers = []

  onLocationFound = (e) ->
    radius = e.accuracy / 2
    radius = 100
    circle.setLatLng(map.getCenter());
    circle.setRadius radius

    latLngs = _.map currentMarkers, (marker)->
      marker.getLatLng()

    latLngs.push circle.getLatLng()

    bounds = L.latLngBounds latLngs

    map.fitBounds bounds

  map.on "locationfound", onLocationFound

  onLocationError = (e) ->
    console.log e.message
  map.on "locationerror", onLocationError

  foodsView = new foodsViewModel []
  ko.applyBindings foodsView, $('#food')[0]


  $.getJSON "http://192.241.185.162/foods.json?callback=?", (data, status)->
    foods = for food in data.foods
      new foodViewModel(food)

    foodsView.foods foods

    for food in foodsView.markers
      marker.addTo(map)


  $(document).ready ()->
    $("ul.tags").on 'click', 'a.toggle', (event)->
      event.preventDefault()
      $(this).toggleClass 'toggled'

      tags = []
      $("ul.tags a.toggled").each (i, m)->
        tags.push $(m).text()


      # grab existing markers, for our purposes, previous
      previousMarkers = foodsView.markers()

      # update tags
      foodsView.filterTags tags

      # grab new aka current markers if tags are enabled
      currentMarkers = []
      currentMarkers = foodsView.markers() if tags.length isnt 0

      # remove markers no longer on map
      deleteTheseMarkers = _.difference previousMarkers, currentMarkers
      for marker in deleteTheseMarkers
        map.removeLayer marker

      # add new markers, not already on map
      addTheseMarkers = _.difference currentMarkers, previousMarkers
      if addTheseMarkers.length is 0
        addTheseMarkers = currentMarkers
        circle.setRadius 100

      if addTheseMarkers.length isnt 0
        circle.setRadius 1000

      for marker in addTheseMarkers
        marker.addTo(map)

      latLngs = _.map currentMarkers, (marker)->
        marker.getLatLng()

      latLngs.push circle.getLatLng()


      bounds = L.latLngBounds latLngs

      map.fitBounds bounds

