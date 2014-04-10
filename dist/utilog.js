(function() {
  var methods, util, wrap, _;

  _ = require('lodash');

  util = require('util');

  methods = {
    log: function(opts, str) {
      return console.log(str.toUpperCase());
    }
  };

  wrap = function(originalFn, fn, opts) {
    var wrapper;
    wrapper = _.wrap(opts, fn);
    wrapper.__org = originalFn;
    return wrapper;
  };

  exports.patch = function(opts) {
    var fn, name, originalFn, _results;
    opts = _.extend({}, this.defaults, opts);
    _results = [];
    for (name in methods) {
      fn = methods[name];
      originalFn = fn.__org || util[name];
      _results.push(util[name] = wrap(originalFn, fn, opts));
    }
    return _results;
  };

  exports.restore = function() {
    var name, _results;
    _results = [];
    for (name in methods) {
      if (util[name].__org != null) {
        _results.push(util[name] = util[name].__org);
      }
    }
    return _results;
  };

  exports.defaults = {
    silent: true,
    verbose: true
  };

}).call(this);
