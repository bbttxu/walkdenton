requirejs.config

  paths:
    jquery: "vendor/jquery/jquery"
    foundation: 'vendor/foundation/foundation'
    leaflet: "vendor/leaflet/leaflet"
    'leaflet.awesome-markers': "vendor/leaflet.awesome-markers/leaflet.awesome-markers"
    sammy: "vendor/sammy/sammy"
    # 'sammy-google-analytics': "vendor/sammy/sammy-google-analytics"
    knockout: "vendor/knockout/knockout"
    underscore: "vendor/underscore/underscore"
    moment: "vendor/moment/moment"
    fastclick: "vendor/fastclick/fastclick"
    spin: "vendor/spin/spin"

  shim:
    'foundation':
      deps: [ 'jquery' ]
    'sammy':
      deps: [ 'jquery' ]
      exports: "Sammy"
    # 'sammy-google-analytics':
    #   deps: [ 'sammy' ]
    underscore:
      exports: "_"
    leaflet:
      exports: 'L'
    'leaflet.awesome-markers':
      deps: [ "leaflet" ]

require ["jquery", "app/spinner"], ($, spinner)->
  target = document.getElementById "target"  
  spinner.spin(target)

  # count = 0


  # increment = (value = 0)->
  #   count = count + value
  #   spinner.spin() if count > 0
  #   spinner.stop() if count <= 0

  $(document).ajaxStart ()-> spinner.spin()
  $(document).ajaxStop ()-> spinner.stop()

  # $(document).on "spinner:start" ()-> increment(1)
  # $(document).on "spinner:stop" ()-> sincrement(-1)

require ["jquery", "fastclick", "foundation"], ($) ->
  $(document).ready ()->
    $(document).foundation()

require ["leaflet"], (L)->
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
    color: '#00f'
    
  circle = L.circle([33.215194, -97.132788], 100, options ).addTo(map);

  currentMarkers = {}

  currentMarkerBounds = ()->
    latLngs = for key, markers of currentMarkers
      for marker in markers
        marker.getLatLng() if marker isnt undefined
    # bounds = L.latLngBounds latLngs





  $(document).trigger "spinner:start"
  onLocationFound = (e) ->
    $(document).trigger "spinner:stop"
    console.log e
    console.log 'onLocationFound'
    radius = e.accuracy / 2
    radius = 1000

    console.log e
    circle.setLatLng e.latlng
    circle.setRadius radius

    # latLngs = _.map currentMarkers, (marker)->
    #   marker.getLatLng()

    # latLngs.push circle.getLatLng()

    # bounds = L.latLngBounds latLngs
    bounds = currentMarkerBounds()
    bounds.push e.latlng

    map.fitBounds L.latLngBounds bounds

  map.on "locationfound", onLocationFound
  $(document).on 'locationFound', onLocationFound

  onLocationError = (e) ->
    console.log e.message

  map.on "locationerror", onLocationError

  setMarkers = (event, data)->
    console.log 'setMarkers'

    latLngs = []

    # simply remove existing markers from map
    for key, markers of currentMarkers
      for marker in markers
        map.removeLayer marker

    currentMarkers = data


    # simply add new markers
    for key, markers of currentMarkers
      for marker in markers
        latLngs.push marker.getLatLng()
        marker.addTo map

    # for marker in data
    #   console.log marker
    #   marker.addTo map


    # for key, markers of currentMarkers



    #   for marker in markers
    #     addTheseMarkers.push marker
    #     latLngs.push marker.getLatLng()



    # remove markers no longer on map
    # deleteTheseMarkers = _.difference currentMarkers, data
    # console.log deleteTheseMarkers

    # for marker in deleteTheseMarkers
    #   map.removeLayer marker

    # add new markers, not already on map
    # addTheseMarkers = _.difference data, currentMarkers
    # console.log addTheseMarkers

    if latLngs.length is 0
      addTheseMarkers = currentMarkers
      circle.setRadius 100

    if latLngs.length isnt 0
      circle.setRadius 1000

    # for marker in addTheseMarkers
    #   marker.addTo(map)

    # latLngs = _.map currentMarkers, (marker)->
    #   marker.getLatLng()

    latLngs.push circle.getLatLng()


    bounds = currentMarkerBounds()
    bounds.push circle.getLatLng()
    # console.log bounds
    # bounds.push circle.getLatLng()

    map.fitBounds L.latLngBounds bounds
    # onLocationFound accuracy: 2000
    # $(document).trigger 'locationFound'

  $(document).on 'map:setDataset', 'body', setMarkers

require ["jquery", "knockout", "underscore", "tagViewModel", "foodViewModel", "foodsViewModel"], ($, ko, _, tagViewModel, foodViewModel, foodsViewModel)->

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
      # currentMarkers = []
      # currentMarkers = foodsView.markers() if tags.length isnt 0
      $('#map').trigger 'map:setDataset', food: foodsView.markers()


require [ "jquery", "viewModels/calendarViewModel", "knockout" ], ($, calendarViewModel, ko)->
  calendarView = new calendarViewModel()

  ko.applyBindings calendarView, $("#showsCalendar")[0]

  grabCalendar = ()->
    $.getJSON "http://denton1.krakatoa.io/shows/calendar.json?callback=?", (data, status)->
      calendarView.calendar data

  do refresh = ()->
    grabCalendar()
    setTimeout refresh, 5 * 60 * 1000

  # $('#shows ul').on 'click', 'li.calendar',  (asdf)->
  #   console.log asdf

require [ "jquery", "viewModels/showDate", "viewModels/show", "viewModels/gig", "viewModels/venue", "knockout" ], ($, showDate, showModel, gigModel, venueModel, ko)->

  showDateView = new showDate 
  ko.applyBindings showDateView, $('#showDate')[0]

  grabShowsForDate = (event, date)->
    console.log 'grabShowsForDates'
    showDateView.date(date)
    showDateView.shows []

    $.getJSON "http://denton1.krakatoa.io/shows/" + date + ".json?callback=?", (data, status)->
      console.log 'grabShowsForDates callback'
      artistByID = (artistID)->
        for artist in data.artists
          return artist.name if artist.id is artistID
        "no artist found"

      gigByID = (id)->
        for gig in data.gigs
          return gig if gig.id is id
        "no gig found"

      venueViewByID = (id)->
        for venue in data.venues
          return new venueModel venue if venue.id is id
        "no venue found"

      shows = for thisShow in data.shows
        thisShow.gigs = for gig in thisShow.gigs
          gig = gigByID gig
          gig.artist = artistByID(gig.artists)
          new gigModel gig

        showView = new showModel thisShow 

        showView.venue( venueViewByID( thisShow.venues ) )

        showView

      showDateView.shows shows

      $('#map').trigger 'map:setDataset', venues: showDateView.venueMarkers()

  $(document).on('dateChange', 'body', grabShowsForDate).trigger('dateChange', new Date())




require ["routes", "moment"], (app, moment)->
  app.run '#/shows/' + moment().format('YYYY-MM-DD')









