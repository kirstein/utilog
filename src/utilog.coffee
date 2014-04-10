_    = require 'lodash'
util = require 'util'

methods =
  log : (opts, str) ->
    console.log str.toUpperCase()

wrap = (originalFn, fn, opts) ->
  wrapper       = _.wrap opts, fn
  wrapper.__org = originalFn
  wrapper

unwrap = (fn) -> fn.__org or fn

# Monkey patch all the functions in methods list
# and replace them with our very own ones
exports.patch = (opts) ->
  opts = _.extend {}, @defaults, opts
  for name, fn of methods
    originalFn = unwrap util[name]
    util[name] = wrap originalFn, fn, opts

# Restore all patched functions
exports.restore = ->
  for name of methods
    util[name] = unwrap util[name]

exports.defaults =
  silent  : true
  verbose : true
