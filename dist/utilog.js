(function() {
  var patched, unwrap, util, wrap, _;

  _ = require('lodash');

  util = require('util');

  patched = {};

  wrap = function(orgFn, fn, opts) {
    var wrapper;
    wrapper = _.partial(fn, opts, orgFn);
    wrapper.__org = orgFn;
    return wrapper;
  };

  unwrap = function(fn) {
    return fn.__org || fn;
  };

  exports.patch = (function(_this) {
    return function(opts) {
      var fn, name, originalFn, _ref;
      if (opts == null) {
        opts = {};
      }
      opts = _.extend({}, _this.defaults, opts);
      _ref = opts.methods;
      for (name in _ref) {
        fn = _ref[name];
        originalFn = unwrap(util[name]);
        patched[name] = util[name] = wrap(originalFn, fn, opts);
      }
      return _this;
    };
  })(this);

  exports.restore = function() {
    var fn, name;
    for (name in patched) {
      fn = patched[name];
      util[name] = unwrap(fn);
      delete patched[name];
    }
    return this;
  };

  exports.defaults = {
    silent: false,
    verbose: false,
    methods: {
      log: function(_arg, orgFn, str) {
        var silent;
        silent = _arg.silent;
        if (!silent) {
          return orgFn(str);
        }
      },
      debug: function(_arg, orgFn, str) {
        var verbose;
        verbose = _arg.verbose;
        if (verbose) {
          return orgFn(str);
        }
      }
    }
  };

}).call(this);
