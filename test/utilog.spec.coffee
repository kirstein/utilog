mod   = require "#{process.cwd()}/src/utilog"
util  = require 'util'
sinon = require 'sinon'

describe 'utilog', ->
  afterEach -> mod.restore()

  it 'should exist', -> mod.should.be.ok

  describe '#patch', ->
    it 'should exist', -> mod.patch.should.be.an.Function

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
        mod.patch silent: true
        @stub process.stdout, 'write'
        util.log 'lolo'
        process.stdout.write.called.should.not.be.ok

    describe '#debug', ->
      it 'should be false', ->
