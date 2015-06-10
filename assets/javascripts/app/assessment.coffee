# assessment.coffee

define ['react', "components/intersections", "leaflet", "postal", "app/defaults", "jquery", "models/intersection", "data/inter_lite", "templates"], (React, Intersections, L, postal, defaults, $, Intersection, data, templates)->
  channel = postal.channel()

  # intersections = dat
  # console.log top

  React.render React.createElement(Intersections, {streets: top}), document.getElementById 'streets'


  # if top.length is 1
  questions = [
    name: 'nRoads'
    question: "Number of Roads?"
    options:
      5: "5"
      4: "4"
      3: "3"
      2: "2"
      1: "1"
  ,
    name: 'nCrosswalks'
    question: "Number of Crosswalks?"
    options:
      5: "5"
      4: "4"
      3: "3"
      2: "2"
      1: "1"
  ,
    name: 'nCrosswalks'
    question: "Number of Crosswalk Signals?"
    options:
      5: "5"
      4: "4"
      3: "3"
      2: "2"
      1: "1"
  ]


  # indicators = _.map questions, (question, index)->
  # console.log questions
  # indicators = templates['carousel-indicators'] questions: questions

  # items = templates['carousel-items'] questions: questions

  # detail = templates['intersection-form'] top[0]

  # all = templates['intersection'] items: items, indicators: indicators, detail: detail

  # $('#intersectionForm').html all


  channel.publish "intersections", data




