# assessment.coffee

define ['react', 'postal'], (React, Postal)->
  channel = Postal.channel()

  render = (data)->
    React.render React.createElement(Intersections, {streets: data}), document.getElementById 'streets'

  channel.subscribe 'intersections:closest', render


  # if top.length is 1
  questions = [
    name: 'nRoads'
    question: 'Number of Roads?'
    options:
      5: '5'
      4: '4'
      3: '3'
      2: '2'
      1: '1'
  ,
    name: 'nCrosswalks'
    question: 'Number of Crosswalks?'
    options:
      5: '5'
      4: '4'
      3: '3'
      2: '2'
      1: '1'
  ,
    name: 'nCrosswalks'
    question: 'Number of Crosswalk Signals?'
    options:
      5: '5'
      4: '4'
      3: '3'
      2: '2'
      1: '1'
  ]

  channel.publish 'intersections:top', data




