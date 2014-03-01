# routes.coffee
define [ "sammy" ], (Sammy)->
  routes = Sammy 'body', ()->
    self = this

    showSection = (selector)->
      $('.primary').not(selector).slideUp()
      $(selector).slideDown()

    self.get "#/vision", ()->
      showSection "#vision" 

    self.get "#/food", ()->
      showSection "#food"

    self.get "#/", ()->
      showSection "#map"

    self
