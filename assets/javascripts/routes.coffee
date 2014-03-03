# routes.coffee
define [ 'jquery', "sammy"], ($, Sammy)->
  routes = Sammy 'body', ()->
    self = this

    # use(Sammy.GoogleAnalytics)

    showSection = (selector)->
      $('.primary').not(selector).slideUp()
      $(selector).slideDown()

    self.get "#/vision", ()->
      showSection "#vision" 

    self.get "#/food", ()->
      showSection "#food"

    self.get "#/shows", ()->
      $('.primary').not("#shows").slideUp()
      $('#shows').show()


    self.get "#/", ()->
      showSection "#map"

    self
