# showDate.coffee

define ["knockout", "underscore", "moment"], (ko, _, moment)->
	showDate = (date)->
		self = this

		self.date = ko.observable date or new Date()
		self.formatedDate = ko.computed ()->
			date = moment self.date()
			date.format('ddd, MMM DD YYYY')

		self.shows = ko.observableArray []

		self.current = ko.computed ()->
			shows = self.shows()
			currently = moment().subtract(1,'h')

			upcoming = _.reject shows, (show)->
				moment(show.startsAt()) < currently

			grouped = _.groupBy upcoming, (num)->
				num.startsAt()

			mapped = _.collect grouped, (value, key)->
				date: key
				shows: value

			mapped


		self.venues = ko.computed ()->
			shows = self.shows()
			show.venue() for show in shows

		self.venueMarkers = ko.computed ()->
			venues = self.venues()
			venue.marker() for venue in venues

		# self.showCount = ko.computed ()->
		# 	shows = self.shows()
		# 	shows.length

		# self.artistCount = ko.computed ()->
		# 	shows = self.shows()
			
		# 	shows.length

		self