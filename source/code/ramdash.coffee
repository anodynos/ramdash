###
Required from R:
  forEach
  reduce
  keys
  is
###

module.exports = (R) ->
  identity = (x) -> x

  return {
    VERSION: "ramdash@#{VERSION}"

    # @todo: break loop when false is returned, like lodash
    each: (collection, iteratee = identity) ->
      if R.is(Array)(collection) or R.is(String)(collection)
        i = 0
        R.forEach ((val) -> iteratee val, i++, collection), collection
      else # assume {}
        R.forEach (key) ->
          iteratee collection[key], key, collection
        , R.keys(collection)

    # allow _.reduce to be used without initial/seed, using list[0] as seed.
    # It breaks if list is an {}
    reduce: (list, iterator, accumulator) ->
      if initial
        R.reduce iterator, accumulator, list
      else
        R.reduce iterator, list[0], list[1..list.length]   #  breaks if list is an {}

    map: (arr, iteratee = identity) ->
      result = []
      i = 0
      R.forEach (val) ->
        result.push if R.is(Function) iteratee
          iteratee val, i++, arr
        else
          val[iteratee]

        undefined
      , arr

      return result

    mapValues: (obj, iteratee = identity) ->
      result = {}
      R.forEach (key) ->
        result[key] = iteratee obj[key], key, obj
      , R.keys(obj)

      return result

    mapKeys: (obj, iteratee = identity) ->
      result = {}
      R.forEach (key) ->
        result[iteratee obj[key], key, obj] = obj[key]
      , R.keys(obj)

      return result
  }
