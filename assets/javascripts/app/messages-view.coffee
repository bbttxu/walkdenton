# messages-view.coffee

require ["jquery", "knockout"], ($, ko)->

  url = 'http://localhost:3001/collections/messages?callback=?'

  messages = []


  ko.applyBindings messages: messages


  do updateLocation = ()->
    $.getJSON url, (data, response)->
      messages = data
    setTimeout updateLocation, 6000

