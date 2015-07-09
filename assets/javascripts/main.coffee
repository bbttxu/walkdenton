requirejs.config

  paths:
    jquery: 'vendor/jquery/jquery'

    leaflet: 'vendor/leaflet/leaflet'
    'leaflet.awesome-markers': 'vendor/leaflet.awesome-markers/leaflet.awesome-markers'

    sammy: 'vendor/sammy/sammy'
    lscache: 'vendor/lscache/lscache'

    underscore: 'vendor/underscore/underscore'
    moment: 'vendor/moment/moment'
    # fastclick: 'vendor/fastclick/fastclick'
    spin: 'vendor/spin/spin'
    postal: 'vendor/postaljs/postal'

    react: 'vendor/react/react'

    bootstrap: 'vendor/bootstrap/bootstrap'

  shim:
    'bootstrap':
      deps: [ 'jquery' ]

    'sammy':
      deps: [ 'jquery' ]
      exports: 'Sammy'

    underscore:
      exports: '_'

    leaflet:
      exports: 'L'

    'leaflet.awesome-markers':
      deps: [ 'leaflet' ]


require [ 'app/map' ], ->

require [ 'app/intersections' ], ->

# require [ 'app/global' ], ->

# require [ 'app/assessment' ], ->

