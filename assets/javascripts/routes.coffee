# routes.coffee
define [ 'jquery', "sammy", "moment" ], ($, Sammy, moment)->



  routes = Sammy 'body', ()->

    self = this

    # use(Sammy.GoogleAnalytics)

    # self.use 'JSON'
    # self.use 'Session'
    # self.use 'Storage'
    # self.use 'OAuth2'
    # self.oauthorize = "/oauth/authorize"

    # self.requireOAuth()

    showSection = (selector)->
      $('.primary').not(selector).slideUp('fast')
      $(selector).slideDown('fast')

    # self.get "#/vision", ()->
    #   showSection "#vision"

    self.get "#/food", ()->
      showSection "#food"

    self.get "#/shows/:date", ()->
      date = this.params.date

      $("body").trigger 'dateChange', date

      showSection "#shows"

    self.get "#/shows", ()->
      date = this.params.date

      $("body").trigger 'dateChange', date
      showSection "#shows"

      # $("body").trigger 'dateChange',

      showSection "#shows"

    # self.get "#/", ()->
    #   showSection "#map"

    # self.get /.*/, ()->
    #   self.redirect '#/shows/' + moment().format('YYYY-MM-DD')

    self
