
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




require ["jquery", "sammy"], ($, Sammy)->

  app = Sammy 'body', ()->
    self = this

    # self.get "#/venues", ()->
    #   $('.primary').not("#venues").slideUp()
    #   $('#venues').show()

    self.get "#/food", ()->
      $('.primary').not("#food").slideUp()
      $('#food').show()

    self.get "#/", ()->
      $('.primary').not("#map").slideUp()
      $('#map').show()

    self

  app.run "#/food"

require ["jquery", "knockout", "underscore", "leaflet"], ($, ko, _, L)->


  map = L.map('map', {dragging: false}).setView([33.215194, -97.132788], 15)

  tagViewModel = (tag)->
    self = this
    self.name = ko.observable tag
    self

  foodViewModel = (food)->
    self = this
    self.name = ko.observable food.name
    self.tags = ko.observableArray food.tags_array
    self.coordinates = ko.observableArray food.coordinates
    self

  foodsViewModel = (foods)->
    self = this
    self.foods = ko.observable foods
    self.tags = ko.computed ()->

      all_this_food = self.foods()

      tags = {}
      for food in all_this_food

        for tag in food.tags()
          tags[tag] = tags[tag] + 1 || 1

      _.map tags, (value, key)->
        name: key
        number: value

    self.filterTags = ko.observableArray []
    self.filtered = ko.computed ()->
      foods = self.foods()
      tags = self.filterTags()

      return foods if tags.length is 0

      filtered = []

      for food in foods
        for tag in tags
          for foodtag in food.tags()
            if foodtag == tag
              filtered.push food

      _.uniq filtered

    # self.bounds = ko.computed ()->
    #   filtered = self.filtered()


    #   # for food in filtered
    #   #   console.log food.coordinates()


    #   filtered = food for food in filtered
    #   console.log filtered
    #   filtered


    self

  foodsView = new foodsViewModel []

  ko.applyBindings foodsView, $('#food')[0]



  $.getJSON "http://192.241.185.162/foods.json?callback=?", (data, status)->
    foods = for food in data.foods
      new foodViewModel(food)

    foodsView.foods foods

  $(document).ready ()->
    $("ul.tags").on 'click', 'a.toggle', (event)->
      event.preventDefault()
      $(this).toggleClass 'toggled'

      tags = []
      $("ul.tags a.toggled").each (i, m)->
        tags.push $(m).text()

      foodsView.filterTags tags

# require ["leaflet"], ()->


  L.tileLayer("http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
    attribution: "Map data &copy; <a href=\"http://openstreetmap.org\">OpenStreetMap</a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"http://cloudmade.com\">CloudMade</a>"
    maxZoom: 18
  ).addTo map

  map.locate({setView: true, maxZoom: 17})
  map.locate({watch: true, maximumAge: 6000, setView: true})

  options =
    color: '#00f'
  circle = L.circle([0, 0], 100, options ).addTo(map);

  onLocationFound = (e) ->
    radius = e.accuracy / 2
    circle.setLatLng(map.getCenter());
    circle.setRadius radius

  map.on "locationfound", onLocationFound

  onLocationError = (e) ->
    alert e.message
  map.on "locationerror", onLocationError
