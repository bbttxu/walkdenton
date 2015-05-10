requirejs.config

  paths:
    jquery: "vendor/jquery/jquery"
    # foundation: 'vendor/foundation/foundation'
    leaflet: "vendor/leaflet/leaflet"
    'leaflet.awesome-markers': "vendor/leaflet.awesome-markers/leaflet.awesome-markers"

    sammy: "vendor/sammy/sammy"
    # 'sammy.json': "vendor/sammy/sammy.json"
    # 'sammy.storage': "vendor/sammy/sammy.storage"
    # 'sammy.oauth2': "vendor/sammy/sammy.oauth2"
    lscache: 'vendor/lscache/lscache'

    # 'sammy-google-analytics': "vendor/sammy/sammy-google-analytics"
    # knockout: "vendor/knockout/knockout"
    underscore: "vendor/underscore/underscore"
    moment: "vendor/moment/moment"
    fastclick: "vendor/fastclick/fastclick"
    spin: "vendor/spin/spin"
    postal: "vendor/postaljs/postal"

    # lscache: "vendor/pamelafox/lscache"
    # annyang: "vendor/talater/annyang"

    bootstrap: "vendor/bootstrap/bootstrap"

  shim:
    # 'foundation':
    #   deps: [ 'jquery' ]
    'bootstrap':
      deps: [ 'jquery' ]
    'sammy':
      deps: [ 'jquery' ]
      exports: "Sammy"
    # 'sammy-google-analytics':
    #   deps: [ 'sammy' ]
    # 'sammy.json':
    #   deps: [ 'sammy' ]
    # 'sammy.storage':
    #   deps: [ 'sammy' ]

    # 'sammy.oauth2':
    #   deps: [ 'sammy' ]
    underscore:
      exports: "_"
    leaflet:
      exports: 'L'
    'leaflet.awesome-markers':
      deps: [ "leaflet" ]




# require ["postal", "app/spinner"], (postal, spinner)->
#   channel = postal.channel()

#   target = document.getElementById "target"
#   spinner.spin(target)

#   channel.subscribe 'animate', (shouldAnimate)->
#     spinner.spin() if shouldAnimate
#     spinner.stop() unless shouldAnimate


# require ["jquery", "postal"], ($, postal)->
#   channel = postal.channel()

#   $(document).ajaxStart ()-> channel.publish "animate", true
#   $(document).ajaxStop ()-> channel.publish "animate", false





require ["bootstrap"], (bootstrap)->
  # it's loaded


# require ["app/foods"], (foods)->
  # console.log foods
  # load it

# require [ "app/maps" ], (maps)->
  # map loaded

require [ "app/assessment" ], (assessment)->
  # map loaded

# require ["app/shows"], (shows)->
#   # load it

# require ["routes", "moment"], (app, moment)->
#   # app.run '#/shows'
#   app.run '#/food'


# require ["jquery", "foundation", "fastclick"], ($) ->
#   $(document).ready ()->
#     $(document).foundation()




# require ["postal"], (postal)->
#   channel = postal.channel()

#   document.getElementById("toggleVerb").onclick = (->
#     i = 0
#     states = [
#       "walk"
#       "bike"
#       "drive"
#     ]
#     icons = [
#       "fa-wheelchair"
#       "fa-plane"
#       "fa-plane"
#     ]
#     distance = [
#       2
#       5
#       10
#     ]

#     ->

#       # Increment the counter, but don't let it exceed the maximum index
#       i = ++i % states.length
#       $verb = $('span.verb')
#       $verb.removeAttr("class")
#       $verb.text states[i]
#       $verb.toggleClass("verb verb-#{states[i]}")

#       $("#toggleVerb i").removeAttr("class")
#       $("#toggleVerb i").toggleClass("fa #{icons[i]}")

#       channel.publish "map:setDistance", distance[i]

#   )()




# require [ "jquery", "viewModels/calendarViewModel", "knockout" ], ($, calendarViewModel, ko)->
#   calendarView = new calendarViewModel()

#   # ko.applyBindings calendarView, $("#showsCalendar")[0]

#   grabCalendar = ()->
#     $.getJSON "http://denton1.krakatoa.io/shows/calendar.json?callback=?", (data, status)->
#       calendarView.calendar data

#   do refresh = ()->
#     grabCalendar()
#     setTimeout refresh, 5 * 60 * 1000

#   # $('#shows ul').on 'click', 'li.calendar',  (asdf)->
#   #   console.log asdf





