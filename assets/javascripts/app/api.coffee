# api.coffee

define ["lscache", "postal", "jquery", "underscore", "app/defaults"], (cache, postal, $, _, defaults)->
	console.log "api"

	postal = postal.channel()

	currentLocation =
		distance: 2
		latitude: defaults.latitude
		longitude: defaults.longitude

	update = (location = currentLocation)->

		# FIXME add location info to cache key
		mostRecent = _.compact [cache.get "foods-recent", cache.get "foods-current"]

		if mostRecent.length >= 1
			postal.publish "foods:updated", mostRecent[0]

		unless mostRecent.length = 2
			$.getJSON "http://www.topdenton.com/foods.json?callback=?", location, (data, status)->
				payload =
					data: data,
					updatedAt: Date.now()

				postal.publish "foods:updated", payload

				cache.set "foods-current", payload, defaults.cache.current
				cache.set "foods-recent", payload, defaults.cache.recent

	postal.subscribe "foods:update", update
	postal.subscribe "map:update", update