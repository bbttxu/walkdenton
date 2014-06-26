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

      counted = _.map tags, (value, key)->
        name: key
        number: value

      _.sortBy counted, (data)-> -data.number

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

    self.showNearby = ko.computed ()->
      self.filtered().length > 0

    self.nearby = ko.computed ()->
      tags = self.filterTags()
      foods = self.filtered()
      number = foods.length
      tagged = tags.join(', ') || 'nearby'
      return "There is #{number} place tagged '#{tagged}'" if number is 1
      return "There are #{number} places tagged '#{tagged}'" if number > 1
      "No results :/"

    self
