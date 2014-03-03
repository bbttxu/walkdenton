# gig.coffee

define ["knockout", "underscore", "moment"], (ko, _, moment)->
	gig = (attributes)->
		self = this

		self.artist = ko.observable attributes.artist

		self.position = ko.observable attributes.position

		self