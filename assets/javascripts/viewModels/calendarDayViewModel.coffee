# calendarDayViewModel.coffee

define ["knockout", "moment"], (ko, moment)->
	calendarDayViewModel = (date = false, count)->
		self = this

		offset = -10

		self.date = ko.observable date or new Date()

		self.count = ko.observable count
		self.countClass = ko.computed ()->
			"count" + self.count()

		self.weekday = ko.computed ()->
			date = self.date()
			moment(date).format 'ddd' 

		self.showWeekday = ko.computed ()->
			date = moment self.date()
			moment().diff(date, 'days') > offset

		self.day = ko.computed ()->
			date = self.date()
			moment(date).format 'DD'

		self.month = ko.computed ()->
			date = self.date()
			moment(date).format 'MMM'

		self.showMonth = ko.computed ()->
			date = moment self.date()
			moment().diff(date, 'days') <= offset
			true

		self.link = ko.computed ()->
			'#/shows/' + self.date()

		self
