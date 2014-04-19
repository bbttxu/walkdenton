module.exports = (grunt)->
  #coffee_source =
  #  'assets/javascripts/'

  grunt.initConfig
    #docco:
    #  debug:
    #    src: [ coffee_source + '**/*.coffee']
    #    options:
    #      output: 'public/docs/'

    bump:
      options:
        commit: true
        commitMessage: "Release v%VERSION%"
        commitFiles: ["package.json"] # '-a' for all files
        createTag: true
        tagName: "v%VERSION%"
        tagMessage: "Version %VERSION%"
        push: true
        pushTo: "origin"
        gitDescribeOptions: "--tags --always --abbrev=1 --dirty=-d"

    #watch:
    #  docco:
    #    tasks:
    #      "docco"
    #    files:
    #      coffee_source + "**/*.coffee"

  #grunt.loadNpmTasks 'grunt-contrib-watch'
  #grunt.loadNpmTasks 'grunt-docco'
  #grunt.loadNpmTasks 'grunt-newer'
  grunt.loadNpmTasks('grunt-bump')
  grunt.registerTask 'default', [ 'bump' ]

