# places.coffee

define ["models/tag"], (Tag)->
	class Places
		constructor: (@foods)->

		tags: ()=>
			counted = _.countBy _.flatten _.map @foods, (food)->
				food.tags

			tags = _.map counted, (value, key)->
				new Tag key, value

			_.sortBy tags, (tag)->
				-tag.count

