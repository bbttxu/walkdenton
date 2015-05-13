# assessment.coffee

define ["leaflet", "postal", "app/defaults", "jquery", "models/intersection", "data/inter_lite", "templates"], (L, postal, defaults, $, Intersection, data, templates)->
  channel = postal.channel()

  intersections = data
  current = []

  options =
    dragging: false
    touchZoom: false
    scrollWheelZoom: false
    doubleClickZoom: false
    boxZoom: false
    zoomControl: false

  coordinates = [ defaults.location.latitude, defaults.location.longitude ]
  map = L.map('map', options).setView( coordinates, 16 )

  L.tileLayer("http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
    attribution: "Map data &copy; <a href=\"http://openstreetmap.org\">OpenStreetMap</a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"http://cloudmade.com\">CloudMade</a>"
    maxZoom: 18
  ).addTo map


  locateOptions =
    setView: false
    maxZoom: 18
    watch: true
    timeout: 6000
    maximumAge: 6000
    enableHighAccuracy: true

  map.locate locateOptions

  # currentMarkers = {}

  # currentMarkerBounds = ()->
  #   latLngs = for key, markers of currentMarkers
  #     for marker in markers
  #       marker.getLatLng() if marker isnt undefined

  options =
    color: '#00f'

  loc = L.circle( coordinates, 1000, options ).addTo(map)



  onLocationFound = (e) ->
    radius = e.accuracy / 2
    radius = 10 if radius < 10

    loc.setLatLng e.latlng
    loc.setRadius radius
    map.panTo e.latlng


  map.on "locationfound", onLocationFound

  onLocationError = (e) ->
    console.log e.message

  map.on "locationerror", onLocationError
  map.on "move", ()->
    channel.publish "intersections"


  findBounds = (markerArray)->
    L.latLngBounds markerArray.concat smallCircle.getLatLng()


  channel.subscribe "intersections", ()->

    bounds = map.getBounds()
    sw = bounds.getSouthWest()
    ne = bounds.getNorthEast()

    found = _.filter intersections, (intersection)->
      (intersection.y > sw.lat) and (ne.lat > intersection.y) and (intersection.x > sw.lng) and (ne.lng > intersection.x)

    sorted = _.sortBy found, (intersection)->
      map.getCenter().distanceTo new L.LatLng intersection.y, intersection.x

    ten = sorted
    # ten = _.take sorted, 45
    top = _.take sorted, 2

    proximates = _.map top, (proximate)->
      map.getCenter().distanceTo new L.LatLng proximate.y, proximate.x

    if (2 * proximates[0]) > proximates[1]
      console.log "on the fence"

    if (2 * proximates[0]) <= proximates[1]
      top.pop()

      console.log "found"

    foo = proximates.length

    console.log top.length

    color = if (top.length == 1) then 'green' else 'blue'

    markers = _.map top, (one)->
      new Intersection(one).marker(color)

    # others = _.map _.difference(ten, top), (one)->
    #   new Intersection(one).marker('blue')

    # markers = markers.concat others

    _.each _.difference(markers, current), (marker)->
      marker.addTo map

    _.each _.difference(current, markers), (marker)->
      map.removeLayer marker

    current = markers

    # if top.length is 1
    questions = [
      name: 'nRoads'
      question: "Number of Roads?"
      options:
        5: "5"
        4: "4"
        3: "3"
        2: "2"
        1: "1"
    ,
      name: 'nCrosswalks'
      question: "Number of Crosswalks?"
      options:
        5: "5"
        4: "4"
        3: "3"
        2: "2"
        1: "1"
    ,
      name: 'nCrosswalks'
      question: "Number of Crosswalk Signals?"
      options:
        5: "5"
        4: "4"
        3: "3"
        2: "2"
        1: "1"
    ]


    # indicators = _.map questions, (question, index)->
    # console.log questions
    indicators = templates['carousel-indicators'] questions: questions

    items = templates['carousel-items'] questions: questions

    detail = templates['intersection-form'] top[0]

    all = templates['intersection'] items: items, indicators: indicators, detail: detail

    $('#intersectionForm').html all



  channel.publish "intersections", data




