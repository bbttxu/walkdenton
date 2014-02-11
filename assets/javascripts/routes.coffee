# routes.coffee
define [ "sammy" ], (Sammy)->
  routes = Sammy 'body', ()->
    self = this

    self.get "#/food", ()->
      $('.primary').not("#food").slideUp()
      $('#food').show()

    self.get "#/", ()->
      $('.primary').not("#map").slideUp()
      $('#map').show()

    self
