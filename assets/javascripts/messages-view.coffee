require ["jquery", "knockout"], ($, ko)->

  url = 'http://localhost:3001/collections/messages?callback=?'

  messagesViewModel = (messages)->
    self = this
    self.messages = ko.observableArray(messages)
    self



  viewModel = new messagesViewModel([])
  ko.applyBindings viewModel


  do updateLocation = ()->
    $.getJSON url, (data, response)->
      viewModel.messages data
    setTimeout updateLocation, 6000

