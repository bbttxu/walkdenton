# food.coffee

define ["templates", "leaflet", 'leaflet.awesome-markers'], (templates, leaflet)->
	class Food
		constructor: (@name, @tags, @coordinates)->

		marker: ()=>
			latlng = leaflet.latLng( @coordinates[1], @coordinates[0])
			iconOptions =
				prefix: 'fa'
				icon: 'cutlery'
				markerColor: 'green'
			icon = leaflet.AwesomeMarkers.icon iconOptions

			marker = leaflet.marker(latlng, icon: icon)
			marker.bindPopup templates['icon-popup'] this