# intersections.coffee

define ["templates", "leaflet", 'leaflet.awesome-markers'], (templates, leaflet)->
	class Intersection
		constructor: (@data)->

		marker: (color = 'green')=>
			latlng = leaflet.latLng( @data.y, @data.x)
			# console.log latlng

			iconOptions =
				prefix: 'fa'
				icon: 'cutlery'
				markerColor: color
			icon = leaflet.AwesomeMarkers.icon iconOptions

			marker = leaflet.marker(latlng, icon: icon)
			marker.bindPopup templates['icon-popup'] this