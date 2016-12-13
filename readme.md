# ramdash v0.0.4 

[![Build Status](https://travis-ci.org/anodynos/ramdash.svg?branch=master)](https://travis-ci.org/anodynos/ramdash)
[![Up to date Status](https://david-dm.org/anodynos/ramdash.png)](https://david-dm.org/anodynos/ramdash)

(Some) lodash missing functions in ramda.

This project is considered an *early alpha* as it's covering only a small subset of lodash functions and their compatibility isn't perfect in edge cases. 

## Motivation 

Ramda is great for composing and mapping over things the FP way, but `_.each(things, (thing)=>....)` feels a lot more natural than `_.each(thing =>...., things)`. 

`R.flip` partially solves this, cause still you will not be receiving `(value, index, list)` but just the value. `R.addIndex` solves this, but you can see its getting too much of an annoyance, just for a bloody loop.

Also in `R.forEach` you can't iterate over Objects (as of December 2016, although its coming with a separate function with the longish name `forEachObjIndexed`). 

So `_.each` was motivation number one - it works just like lodash (__missing only the breaking of loop when iterator returns false__).      
 
In general, many iterator functions in Ramda accept only a `list` (i.e `[]`) whereas in lodash they accept a collection (i.e `[]` or `{}`). We have to adapt, but till then, some convenience please :-)  

Also lodash has the convenient `_.mapValues` and `_.mapKeys` so these are transferred over. 

There are some other nasty incompatibilties which I am hoping to cross over - please open an issue/PR if you want something added/changed. 

In overall, its not meant to replace ramda's existing functions which should be preferred, since you 've decided to make the `ramda` leap anyway!

## Lodash functions supported 

  * `_.each` like lodash, iterate over arrays and objects (and strings), passing `(val, idxOrKey, collection)` to iterator. NOT SUPPORTED is the breaking of the loop when `false` is returned by iterator.
   
  * `_.reduce` like lodash, supporting the default `accumulator` as the first item of the array. Objects are NOT SUPPORTED, it currently works only with arrays. 

  * `_.map`  like lodash's, along with the `pluck` / `_.property` iteratee shorthand  when iterator is a string.   

  * `_.mapValues` like lodash  

  * `_.mapKeys`   like lodash 
  
  * `_.isEmpty`   like lodash, solving nasty incompatibilities for `undefined`, `null`, `RegExp`, `Number` and new `String('')`

  * `_.assign`    like lodash
  
In iterating cases the Ramda [`forEach`](http://ramdajs.com/docs/#forEach) is used internally, so be aware of its caveats (it does not skip deleted or unassigned indices on sparse arrays). 
                                                           
## Usage:

Since it has NO dependency directly on `ramda`, you have to provide it so it can be injected - i.e:  

    var _ = require('ramdash')(R)  

If you have a custom R / requiring only specific modules, you need to pass an `R` object with these keys:

    forEach 
    reduce 
    keys 
    type 
    isEmpty 
    equals
    is

## License

The MIT License (MIT)

Copyright(c) 2016 Angelos Pikoulas (agelos.pikoulas@gmail.com)

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
