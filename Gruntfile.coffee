module.exports = (grunt)->
	grunt.initConfig
		bump:
			options:
				commit: true
				commitMessage: "Release v%VERSION%"
				commitFiles: ["package.json"] # '-a' for all files
				createTag: true
				tagName: "v%VERSION%"
				tagMessage: "Version %VERSION%"
				push: false
				pushTo: "origin"
				gitDescribeOptions: "--tags --always --abbrev=1 --dirty=-d"


		# jasmine:
		#   coverage:
		#     src: ["public/javascripts/**/*.js", "!public/javascripts/specs/**/*.js"]
		#     # options:
		#     #   specs: ["assets/javascripts/specs/**/*.js"]
		#     #   # template: require("grunt-template-jasmine-istanbul")
		#     #   # templateOptions:
		#     #   #   coverage: "bin/coverage/coverage.json"
		#     #   #   report: "bin/coverage"
		#     #   #   thresholds:
		#     #   #     lines: 75
		#     #   #     statements: 75
		#     #   #     branches: 75
		#     #   #     functions: 90

	grunt.loadNpmTasks('grunt-bump')
	# grunt.loadNpmTasks('grunt-contrib-jasmine')
	# grunt.loadNpmTasks('grunt-template-jasmine-istanbul')

module.exports = (grunt) ->
	grunt.initConfig
		mocha_istanbul:
			coverage:
				src: "public/javascripts/" # the folder, not the files,
				options:
					mask: "**/*.js"

			coveralls:
				src: "test" # the folder, not the files
				options:
					coverage: true
					check:
						lines: 75
						statements: 75

					root: "./lib" # define where the cover task should consider the root of libraries that are covered by tests
					reportFormats: [
						"cobertura"
						"lcovonly"
					]


		jasmine:
			src: "assets/javascripts/**/*.js"
			specs: "tests/*spec.js"
			helpers: "vendor/requirejs/require.js'"
			timeout: 10000
			# template: "src/custom.tmpl"
			junit:
				output: "junit/"

			coverage:
				output: "junit/coverage/"
				reportType: "cobertura"
				excludes: ["**/*.js"]

			phantomjs:
				"ignore-ssl-errors": true


	grunt.event.on "coverage", (lcovFileContents, done) ->
		console.log lcovFileContents
		# Check below
		done()
		return

	grunt.loadNpmTasks "grunt-mocha-istanbul"
	grunt.registerTask "coveralls", ["mocha_istanbul:coveralls"]
	grunt.registerTask "coverage", ["mocha_istanbul:coverage"]

	grunt.registerTask 'travis', ["mocha_istanbul"]

	grunt.loadNpmTasks('grunt-jasmine-coverage')
	grunt.registerTask 'default', [ 'bump' ]

