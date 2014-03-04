requirejs.config

  paths:
    jquery: "vendor/jquery/jquery"
    foundation: 'vendor/foundation/foundation'
    leaflet: "vendor/leaflet/leaflet"
    sammy: "vendor/sammy/sammy"
    # 'sammy-google-analytics': "vendor/sammy/sammy-google-analytics"
    knockout: "vendor/knockout/knockout"
    underscore: "vendor/underscore/underscore"
    moment: "vendor/moment/moment"
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

require ["jquery", "spin"], ($, Spinner) ->
  opts =
    lines: 9, # The number of lines to draw
    length: 4, # The length of each line
    width: 2, # The line thickness
    radius: 4, # The radius of the inner circle
    corners: 1, # Corner roundness (0..1)
    rotate: 0, # The rotation offset
    direction: 1, # 1: clockwise, -1: counterclockwise
    color: '#fff', # #rgb or #rrggbb or array of colors
    speed: 1.1, # Rounds per second
    trail: 60, # Afterglow percentage
    shadow: false, # Whether to render a shadow
    hwaccel: false, # Whether to use hardware acceleration
    className: 'spinner', # The CSS class to assign to the spinner
    zIndex: 2e9, # The z-index (defaults to 2000000000)
    top: '10px', # Top position relative to parent in px
    left: '10px' # Left position relative to parent in px
    
  target = document.getElementById "target"  
  spinner = new Spinner(opts).spin(target)

  $(document).ajaxStart ()-> spinner.spin()
  $(document).ajaxStop ()-> spinner.stop()    

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

require [ "jquery", "viewModels/showDate", "viewModels/show", "viewModels/gig", "knockout" ], ($, showDate, showModel, gigModel, ko, moment)->

  showDateView = new showDate "No date selected"
  ko.applyBindings showDateView, $('#showDate')[0]

  grabShowsForDate = (event, date)->
    showDateView.date(date)
    $.getJSON "http://denton1.krakatoa.io/shows/" + date + ".json?callback=?", (data, status)->
      artistByID = (artistID)->
        for artist in data.artists
          return artist.name if artist.id is artistID
        "no artist found"

      gigByID = (id)->
        for gig in data.gigs
          return gig if gig.id is id
        "no gig found"

      venueByID = (id)->
        for venue in data.venues
          return venue.name if venue.id is id
        "no venue found"

      shows = for thisShow in data.shows
        thisShow.venue = venueByID(thisShow.venues)
        thisShow.gigs = for gig in thisShow.gigs
          gig = gigByID gig
          gig.artist = artistByID(gig.artists)
          new gigModel gig

        new showModel thisShow 

      showDateView.shows shows

  $(document).on 'dateChange', 'body', grabShowsForDate














