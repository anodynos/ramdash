R = require 'ramda'
lodash = require 'lodash'

fs = require 'fs'
util = require 'util'

chai = require 'chai'
expect = chai.expect

# the lib under test
ramdash = require('ramdash')(R)

# helpers
{
  equal, notEqual # strictEqual, ===
  tru, fals       # true / false
  ok, notOk       # truthy / falsey

  deepEqual, notDeepEqual # _B.isEquals

  # using _B.is[XXX] for XXX in[Equals, Exact, Iqual, Ixact]
  exact, notExact
  iqual, notIqual
  ixact, notIxact
  like, notLike       # A is Like B
  likeBA, notLikeBA   # B is Like A

  equalSet, notEqualSet
} = require './specHelpers'

VERSION = JSON.parse(fs.readFileSync('package.json')).version

lodash.each [lodash, ramdash], (_R)->

  describe "Using #{ if _R is lodash then 'lodash' else 'ramdash' }", ->

    if _R is ramdash
      describe "\n# ramdash v#{VERSION}", ->
        it "has the correct version", -> equal _R.VERSION, "ramdash@#{VERSION}"

    describe '_.each', ->
      it 'it expects two arguments', ->
        equal _R.each.length, 2

      lodash.each {
        'Array': ['a', 'b', 'c']
        'Object': {0: 'a', 1: 'b', 2: 'c'}
        'String': 'abc'
        }, (collection, typeName)->

          result = []
          returnedValue =
            _R.each collection, (val, indexOrKey, col)->
              result.push {val, indexOrKey: indexOrKey + '', col} # make indexOrKey a string to test Array/Object once

          it "iterates over #{typeName}, calling `iterator(value, indexOrKey, collection)`", ->
            deepEqual result, [
              {val: 'a', indexOrKey: '0', col: collection}
              {val: 'b', indexOrKey: '1', col: collection}
              {val: 'c', indexOrKey: '2', col: collection}
            ]

          it "returns the collection passed", ->
            tru returnedValue is collection

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

        result = _R.mapKeys obj, (val, indexOrKey, col)-> val + indexOrKey
        deepEqual result, {a0: 'a', b1: 'b', c2: 'c'}

    describe '_.assign', ->
      a = {a: 'a1'}
      b = {b: 'b1', a: 'a2'}
      c = {c: 'c1'}

      it "copies all own properties of sources... onto target", ->
        target = {target: 'target'}
        result = _R.assign target, a, b, c
        deepEqual result, {target: 'target', a: 'a2', b: 'b1', c: 'c1'}
        tru result is target

      it "ignores sources... that are non object / have no props", ->
        target = {target: 'target'}
        result = _R.assign target, 1, null, undefined, '', [], /./, a, b, c
        deepEqual result, {target: 'target', a: 'a2', b: 'b1', c: 'c1'}
        tru result is target

      it "ignores not own properties of sources... ", ->
        target = {target: 'target'}
        a = Object.create {inherited: 'prop'}
        a.a = 'a1'
        result = _R.assign target, a, b, c
        deepEqual result, {target: 'target', a: 'a2', b: 'b1', c: 'c1'}
        tru result is target

      lodash.each [undefined, null], (target) ->
        it "if target is `#{target}`, its substituted with an empty object", ->
          result = _R.assign target, a, b, c
          deepEqual result, {a: 'a2', b: 'b1', c: 'c1'}
          fals result is target

      it "if target is Number, its substituted with a Number object of target value", ->
        target = 1
        result = _R.assign target, a, b, c
        expected = new Number(target)
        expected.a = 'a2'
        expected.b = 'b1'
        expected.c = 'c1'

        deepEqual result, expected
        fals result is target

      it "if target is String, its substituted with a String object of target value", ->
        target = "hello"
        result = _R.assign target, a, b, c

        expected = new String("hello")
        expected.a = 'a2'
        expected.b = 'b1'
        expected.c = 'c1'

        deepEqual result, expected
        fals result is target

      it "if target is Array, it copies all own properties of sources... onto target ", ->
        target = [1, 2, 3]
        result = _R.assign target, a, b, c

        expected = [1, 2, 3]
        expected.a = 'a2'
        expected.b = 'b1'
        expected.c = 'c1'

        deepEqual result, expected
        tru result is target

    describe '_.isEmpty', ->
      it 'it expects one argument', ->
        equal _R.isEmpty.length, 1

      lodash.each [
        [[], true]
        [{}, true]
        ['', true]
        [new String(''), true]
        [new String(), true]
        [undefined, true]
        [null, true]
        [-1, true]
        [0, true]
        [1, true]
        [new Number(-1), true]
        [new Number(1), true]
        [new Number(0), true]
        [new Number(), true]
        [/./, true]
        [/.a/g, true]
        [new RegExp('/.a/g'), true]

        [[0], false]
        [[undefined], false]
        [{a:1}, false]
        [{a:undefined}, false]
        ['0', false]
        [new String('0'), false]

      ], ([input, expected]) ->
        it """returns #{expected} for "#{input}" of type `#{R.type input}`""", ->
          equal _R.isEmpty(input), expected
