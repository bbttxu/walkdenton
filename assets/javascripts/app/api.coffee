# api.coffee

define ["lscache", "postal", "jquery", "underscore", "app/defaults"], (cache, postal, $, _, defaults)->

	postal = postal.channel()


	update = (location)->
		location = _.extend defaults.location, location

		cacheKey = ["foods", location.latitude.toFixed(3), location.longitude.toFixed(3)].join("-")

		cached = cache.get cacheKey

		if cached
			postal.publish "foods:updated", cached

		unless cached
			$.getJSON "http://www.topdenton.com/foods.json?callback=?", location, (data, status)->
				payload =
					data: data,
					updatedAt: Date.now()

				postal.publish "foods:updated", payload

				cache.set cacheKey, payload, defaults.cache.current

	postal.subscribe "foods:update", update

	postal.subscribe "map:center", (data)->
		location =
			latitude: data.lat
			longitude: data.lng

		update _.extend defaults.location, location