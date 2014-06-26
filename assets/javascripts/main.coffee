requirejs.config

  paths:
    jquery: "vendor/jquery/jquery"
    # foundation: 'vendor/foundation/foundation'
    leaflet: "vendor/leaflet/leaflet"
    'leaflet.awesome-markers': "vendor/leaflet.awesome-markers/leaflet.awesome-markers"

    sammy: "vendor/sammy/sammy"
    # 'sammy.json': "vendor/sammy/sammy.json"
    # 'sammy.storage': "vendor/sammy/sammy.storage"
    # 'sammy.oauth2': "vendor/sammy/sammy.oauth2"

    # 'sammy-google-analytics': "vendor/sammy/sammy-google-analytics"
    knockout: "vendor/knockout/knockout"
    underscore: "vendor/underscore/underscore"
    moment: "vendor/moment/moment"
    fastclick: "vendor/fastclick/fastclick"
    spin: "vendor/spin/spin"
    postal: "vendor/postaljs/postal"

    # lscache: "vendor/pamelafox/lscache"
    # annyang: "vendor/talater/annyang"

    bootstrap: "vendor/bootstrap/bootstrap"

  shim:
    # 'foundation':
    #   deps: [ 'jquery' ]
    'bootstrap':
      deps: [ 'jquery' ]
    'sammy':
      deps: [ 'jquery' ]
      exports: "Sammy"
    # 'sammy-google-analytics':
    #   deps: [ 'sammy' ]
    # 'sammy.json':
    #   deps: [ 'sammy' ]
    # 'sammy.storage':
    #   deps: [ 'sammy' ]

    # 'sammy.oauth2':
    #   deps: [ 'sammy' ]
    underscore:
      exports: "_"
    leaflet:
      exports: 'L'
    'leaflet.awesome-markers':
      deps: [ "leaflet" ]




require ["postal", "app/spinner"], (postal, spinner)->
  channel = postal.channel()

  target = document.getElementById "target"  
  spinner.spin(target)

  channel.subscribe 'animate', (shouldAnimate)->    
    spinner.spin() if shouldAnimate
    spinner.stop() unless shouldAnimate

# require ["jquery", "foundation"], ($, foundation)->
#   $(document).ready ()->
#     $(document).foundation()


require ["jquery", "postal"], ($, postal)->
  channel = postal.channel()

  $(document).ajaxStart ()-> channel.publish "animate", true
  $(document).ajaxStop ()-> channel.publish "animate", false



# require ["jquery", "foundation", "fastclick"], ($) ->
#   $(document).ready ()->
#     $(document).foundation()


require ["leaflet", "postal"], (L, postal)->
  channel = postal.channel()

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

  bigCircle = L.circle([33.215194, -97.132788], 2000, options ).addTo(map);

  options =
    color: '#00f'
    
  circle = L.circle([33.215194, -97.132788], 1000, options ).addTo(map);

  options =
    color: '#f00'

  smallCircle = L.circle([33.215194, -97.132788], 100, options ).addTo(map);


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


# require ["postal"], (postal)->
#   channel = postal.channel()

#   document.getElementById("toggleVerb").onclick = (->
#     i = 0
#     states = [
#       "walk"
#       "bike"
#       "drive"
#     ]
#     icons = [
#       "fa-wheelchair"
#       "fa-plane"
#       "fa-plane"
#     ]
#     distance = [
#       2
#       5
#       10
#     ]

#     ->
      
#       # Increment the counter, but don't let it exceed the maximum index
#       i = ++i % states.length
#       $verb = $('span.verb')
#       $verb.removeAttr("class")
#       $verb.text states[i]
#       $verb.toggleClass("verb verb-#{states[i]}")

#       $("#toggleVerb i").removeAttr("class")
#       $("#toggleVerb i").toggleClass("fa #{icons[i]}")

#       channel.publish "map:setDistance", distance[i]

#   )()




# require [ "jquery", "viewModels/calendarViewModel", "knockout" ], ($, calendarViewModel, ko)->
#   calendarView = new calendarViewModel()

#   # ko.applyBindings calendarView, $("#showsCalendar")[0]

#   grabCalendar = ()->
#     $.getJSON "http://denton1.krakatoa.io/shows/calendar.json?callback=?", (data, status)->
#       calendarView.calendar data

#   do refresh = ()->
#     grabCalendar()
#     setTimeout refresh, 5 * 60 * 1000

#   # $('#shows ul').on 'click', 'li.calendar',  (asdf)->
#   #   console.log asdf

# require [ "postal", "jquery", "viewModels/showDate", "viewModels/show", "viewModels/gig", "viewModels/venue", "knockout" ], (postal, $, showDate, showModel, gigModel, venueModel, ko)->
#   channel = postal.channel()


#   showDateView = new showDate 
#   ko.applyBindings showDateView, $('#showDate')[0]

#   grabShowsForDate = (event, date)->
#     # console.log 'grabShowsForDates'
#     showDateView.date(date)
#     showDateView.shows []

#     $.getJSON "http://denton1.krakatoa.io/shows/" + date + ".json?callback=?", (data, status)->
#       # console.log 'grabShowsForDates callback'
#       artistByID = (artistID)->
#         for artist in data.artists
#           return artist.name if artist.id is artistID
#         "no artist found"

#       gigByID = (id)->
#         for gig in data.gigs
#           return gig if gig.id is id
#         "no gig found"

#       venueViewByID = (id)->
#         for venue in data.venues
#           return new venueModel venue if venue.id is id
#         "no venue found"

#       shows = for thisShow in data.shows
#         thisShow.gigs = for gig in thisShow.gigs
#           gig = gigByID gig
#           gig.artist = artistByID(gig.artists)
#           new gigModel gig

#         showView = new showModel thisShow 

#         showView.venue( venueViewByID( thisShow.venues ) )

#         showView

#       showDateView.shows shows

#       # console.log showDateView.venueMarkers()

#       # $('#map').trigger 'map:setDataset', venues: showDateView.venueMarkers()

#       channel.publish 'set.setDataset', venues: showDateView.venueMarkers()


#   $(document).on('dateChange', 'body', grabShowsForDate).trigger('dateChange', new Date())


require ["bootstrap"], (bootstrap)->
  # it's loaded

require ["app/foods"], (foods)->
  # load it

require ["routes", "moment"], (app, moment)->
  # app.run '#/shows'
  app.run '#/food'





