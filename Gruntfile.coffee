module.exports = gruntFunction = (grunt) ->
  gruntConfig =
    urequire:
      _all:
        dependencies:
          imports: ramda: ['R']
        runtimeInfo: false
        bare: true
        template:
          name: 'nodejs'
          banner: true

      lib:
        path: 'source/code'
        main: 'ramdash'
        dstPath: 'build/code'
        resources: [ 'inject-version' ]

      spec:
        path: 'source/spec'
        dstPath: 'build/spec'
        afterBuild: require('urequire-ab-specrunner').options
          mochaOptions: '--bail'

      specWatch: derive: 'spec', watch: true

  splitTasks = (tasks)-> if (tasks instanceof Array) then tasks else tasks.split(/\s/).filter((f)->!!f)
  grunt.registerTask shortCut, "urequire:#{shortCut}" for shortCut of gruntConfig.urequire
  grunt.registerTask shortCut, splitTasks tasks for shortCut, tasks of {
    default: 'lib spec'
    dev: 'lib specWatch'
  }
  require('load-grunt-tasks') grunt
  grunt.initConfig gruntConfig
