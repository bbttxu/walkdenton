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

  grunt.loadNpmTasks('grunt-bump')
  grunt.registerTask 'default', [ 'bump' ]

