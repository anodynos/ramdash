_ = require('lodash');
R = require('ramda');
#_R = require('../source/code/ramdash')(R);
_R = require('./ramdash')(R);
_B = require 'uberscore'
l = new _B.Logger

addProp = (val) ->
  val.prop = 'some-val'
  val

l.log _.isEmpty addProp(new Number 43)
l.log R.isEmpty addProp(new Number 43)
l.log _R.isEmpty addProp(new Number 43)


#l.log _.isEmpty false


_.each [
    addProp([])
  ], (v) ->
    l.ok v, 'TRUE', _.isEmpty(v), _R.isEmpty(v)
#    v.prop = 'val'
#    l.warn v, 'FALSE', _.isEmpty(v), _R.isEmpty(v)


#bool = new Boolean true
#l.log R.type true
#l.log R.is(Object, bool), R.type bool
#l.log R.is(Object, true)
