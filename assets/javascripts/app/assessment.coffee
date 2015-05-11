# assessment.coffee

define ["leaflet", "postal", "app/defaults", "jquery", "models/intersection"], (L, postal, defaults, $, Intersection)->
	channel = postal.channel()

	intersections = []
	current = []

	options =
		dragging: false
		touchZoom: false
		scrollWheelZoom: false
		doubleClickZoom: false
		boxZoom: false
		zoomControl: false

	coordinates = [ defaults.location.latitude, defaults.location.longitude ]
	map = L.map('map', options).setView( coordinates, 16 )

	L.tileLayer("http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
		attribution: "Map data &copy; <a href=\"http://openstreetmap.org\">OpenStreetMap</a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"http://cloudmade.com\">CloudMade</a>"
		maxZoom: 18
	).addTo map


	locateOptions =
		setView: false
		maxZoom: 17
		watch: true
		timeout: 6000
		maximumAge: 6000
		enableHighAccuracy: true

	map.locate locateOptions

	currentMarkers = {}

	currentMarkerBounds = ()->
		latLngs = for key, markers of currentMarkers
			for marker in markers
				marker.getLatLng() if marker isnt undefined



	onLocationFound = (e) ->

		radius = e.accuracy / 2
		radius = 1000

		map.panTo e.latlng


	map.on "locationfound", onLocationFound

	onLocationError = (e) ->
		console.log e.message

	map.on "locationerror", onLocationError
	map.on "move", ()->
		channel.publish "intersections"


	findBounds = (markerArray)->
		L.latLngBounds markerArray.concat smallCircle.getLatLng()


	channel.subscribe "intersections", ()->

		bounds = map.getBounds()
		sw = bounds.getSouthWest()
		ne = bounds.getNorthEast()

		found = _.filter intersections, (intersection)->
			(intersection.y > sw.lat) and (ne.lat > intersection.y) and (intersection.x > sw.lng) and (ne.lng > intersection.x)

		sorted = _.sortBy found, (intersection)->
			map.getCenter().distanceTo new L.LatLng intersection.y, intersection.x

		ten = _.take sorted, 5

		markers = _.map ten, (one)->
			new Intersection(one).marker()

		_.each _.difference(markers, current), (marker)->
			marker.addTo map

		_.each _.difference(current, markers), (marker)->
			map.removeLayer marker

		current = markers


	getIntersections = $.getJSON "/data/inter_lite.json"

	handleIntersections = (data, response)->
		intersections = data

		channel.publish "intersections", data

	$.when(getIntersections).then(handleIntersections)





