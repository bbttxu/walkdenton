# # calendarViewModel.coffee

# define ["knockout", "underscore", "viewModels/calendarDayViewModel"], (ko, _, calendarDayViewModel)->
# 	calendarViewModel = ()->
# 		self = this
# 		self.calendar = ko.observable {}
# 		self.calendarDays = ko.computed ()->
# 			calendar = self.calendar()
# 			models = _.map calendar, (count, date, list)->
# 				new calendarDayViewModel date, count
# 			_.sortBy models, (object)->
# 				object.date()

# 			# _.sort calendarDays, (object)->
# 			# 	object.date
# 		# self.sortedCalendar = ko.computed ()->
# 		# 	calendar = self.calendar()
# 		# 	calendar = _.sortBy calendar, (obj)->
# 		self