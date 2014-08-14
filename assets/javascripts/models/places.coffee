# places.coffee

define ["underscore", "models/tag"], (_, Tag)->
	class Places
		constructor: (@foods, @filter)->

		tags: ()=>
			counted = _.countBy _.flatten _.map @foods, (food)->
				food.tags

			tags = _.map counted, (value, key)->
				new Tag key, value

			_.sortBy tags, (tag)->
				-tag.count

		tagFilter: (filter)=>
			@filter = filter

		filterByTag: (tag = @filter)=>
			_.filter @foods, (food)->
				_.contains food.tags, tag

		# display some text indicating the number of places nearby
		# TODO it would seem this shouldn't be in the model rather in the template?
		nearby: ()=>
			results = this.filterByTag()
			return "There is 1 place tagged '" + @filter + "'&nbsp;nearby." if results.length is 1
			"there are " + results.length + " places tagged '" + @filter + "'&nbsp;nearby."

