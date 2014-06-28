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

  grunt.registerTask 'travis', []

  grunt.registerTask 'default', [ 'bump' ]

