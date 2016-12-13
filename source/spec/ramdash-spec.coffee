R = require 'ramda'
_ = require 'lodash'

fs = require 'fs'
util = require 'util'

chai = require 'chai'
expect = chai.expect

_R = require('ramdash')(R)

{ equal, deepEqual } = require './specHelpers'

getMaxLengths = (inputToExpected)->
  [ _.max _.map(_.keys(inputToExpected), 'length')
    _.max _.map(inputToExpected, 'length') ]

formatObjectToOneLine = (any) -> util.inspect(any, { colors:true }).replace(/\n /g, '')

getDefaultLine = (input, expected, maxLengths)->
  ipad = _.pad '', (maxLengths[0] - input.length) + 5, ' '
  epad = _.pad '', (maxLengths[1] - expected.length) + 5 , ' '
  "`'#{ input }'`#{ ipad } ---> #{ epad }`#{ formatObjectToOneLine expected }`"

runSpec = (inputToExpected, getLine, itTest)->
  if not itTest     # can also be called as runSpec(inputToExpected, itTest) for getdefaultLine
    itTest = getLine
    getLine = getDefaultLine

  maxLengths = getMaxLengths inputToExpected
  for input, expected of inputToExpected
    do (input, expected, maxLengths)->
      finalLine = line = getLine(input, expected, maxLengths)
      if _.isArray line
        finalLine = getDefaultLine line[0], line[1], maxLengths
        finalLine += line[2] if line[2] # extra line info
      # call the actual `it`
      it finalLine, itTest(input, expected)

VERSION = JSON.parse(fs.readFileSync('package.json')).version

#describe "\n# ramdash v#{VERSION}", ->
#  it "", -> equal _R.VERSION, "ramdash@#{VERSION}"
#
#  describe """\n
#  [![Build Status](https://travis-ci.org/anodynos/ramdash.svg?branch=master)](https://travis-ci.org/anodynos/ramdash)
#  [![Up to date Status](https://david-dm.org/anodynos/ramdash.png)](https://david-dm.org/anodynos/ramdash)
#

describe '_.each', ->
  it 'it expects two arguments', ->
    equal _R.each.length, 2

  _.each {
    'Array': ['a', 'b', 'c']
    'Object': {0: 'a', 1: 'b', 2: 'c'}
    'String': 'abc'
    }, (collection, typeName)->
      it "iterates over #{typeName}, calling `iterator(value, indexOrKey, collection)`", ->

        result = []
        _R.each collection, (val, indexOrKey, col)->
          result.push {val, indexOrKey: indexOrKey + '', col} # make indexOrKey a string to test Array/Object once

        deepEqual result, [
          {val: 'a', indexOrKey: '0', col: collection}
          {val: 'b', indexOrKey: '1', col: collection}
          {val: 'c', indexOrKey: '2', col: collection}
        ]

describe '_.map', ->
  it.skip 'it expects two arguments', -> #todo: we need flipToFront.2.3.4... for this to work
    equal _R.map.length, 2

  it "maps over an Array, calling `iterator(value, indexOrKey, collection)` and returning an array of projected values", ->
    collection = ['a', 'b', 'c']

    result = _R.map collection, (val, indexOrKey, col)->
      {val, indexOrKey: indexOrKey + '', col}

    deepEqual result, [
      {val: 'a', indexOrKey: '0', col: collection}
      {val: 'b', indexOrKey: '1', col: collection}
      {val: 'c', indexOrKey: '2', col: collection}
    ]

  it "does a pluck when iterator is String", ->
    collection = [
      {name: 'anodynos', email: 'agelos.pikoulas@gmail.com'}
      {name: 'angelos', email: 'angelos.pikoulas@gmail.com'}
    ]

    result = _R.map collection, 'name'

    deepEqual result, ['anodynos', 'angelos']

describe '_.mapValues', ->
  it 'it expects two arguments', ->
    equal _R.mapValues.length, 2

  it "maps over an Object, calling `iterator(value, indexOrKey, collection)` and returning an Object of projected values", ->
    obj = {0: 'a', 1: 'b', 2: 'c'}

    result = _R.mapValues obj, (val, key, col)-> {val, key, col}

    deepEqual result, {
     0: {val: 'a', key: '0', col: obj}
     1: {val: 'b', key: '1', col: obj}
     2: {val: 'c', key: '2', col: obj}
    }

describe '_.mapKeys', ->
  it 'it expects two arguments', ->
    equal _R.mapKeys.length, 2

  it "maps over an Object, calling `iterator(value, indexOrKey, collection)` and returning an Object of projected keys", ->
    obj = {0: 'a', 1: 'b', 2: 'c'}

    result = _R.mapKeys obj, (val, indexOrKey, col)->
      val + indexOrKey

    deepEqual result, {
      a0: 'a'
      b1: 'b'
      c2: 'c'
    }
