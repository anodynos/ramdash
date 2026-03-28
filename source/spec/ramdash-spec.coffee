R = require 'ramda'
lodash = require 'lodash'

fs = require 'fs'
util = require 'util'

chai = require 'chai'
expect = chai.expect

# the lib under test
ramdash = require('../code/ramdash')(R)

lodash.each [lodash, ramdash], (_R)->

  describe "############### Running all tests using #{ if _R is lodash then 'lodash' else 'ramdash' } ###############", ->

    describe '_.each', ->
      it 'it expects two arguments', ->
        expect(_R.each.length).to.equal(2)

      lodash.each {
        'Array': ['a', 'b', 'c']
        'Object': lodash.assign(Object.create({inherited: 'prop'}), {0: 'a', 1: 'b', 2: 'c'})
        'String': 'abc'
        }, (collection, typeName)->

          result = []
          returnedValue =
            _R.each collection, (val, indexOrKey, col)->
              result.push {val, indexOrKey: indexOrKey + '', col} # make indexOrKey a string to test Array/Object once

          it "iterates over #{typeName}, calling `iterator(value, indexOrKey, collection)`, omitting inherited?", ->

            expect(lodash.isEqual result, [   # expect(result).to.deep.equal [ fails on typeName: String
              {val: 'a', indexOrKey: '0', col: collection}
              {val: 'b', indexOrKey: '1', col: collection}
              {val: 'c', indexOrKey: '2', col: collection}
            ]).to.be.true

          it "returns the collection passed", ->
            expect(returnedValue is collection).to.be.true

    describe '_.map', ->
      it.skip 'it expects two arguments', -> #todo: we need flipToFront.2.3.4... for this to work
        expect(_R.map.length).to.equal(2)

      it "maps over an Array, calling `iterator(value, indexOrKey, collection)` and returning an array of projected values", ->
        collection = ['a', 'b', 'c']

        result = _R.map collection, (val, indexOrKey, col)->
          {val, indexOrKey: indexOrKey + '', col}

        expect(lodash.isEqual result, [
          {val: 'a', indexOrKey: '0', col: collection}
          {val: 'b', indexOrKey: '1', col: collection}
          {val: 'c', indexOrKey: '2', col: collection}
        ]).to.be.true

      it "does a pluck when iterator is String", ->
        collection = [
          {name: 'anodynos', email: 'agelos.pikoulas@gmail.com'}
          {name: 'angelos', email: 'angelos.pikoulas@gmail.com'}
        ]

        result = _R.map collection, 'name'

        expect(result).to.deep.equal ['anodynos', 'angelos']

    describe '_.mapValues', ->
      it 'it expects two arguments', ->
        expect(_R.mapValues.length).to.equal 2

      it "maps over an Object, calling `iterator(value, indexOrKey, collection)` and returning an Object of projected values", ->
        obj = {0: 'a', 1: 'b', 2: 'c'}

        result = _R.mapValues obj, (val, key, col)-> {val, key, col}

        expect(result).to.deep.equal {
         0: {val: 'a', key: '0', col: obj}
         1: {val: 'b', key: '1', col: obj}
         2: {val: 'c', key: '2', col: obj}
        }

    describe '_.mapKeys', ->
      it 'it expects two arguments', ->
        expect(_R.mapKeys.length).to.equal 2

      it "maps over an Object, calling `iterator(value, indexOrKey, collection)` and returning an Object of projected keys", ->
        obj = {0: 'a', 1: 'b', 2: 'c'}

        result = _R.mapKeys obj, (val, indexOrKey, col)-> val + indexOrKey
        expect(result).to.deep.equal {a0: 'a', b1: 'b', c2: 'c'}

    describe '_.reduce', ->
      add = (a, b) -> a + b

      it 'it expects 3 arguments', ->
        expect(_R.reduce.length).to.equal 3

      it "reduces array of integers with accumulator", ->
        result = _R.reduce [1, 2, 3], add, 10
        expect(result).to.equal 16

      it "uses the first element of the list if no accumulator is given", ->
        result = _R.reduce [1, 2, 3], add
        expect(result).to.equal 6

    describe '_.assign', ->
      a = {a: 'a1'}
      b = {b: 'b1', a: 'a2'}
      c = {c: 'c1'}

      it "copies all own properties of sources... onto target", ->
        target = {target: 'target'}
        result = _R.assign target, a, b, c
        expect(result).to.deep.equal {target: 'target', a: 'a2', b: 'b1', c: 'c1'}
        expect(result).to.equal target

      it "ignores sources... that are non object / have no props", ->
        target = {target: 'target'}
        result = _R.assign target, 1, null, undefined, '', [], /./, a, b, c
        expect(result).to.deep.equal {target: 'target', a: 'a2', b: 'b1', c: 'c1'}
        expect(result).to.equal target

      it "ignores not own properties of sources... ", ->
        target = {target: 'target'}
        a = Object.create {inherited: 'prop'}
        a.a = 'a1'
        result = _R.assign target, a, b, c
        expect(result).to.deep.equal {target: 'target', a: 'a2', b: 'b1', c: 'c1'}
        expect(result).to.equal target

      lodash.each [undefined, null], (target) ->
        it "if target is `#{target}`, its substituted with an empty object", ->
          result = _R.assign target, a, b, c
          expect(result).to.deep.equal {a: 'a2', b: 'b1', c: 'c1'}
          expect(result).to.not.equal target

      it "if target is Number, its substituted with a Number object of target value", ->
        target = 1
        result = _R.assign target, a, b, c
        expected = new Number(target)
        expected.a = 'a2'
        expected.b = 'b1'
        expected.c = 'c1'

        expect(result).to.deep.equal expected
        expect(result).to.not.equal target

      it "if target is String, its substituted with a String object of target value", ->
        target = "hello"
        result = _R.assign target, a, b, c

        expected = new String("hello")
        expected.a = 'a2'
        expected.b = 'b1'
        expected.c = 'c1'

        expect(result).to.deep.equal expected
        expect(result).to.not.equal target

      it "if target is Array, it copies all own properties of sources... onto target ", ->
        target = [1, 2, 3]
        result = _R.assign target, a, b, c

        expected = [1, 2, 3]
        expected.a = 'a2'
        expected.b = 'b1'
        expected.c = 'c1'

        expect(result).to.deep.equal expected
        expect(result).to.equal target

    describe '_.isEmpty', ->
      it 'it expects one argument', ->
        expect(_R.isEmpty.length).to.equal 1

      addProp = (val) ->
        val.prop = 'some-val'
        val

      testData = [
        [true, true]
        [false, true]
        [new Boolean(true), true]
        [new Boolean(false), true]

        [[], true]
        [addProp([]), true]
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

        # false ones
        [[0], false]
        [[undefined], false]
        [{a: 1}, false]
        [{a: undefined}, false]
        ['0', false]
        [new String('0'), false]
        [addProp(new Boolean true), false]
        [addProp(new Number 43), false]
        [addProp(new RegExp '/.a/g'), false]
        [addProp(new String ''), false]
      ]

      if typeof window is 'object'
        testData.push [document.querySelectorAll('body'), false]

        if lodash.includes(window.navigator.userAgent, 'PhantomJS') and _R isnt lodash # fails only phantomJS for some reason
          testData.push [document.querySelectorAll('.non-existent'), true]

      lodash.each testData, ([input, expected]) ->
        it """returns #{expected} for "#{input}" of type `#{R.type input}`""", ->
          expect(_R.isEmpty(input)).to.equal expected
