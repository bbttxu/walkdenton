# defaults.coffee

define [], ()->
	defaults =
		###
		walking distance of the denton square
		###
		location:
			distance: 3
			latitude: 33.215194
			longitude: -97.132788

		###
		time in minutes
		###
		cache:
			current: 3
			# recent: ( 60 * 24 * 7 )
