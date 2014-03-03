# showDate.coffee

define ["knockout", "underscore", "moment"], (ko, _, moment)->
	showDate = (date)->
		self = this

		self.date = ko.observable date
		self.formatedDate = ko.computed ()->
			date = moment self.date()
			date.format('ddd, MMM DD YYYY')

		self.shows = ko.observableArray []

		self