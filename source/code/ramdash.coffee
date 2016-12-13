module.exports = (R) ->
  # these are required from Ramda
  {forEach, reduce, keys, type, isEmpty, equals} = R

  identity = (x) -> x

  return {
    VERSION: "ramdash@#{VERSION}"

    # @todo: break loop when false is returned, like lodash
    each: (collection, iteratee = identity) ->
      if (type(collection) is 'Array') or type(collection) is 'String'
        i = 0
        forEach ((val) -> iteratee val, i++, collection), collection
      else # assume {}
        forEach (key) ->
          iteratee collection[key], key, collection
        , keys(collection)

    # allow _.reduce to be used without initial/seed, using list[0] as seed.
    # It breaks if list is an {}
    reduce: (list, iterator, accumulator) ->
      if initial
        reduce iterator, accumulator, list
      else
        reduce iterator, list[0], list[1..list.length]   #  breaks if list is an {}

    map: (arr, iteratee = identity) ->
      result = []
      i = 0
      forEach (val) ->
        result.push if type(iteratee) is 'Function'
          iteratee val, i++, arr
        else
          val[iteratee]

        undefined
      , arr

      return result

    mapValues: (obj, iteratee = identity) ->
      result = {}
      forEach (key) ->
        result[key] = iteratee obj[key], key, obj
      , keys(obj)

      return result

    mapKeys: (obj, iteratee = identity) ->
      result = {}
      forEach (key) ->
        result[iteratee obj[key], key, obj] = obj[key]
      , keys(obj)

      return result

    isEmpty: (val) ->
      if not val or
        (type(val) in ['Null', 'Undefined', 'RegExp', 'Number']) or
        equals(val, new String(''))
          return true
      else
        isEmpty val
  }
