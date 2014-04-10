_    = require 'lodash'
util = require 'util'

methods =
  log : ({ silent }, orgFn, str) ->
    orgFn str unless silent

# Wrap the given function and pass in excess parameters
# write the original functions reference to __org
wrap = (orgFn, fn, opts) ->
  wrapper       = _.partial fn, opts, orgFn
  wrapper.__org = orgFn
  wrapper

unwrap = (fn) -> fn.__org or fn

# Monkey patch all the functions in methods list
# and replace them with our very own ones
exports.patch = (opts = {}) ->
  opts = _.assign {}, @defaults, opts
  for name, fn of methods
    # Assure that we are actually wrapping the original function
    # not the wrapper itself
    originalFn = unwrap util[name]
    util[name] = wrap originalFn, fn, opts
  @

# Restore all patched functions
exports.restore = ->
  for name of methods
    util[name] = unwrap util[name]
  @

exports.defaults =
  silent  : false
  verbose : false
