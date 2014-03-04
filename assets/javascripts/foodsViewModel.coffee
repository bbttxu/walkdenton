# foodsViewModel.coffee


define ["knockout", "underscore"], (ko, _)->
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

    self.markers = ko.computed ()->
      foods = self.filtered()
      _.map foods, (food)->
        food.marker()

    self