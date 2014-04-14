_    = require 'lodash'
util = require 'util'

# All patched methods by their name and implementation
patched = {}

# Wrap the given function and pass in excess parameters
# write the original functions reference to __org
wrap = (orgFn, fn, opts) ->
  wrapper       = _.partial fn, opts, orgFn
  wrapper.__org = orgFn
  wrapper

unwrap = (fn) -> fn.__org or fn

# Monkey patch all the functions in methods list
# and replace them with our very own ones
exports.patch = (opts = {}) =>
  opts = _.extend {}, @defaults, opts
  for name, fn of opts.methods
    # Assure that we are actually wrapping the original function
    # not the wrapper itself
    originalFn = unwrap util[name]
    patched[name] = util[name] = wrap originalFn, fn, opts
  @

# Restore all patched functions
exports.restore = ->
  for name, fn of patched
    util[name] = unwrap fn
    delete patched[name]
  @

exports.defaults =
  silent  : false
  verbose : false

  # Methods to override
  methods :
    log : ({ silent }, orgFn, str) ->
      orgFn str unless silent
    debug: ({ verbose }, orgFn, str) ->
      orgFn str if verbose
