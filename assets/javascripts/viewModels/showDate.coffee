# showDate.coffee

define ["knockout", "underscore", "moment"], (ko, _, moment)->
	showDate = (date)->
		self = this

		self.date = ko.observable date or new Date()
		self.formatedDate = ko.computed ()->
			date = moment self.date()
			date.format('ddd, MMM DD YYYY')

		self.shows = ko.observableArray []

		# self.showCount = ko.computed ()->
		# 	shows = self.shows()
		# 	shows.length

		# self.artistCount = ko.computed ()->
		# 	shows = self.shows()
			
		# 	shows.length

		self