module.exports = (R) ->
  # these are required from Ramda along with R.is
  {forEach, reduce, keys, type, isEmpty, equals} = R

  identity = (x) -> x

  _ = {
    VERSION: "ramdash@#{VERSION}"

    # @todo: break loop when false is returned, like lodash
    each: (collection, iteratee = identity) ->
      if (type(collection) is 'Array') or type(collection) is 'String'
        i = 0
        forEach (val) ->
          iteratee val, i++, collection
          return
        , collection
      else # assume {}
        forEach (key) ->
          iteratee collection[key], key, collection
          return
        , keys(collection)

      return collection

    # allow _.reduce to be used without initial/seed, using list[0] as seed.
    # It breaks if list is an {}
    reduce: (list, iterator, accumulator) ->
      ` // optimize for size
        return initial ?
          reduce(iterator, accumulator, list) :
          reduce(iterator, list[0], list.slice(1, +list.length + 1 || 9e9));
      `

    map: (arr, iteratee = identity) ->
      result = []
      i = 0
      forEach (val) ->
        result.push if type(iteratee) is 'Function'
          iteratee val, i++, arr
        else
          val[iteratee]

        return
      , arr

      return result

    mapValues: (obj, iteratee = identity) ->
      result = {}
      forEach (key) ->
        result[key] = iteratee obj[key], key, obj
        return
      , keys(obj)

      return result

    mapKeys: (obj, iteratee = identity) ->
      result = {}
      forEach (key) ->
        result[iteratee obj[key], key, obj] = obj[key]
        return
      , keys(obj)

      return result

    assign: (target = {}, sources...) ->
      forEach (theType) ->
        if R.is theType, target
          target = new theType target
        return
      , [Number, String]

      forEach (source) ->
        _.each source, (val, key) ->            # _.each cause we iterate keys
          if {}.hasOwnProperty.call source, key
            target[key] = val
          return
        return                                  # for size optimization :-)
      , sources

      return target

    isEmpty: (val) ->
      if not val or
          (type(val) in ['Null', 'Undefined', 'RegExp', 'Number']) or
          equals(val, new String(''))
        true
      else
        isEmpty val
  }

  return _;
