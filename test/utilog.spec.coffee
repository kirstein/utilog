mod  = require "#{process.cwd()}/src/utilog"
util = require 'util'

describe 'utilog', ->
  afterEach -> mod.restore()

  it 'should exist', -> mod.should.be.ok

  describe '#patch', ->
    it 'should exist', -> mod.patch.should.be.an.Function
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
    describe '#log', ->
      it 'should be false', ->
        orgLog = util.log
        mod.patch()
        util.log.should.not.eql orgLog
