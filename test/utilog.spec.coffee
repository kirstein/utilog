mod   = require "#{process.cwd()}/src/utilog"
util  = require 'util'
sinon = require 'sinon'

describe 'utilog', ->
  afterEach -> mod.restore()

  it 'should exist', -> mod.should.be.ok

  describe '#patch', ->
    it 'should exist', -> mod.patch.should.be.an.Function
    it 'should should be chainable', -> mod.patch().should.eql mod

    it 'should write original fn as __org after multiple patching', ->
      orgFn = util.log
      mod.patch()
      mod.patch()
      util.log.__org.should.be.eql orgFn

    it 'should write original fn as __org', ->
      orgFn = util.log
      mod.patch()
      util.log.__org.should.be.eql orgFn

    it 'should overwrite log method', ->
      orgLog = util.log
      mod.patch()
      util.log.should.not.eql orgLog

  describe '#restore', ->
    it 'should exist', -> mod.restore.should.be.an.Function
    it 'should should be chainable', -> mod.restore().should.eql mod
    it 'should release overwritten log method', ->
      orgLog = util.log
      mod.patch()
      mod.restore()
      util.log.should.eql orgLog

  describe 'monkey patching', ->
    beforeEach -> mod.patch()

    describe '#log', ->
      it 'should pipe output to stdout', sinon.test ->
        @stub process.stdout, 'write'
        util.log 'lolo'
        process.stdout.write.args[0].toString().should.containEql 'lolo'

      it 'should not write to stdout if its silent', sinon.test ->
        @stub process.stdout, 'write'
        mod.patch silent: true
        util.log 'lolo'
        process.stdout.write.called.should.not.be.ok

    describe '#debug', ->
      it 'should not pipe to debuge if verbose set to false', sinon.test ->
        @stub process.stderr, 'write'
        mod.patch verbose : false
        util.debug 'hello'
        process.stderr.write.called.should.not.be.ok

      it 'should pipe to debug if verbose set to true', sinon.test ->
        @stub process.stderr, 'write'
        mod.patch verbose : true
        util.debug 'test'
        process.stderr.write.called.should.be.ok

      it 'should pipe to not debug if verbose set to false', sinon.test ->
        @stub process.stderr, 'write'
        mod.patch verbose : false
        util.debug 'test'
        process.stderr.write.called.should.not.be.ok
