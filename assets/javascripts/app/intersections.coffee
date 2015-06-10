# streets.coffee

define ['react', 'components/intersections', 'postal'], (React, Intersections, Postal)->
  channel = Postal.channel()

  render = (data)->
    React.render React.createElement(Intersections, {streets: data}), document.getElementById 'streets'

  channel.subscribe 'intersections:closest', render

