# routes.coffee
define [ 'jquery', "sammy"], ($, Sammy)->
  routes = Sammy 'body', ()->
    self = this

    # use(Sammy.GoogleAnalytics)

    showSection = (selector)->
      $('.primary').not(selector).slideUp('fast')
      $(selector).slideDown('fast')

    self.get "#/vision", ()->
      showSection "#vision" 

    self.get "#/food", ()->
      showSection "#food"

    self.get "#/shows/:date", ()->
      date = this.params.date

      $("body").trigger 'dateChange', date

      showSection "#shows"

    self.get "#/shows", ()->
      showSection "#shows"

      # $("body").trigger 'dateChange',

      showSection "#shows"

    self.get "#/", ()->
      showSection "#map"

    self
