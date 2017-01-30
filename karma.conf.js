// Karma configuration
// Generated on Thu Oct 30 2014 09:41:02 GMT+0000 (GMT Standard Time)
var argv = require('yargs').argv;

module.exports = function(config) {
  'use strict';

  var baseConfig = {

    // base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: './',

    // frameworks to use
    // available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['browserify', 'mocha'], //jasmine-ajax must come before jasmine, otherwise it will try to load before jasmine.

    // list of files / patterns to load in the browser
    files: [
      'source/**/*.coffee'
    ],

    // list of files to exclude
    exclude: [],

    // preprocess matching files before serving them to the browser
    // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
      'source/**/*.*': 'browserify'
    },

    browserify: {
      debug: true,
      transform: [ 'coffeeify'],
      extensions: ['.coffee']
    },

    // test results reporter to use
    // possible values: 'dots', 'progress'
    // available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['progress'],

    coverageReporter: {
      dir: 'coverage/',
      reporters: [{
        type: 'html',
        includeAllSources: true
      }, {
        type: 'text'
      }]
    },

    // web server port
    port: 9876,

    // enable / disable colors in the output (reporters and logs)
    colors: true,

    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_INFO,

    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: argv.watch,

    // start these browsers
    // available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: argv.watch ? [] : ['PhantomJS'],

    // Continuous Integration mode
    // if true, Karma captures browsers, runs the tests and exits
    singleRun: !argv.watch
  };

  config.set(baseConfig);
};
