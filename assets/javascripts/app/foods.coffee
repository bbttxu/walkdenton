# foods.coffee

define ["jquery", "knockout", "underscore", "postal", "app/defaults", "views/tag", "views/food", "views/foods"], ($, ko, _, postal, defaults, tagViewModel, foodViewModel, foodsViewModel)->

  foodsView = new foodsViewModel []
  ko.applyBindings foodsView, $('#food')[0]

  channel = postal.channel()

  currentLocation =
    distance: 2
    latitude: defaults.latitude
    longitude: defaults.longitude

  currentData = []

  update = (location)->

    _.defaults location, currentLocation

    currentLocation = _.clone location


    $.getJSON "http://www.topdenton.com/foods.json?callback=?", location, (data, status)->

      channel.publish 'foods', data
      currentData = data

      foods = for food in data
        new foodViewModel(food)

      unless _.isEmpty foods
        foodsView.foods foods 
      
      for food in foodsView.markers
        marker.addTo(map)

      $('#phoneTagSelect').prop 'disabled', false

  channel.subscribe "foods:get", (wut)-> 
    channel.publish 'foods', currentData
    
  channel.publish 'foods:get'


  # update currentLocation


  channel.subscribe "map:center", (data)->
    location = {}
    location.latitude = data.lat if data.lat
    location.longitude = data.lng if data.lng
    update location

  channel.subscribe "map:setDistance", (data)->
    location = {}
    location.distance = data if data
    update location


  $(document).ready ()->

    cssClass = 'btn-info'



    $('#phoneTagSelect').on 'change', (event)->
      console.log this.value

      foodsView.filterTags [ this.value ]
      channel.publish "set.setDataset", food: foodsView.markers()

    $("ul.tags").on 'click', 'a', (event)->
      event.preventDefault()


      tagWasToggled = $(this).hasClass(cssClass)
      $("." + cssClass).toggleClass cssClass
      $(this).toggleClass cssClass unless tagWasToggled

      tags = []
      $("ul.tags a." + cssClass).each (i, m)->
        tags.push $('.name', m).text()


      # grab existing markers, for our purposes, previous
      previousMarkers = foodsView.markers()

      # update tags
      foodsView.filterTags tags

      # grab new aka current markers if tags are enabled
      # currentMarkers = []
      # currentMarkers = foodsView.markers() if tags.length isnt 0

      channel.publish "set.setDataset", food: foodsView.markers()
      # $('#map').trigger 'map:setDataset', food: foodsView.markers()
