# show.coffee


define ["knockout", "underscore", "moment"], (ko, _, moment)->
	show = (attributes)->
		self = this

		self.price = ko.observable attributes.price

		self.source = ko.observable attributes.source

		self.startsAt = ko.observable attributes.starts_at
		self.startsAtTime = ko.computed ()->
			time = moment self.startsAt()
			time.format "hh:mm A"

		self.venue = ko.observable attributes.venue

		self.id = ko.observable attributes.id

		self.gigs = ko.observableArray attributes.gigs
		self.sortedGigs = ko.computed ()->
			_.sortBy self.gigs(), (gig)->
				gig.position()

		self