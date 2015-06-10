requirejs.config

  paths:
    jquery: 'vendor/jquery/jquery'
    # foundation: 'vendor/foundation/foundation'
    leaflet: 'vendor/leaflet/leaflet'
    'leaflet.awesome-markers': 'vendor/leaflet.awesome-markers/leaflet.awesome-markers'

    sammy: 'vendor/sammy/sammy'
    # 'sammy.json': 'vendor/sammy/sammy.json'
    # 'sammy.storage': 'vendor/sammy/sammy.storage'
    # 'sammy.oauth2': 'vendor/sammy/sammy.oauth2'
    lscache: 'vendor/lscache/lscache'

    # 'sammy-google-analytics': 'vendor/sammy/sammy-google-analytics'
    # knockout: 'vendor/knockout/knockout'
    underscore: 'vendor/underscore/underscore'
    moment: 'vendor/moment/moment'
    fastclick: 'vendor/fastclick/fastclick'
    spin: 'vendor/spin/spin'
    postal: 'vendor/postaljs/postal'

    # lscache: 'vendor/pamelafox/lscache'
    # annyang: 'vendor/talater/annyang'

    react: 'vendor/react/react'

    bootstrap: 'vendor/bootstrap/bootstrap'

  shim:
    # 'foundation':
    #   deps: [ 'jquery' ]
    'bootstrap':
      deps: [ 'jquery' ]
    'sammy':
      deps: [ 'jquery' ]
      exports: 'Sammy'
    # 'sammy-google-analytics':
    #   deps: [ 'sammy' ]
    # 'sammy.json':
    #   deps: [ 'sammy' ]
    # 'sammy.storage':
    #   deps: [ 'sammy' ]

    # 'sammy.oauth2':
    #   deps: [ 'sammy' ]
    underscore:
      exports: '_'
    leaflet:
      exports: 'L'
    'leaflet.awesome-markers':
      deps: [ 'leaflet' ]



require [ 'bootstrap' ], ->

require [ 'app/map' ], ->

require [ 'app/intersections' ], ->

# require [ 'app/assessment' ], ->

