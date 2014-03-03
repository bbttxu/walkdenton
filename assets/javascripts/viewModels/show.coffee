# show.coffee


define ["knockout", "underscore", "moment"], (ko, _, moment)->
	show = (attributes)->
		self = this

		self.price = ko.observable attributes.price
		self.source = ko.observable attributes.source
		self.starts_at = ko.observable attributes.starts_at
		self.venue = ko.observable attributes.venue
		self.id = ko.observable attributes.id
		self.gig = ko.observableArray []

		self