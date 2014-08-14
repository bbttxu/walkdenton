# defaults.coffee

define [], ()->
	defaults =
		latitude: 33.215194
		longitude: -97.132788

		cache:
			current: 15
			recent: ( 60 * 24 * 7 )
