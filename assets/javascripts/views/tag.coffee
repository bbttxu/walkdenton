# tagViewModel.coffee


define [ "knockout" ], (ko)->
  tagViewModel = (tag)->
    self = this
    self.name = ko.observable tag
    self
