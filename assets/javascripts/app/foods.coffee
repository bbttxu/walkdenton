# foods.coffee

define ["jquery", "postal", "templates", "models/food", "models/places", "app/api"], ($, postal, templates, Food, Places, api)->
  channel = postal.channel()
  # console.log "foods start"

  places = new Places()

  channel.subscribe "foods:updated", (wut)->

    foods = _.map wut, (food)->
      new Food food.name, food.tags_array, [food.coordinates[0], food.coordinates[1]]

    places.foods = foods

    $('#phoneTagSelect').html templates['tags-select'] places
    $('#tagsList').html templates['tags-list'] places

  updateSelectedPlaces = (tags)->
    places.tagFilter tags[0]
    # console.log places.filterByTag()
    displaySelectedPlaces()

  displaySelectedPlaces = ()->
    $('#places').html templates['places-listing'] places


  cssClass = 'btn-info'

  $(document).ready ()->
    # console.log "foods ready"

    channel.publish "foods:update"

    $('#phoneTagSelect').on 'change', (event)->
      updateSelectedPlaces [ this.value ]

    $("ul.tags").on 'click', 'a.toggle', (event)->
      event.preventDefault()
      event.stopPropagation()

      tagWasToggled = $(this).hasClass(cssClass)
      $("." + cssClass).toggleClass cssClass
      $(this).toggleClass cssClass unless tagWasToggled

      tags = []
      $("ul.tags a." + cssClass).each (i, m)->
        tags.push $('.name', m).text()

      updateSelectedPlaces tags
